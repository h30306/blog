---
title: "API Design Under Failure"
summary: "Retry-safe API、idempotency key、pagination 與 recoverable errors"
description: "Production API failure handling、status codes、idempotency、pagination、concurrency 與 recovery contract 複習筆記"
date: 2026-04-28
tags: ["api-design", "idempotency", "grpc", "pagination", "retries", "observability"]
categories: ["backend"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 複習重點

- 在 timeout、retry、duplicate request、partial success、stale state 下設計 API
- side-effecting `POST` 的 idempotency-key contract
- idempotency record、business row、external side effect 之間的 transaction ordering
- `201` / `202` / `204` / `409` / `412` / `422` / `429` 的邊界
- 在資料持續變動時做 cursor pagination
- REST vs gRPC 的 trade-off、deadline propagation、request tracing
- 讓 client 和 operator 都能 recovery 的 metrics / logs

## Tier A/S 判斷

這個 topic 的基本版還不夠 Tier A/S。只背 HTTP verbs 和 status codes，聽起來比較像文件整理，不像能處理 production failure。

比較強的面試開場是：

```text
An API contract is incomplete until it defines what clients should do after timeout, retry, duplicate submission, stale writes, partial downstream failure, and pagination over changing data.
```

Tier A/S 要讓面試官聽到你不只知道 code，而是能設計 write path：

- 哪些 state 要 durable storage
- 哪些操作可以 retry
- 哪些操作不能 blind retry
- race condition 怎麼擋
- client 怎麼不用猜就能 recover
- production incident 發生後怎麼 debug

## 用一個場景綁住回答

可以用 hospital backend 當例子：

```text
POST /appointments
PATCH /appointments/{appointment_id}
POST /appointments/{appointment_id}/cancellations
GET /patients/{patient_id}/appointments?cursor=...
```

真正困難的不是 happy path，而是：

```text
Client 送出 POST /appointments。
API 已經 commit appointment。
Response 因為 timeout 掉了。
Client retry。
```

如果沒有 replay contract，retry 可能造成重複 appointment、重複扣款、或重複通知。

## Resource And Method Semantics

Path 應該描述 resource，HTTP method 描述操作語意。

比較好的 resource-oriented endpoints：

```text
GET    /patients/123
POST   /appointments
PATCH  /appointments/456
POST   /appointments/456/cancellations
```

比較弱的 RPC-style endpoints：

```text
POST /getPatient
POST /updateAppointmentStatus
POST /createAppointment
```

重要 nuance：

- `GET` 應該是 safe，不應該改變 business state。
- `POST` 預設不是 idempotent，所以有 side effect 的 create API 要明確設計 idempotency。
- `PUT` 通常代表 replace known resource 的完整 representation。重送同一個 request，最後狀態應該收斂到同一個結果。
- `PATCH` 要看語意。`PATCH { "status": "inactive" }` 通常 idempotent；`PATCH { "increment_balance_by": 100 }` 不是。
- `PUT` / `PATCH` 不會自動防 stale write。要靠 version、ETag、或 `If-Match`。

## Retry-Safe Create Contract

Retry-safe create endpoint 通常接受：

```text
Idempotency-Key: client-generated-unique-key
```

Server 要存 durable idempotency record：

```text
idempotency_key
tenant_id / user_id
method
path
normalized_payload_hash
status: processing | completed | failed
resource_id
response_status
response_body
expires_at
created_at
updated_at
```

Replay rules：

| 狀況 | 回應 |
|---|---|
| same key, same payload, `completed` | replay 原本 response 和原本 status |
| same key, same payload, `processing` | 回 `202 Accepted`，附 operation id 或 status URL |
| same key, different payload | 回 `409 Conflict` |
| retry-sensitive write 沒 key | 回 `400` 或要求 client 產生 key |
| 沒有既有 record | 原子建立 idempotency record，再執行 write |

面試一定要講出的句子：

```text
Client timeout is an unknown outcome, not proof that the server failed.
```

Server 可能完全沒開始、可能做到一半 rollback、也可能已經 commit 只是 response 掉了。

## Transaction Ordering

這段是把答案拉到面試強度的地方。

對 payment、order、appointment create，idempotency record 必須在 correctness boundary 裡。一個常見流程是：

```text
BEGIN
  INSERT idempotency record if absent
  lock/read idempotency record
  validate payload fingerprint
  create appointment row
  update idempotency record to completed with response payload
COMMIT
```

Idempotency key 要有 tenant/user scope 的 unique constraint：

```sql
UNIQUE (tenant_id, idempotency_key)
```

不要只用 in-memory cache 或 Redis lock 當 source of truth。Lock 可以降低 concurrent execution，但如果 process 在 business commit 後 crash，retry 仍然需要 durable replay record 判斷原本操作完成到哪裡。

如果 API 還會送 email、publish event、或呼叫 payment provider，不要把 external side effect 直接塞在 DB transaction 裡。比較好的做法是 outbox/event table：

```text
transaction commits appointment + outbox event
background worker publishes event
consumer side is also idempotent
```

這樣 DB commit 成功但 downstream notification 失敗時，系統還有可恢復路徑。

## Failure Matrix

| Failure | 沒設計會怎樣 | 強 contract |
|---|---|---|
| client timeout after commit | retry 產生 duplicate create | idempotency replay |
| two concurrent retries | 兩筆資料或 lock race | unique key + transactional idempotency record |
| same key, different payload | accidental overwrite | `409 IDEMPOTENCY_KEY_REUSED` |
| process crash after DB commit | client 無法知道結果 | completed idempotency record 或 recoverable reconciliation |
| downstream email/payment failure | partial success 被藏起來 | outbox + operation status |
| stale update from old UI | lost update | `If-Match` version check + `412` |
| invalid cursor | client loop 或漏資料 | structured error + restart action |

## Status Codes You Must Be Crisp On

| Code | 什麼時候用 | 例子 |
|---|---|---|
| `201 Created` | 同步建立成功，resource 現在已存在 | `POST /appointments` 建立 appointment |
| `202 Accepted` | request 已接受，但工作還在處理 | async operation、同 idempotency key 還在 `processing` |
| `204 No Content` | 成功但刻意不回 body | delete、某些 update flow |
| `400 Bad Request` | syntax 或基本 request 格式錯 | malformed JSON |
| `401 Unauthorized` | 沒有有效 authentication | missing / expired token |
| `403 Forbidden` | 已 authentication，但沒有 authorization | user 不能看其他 hospital tenant |
| `409 Conflict` | 和目前 state 或 operation contract 衝突 | 同 idempotency key 換 payload |
| `412 Precondition Failed` | client 明確帶的 precondition 失敗 | `If-Match` version mismatch |
| `422 Unprocessable Entity` | request 可理解，但 domain validation 不過 | `end_time < start_time` |
| `429 Too Many Requests` | client 或 tenant 超出 rate limit | quota reset 後再 retry |

`419` 要小心。它不是標準 HTTP status code。有些 framework 會拿來表示 session expired / CSRF token expired，但 public API 不應該把它當通用 HTTP 語意。比較穩的是用標準 status code 加上 machine-readable error code。

## Error Body Contract

Client 不應該 parse human text。要給穩定的 machine-readable fields：

```json
{
  "error": {
    "code": "STALE_VERSION",
    "message": "Resource was updated by another request",
    "retryable": false,
    "recovery": "fetch_latest_and_reapply",
    "current_version": 8,
    "request_id": "req_abc",
    "trace_id": "trace_xyz"
  }
}
```

有用欄位：

- `code`: 穩定 application error code
- `message`: 給人看的，不拿來做 branching
- `retryable`: 是否可以自動 retry
- `recovery`: client 下一步該做什麼
- `request_id` / `trace_id`: support ticket 與 distributed tracing hook
- optional domain fields，例如 `current_version` 或 `retry_after_seconds`

## Stale-Write Prevention

Update path 常見問題不是 duplicate create，而是 lost update。

用 versioning：

```text
GET /appointments/456
ETag: "v7"

PATCH /appointments/456
If-Match: "v7"
```

Server 只在 submitted version 等於 current version 時更新。如果別人先改過 appointment，就回：

```text
412 Precondition Failed
```

Client 不應該 blind retry stale payload。Recovery flow：

1. fetch latest resource
2. reapply intended change if still valid
3. 如果是語意衝突，請使用者 reconcile
4. 用新的 version 再 submit

`409` vs `412`：

- `412`: client 帶了 explicit precondition，而且 precondition 失敗
- `409`: request 和目前 business/resource state 衝突，不一定是 `If-Match`

## Pagination Under Change

Offset pagination 很簡單：

```text
GET /items?page=10&limit=20
```

但在大量且持續變動的資料上不穩。Page request 中間如果有 insert/delete，可能 duplicate 或 skip items。

Cursor pagination 通常比較強：

```text
GET /appointments?cursor=opaque_token&limit=20
```

Cursor 要 encode deterministic ordering boundary：

```text
(created_at, id)
```

只用 `created_at DESC` 不夠，因為多筆資料可能同 timestamp。要加 `id` 這類 tie-breaker 形成 total order。

Response shape：

```json
{
  "items": [],
  "next_cursor": "opaque-token",
  "has_more": true,
  "request_id": "req_abc"
}
```

Invalid or expired cursor：

```json
{
  "error": {
    "code": "INVALID_CURSOR",
    "message": "The pagination cursor is invalid or expired",
    "retryable": false,
    "recovery": "restart_from_first_page",
    "request_id": "req_abc"
  }
}
```

## Rate Limits And Abuse Boundaries

Failure design 也包含保護服務本身。

Rate limit scope 要對應真實 blast radius：

- per user：一般產品使用
- per tenant：避免單一客戶拖垮系統
- per IP：匿名 abuse
- per API key：external integration
- per endpoint：昂貴 writes 或 export

回 `429` 時要給清楚 retry contract：

```text
Retry-After: 30
```

不要讓 retry logic 變成 self-DDoS。Client 應該用 exponential backoff with jitter、尊重 server deadline，而且沒有 idempotency key 時不要 retry non-idempotent write。

## REST vs gRPC

REST 通常適合 public APIs：

- mental model 簡單
- browser / third-party compatibility 好
- 用常見 HTTP tooling debug 容易
- cache-friendly semantics

gRPC 通常適合 internal service-to-service：

- strict protobuf contracts
- code generation
- streaming
- efficient binary encoding
- deadline / cancellation 是一等公民

重要 production point：

```text
gRPC deadlines must propagate downstream.
```

如果 caller timeout 了，但 downstream services 還繼續做，系統會把資源燒在沒人等的 work 上。強回答會提到 deadlines、cancellation、retry budgets、circuit breaking。

## Request Path And Failure Hooks

完整 request path 可以這樣畫：

```text
browser -> DNS -> TCP/TLS -> L7 gateway/load balancer -> FastAPI -> service layer -> DAL -> Oracle -> response
```

責任要放對 layer：

- gateway: TLS termination、WAF、request size limits、coarse authentication、rate limiting
- app: schema validation、authorization、idempotency check、business invariant checks
- service layer: transaction boundary、downstream deadline、retry policy
- DAL / DB: constraints、isolation、version checks、unique keys
- response: status code、structured error、request id、trace id

## 要 Log / Measure 什麼

最少要有：

- request id and trace id
- authenticated user and tenant，但不要 leak sensitive data
- endpoint、method、status code、latency
- idempotency key outcome：`new`、`replayed`、`processing`、`payload_mismatch`
- retry count and timeout count by endpoint
- `409`、`412`、`422`、`429` rate
- invalid cursor rate
- DB connection-pool wait time
- transaction retry / deadlock count
- downstream timeout / deadline-exceeded count
- p95 and p99 latency

面試級講法：

```text
I want logs for individual debugging, metrics for trend detection, and traces for cross-service causality.
```

## Common Mistakes

- 把 timeout 當成 failure，而不是 unknown outcome
- idempotency state 只放 Redis，沒有 durable replay
- idempotency key 由 server 在收到 duplicate request 後才產生
- 同 key 不同 payload 卻 replay response
- 把 `PATCH increment` 當 idempotent retry
- 混用 `409` 和 `412`
- cursor pagination 沒有 tie-breaker
- 只回 human-readable error，沒有 machine-readable recovery code
- upstream timeout 後 downstream work 還繼續跑

## 面試回答形狀

60-90 秒版本：

```text
I design APIs around recoverability. For side-effecting POST endpoints, retries need idempotency keys backed by durable storage. The server stores the payload fingerprint, operation status, and original response, so a retry after timeout can replay completed work, return 202 for processing work, or 409 if the key is reused with a different payload. For updates, I use ETag/version with If-Match and return 412 for stale writes. Errors include stable codes, retryability, recovery action, request id, and trace id. For list endpoints, I prefer cursor pagination with a deterministic key like created_at plus id. Then I measure retries, conflicts, stale writes, rate limits, latency, and downstream deadline failures.
```

10-15 分鐘 deep dive 可以照這個順序講：

1. resource model and method choice
2. idempotency table and unique constraints
3. transaction sequence for create
4. replay rules for timeout and duplicate requests
5. stale update handling with `If-Match`
6. structured error response
7. cursor pagination
8. observability and rate-limit protection

30-45 分鐘 design discussion 要能畫：

```text
client
  -> gateway/rate limit/authn
  -> API service/idempotency check/authz
  -> DB transaction/business rows/idempotency rows/outbox rows
  -> worker/downstream service
  -> logs/metrics/traces
```

然後能回答 pushback：

- 如果 client 在第一個 request 還 processing 時 retry 怎麼辦？
- 如果同一個 idempotency key 被拿去送不同 payload 怎麼辦？
- 如果 DB commit 成功但 response 掉了怎麼辦？
- 如果 notification 成功但 API 回 500 怎麼辦？
- 如果兩個 user 從舊畫面更新同一個 appointment 怎麼辦？
- 如果 pagination 過程中有新 rows 被 insert 怎麼辦？
- 如果 downstream service 不尊重 cancellation 怎麼辦？

## 最後要記

Tier A/S 答案不是「用 REST 和 status codes」。真正的答案是：

```text
define the recovery contract, store enough durable state to honor it, make unsafe retries impossible or explicit, and expose enough telemetry to debug the path when the distributed system lies.
```
