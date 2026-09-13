---
title: "API Design Under Failure"
summary: "Retry-safe API、idempotency key、pagination 與 recoverable errors"
description: "API failure handling、status codes、idempotency、pagination 與 recovery contract 複習筆記"
date: 2026-04-28
tags: ["api-design", "idempotency", "grpc", "pagination", "retries"]
categories: ["backend"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 複習重點

- Resource-oriented endpoint design and method semantics
- `POST` retry safety with durable idempotency records
- `PUT` / `PATCH` behavior and stale-write prevention
- `201` / `202` / `204` / `409` / `412` / `422` / `429` status-code choice
- Cursor pagination, invalid-cursor recovery, request IDs, trace IDs
- REST vs gRPC trade-offs and deadline propagation

## 心智模型

好的 backend API 不是只在 happy path 乾淨。它要定義 client timeout、retry、duplicate request、stale update、以及在資料變動中 pagination 時會發生什麼。

面試標準是：

```text
correctness under retries + clear recovery contract + observable request path
```

如果只說：

```text
REST is stateless and uses HTTP verbs
```

這不夠。比較完整的回答要同時包含：

- resource modeling
- method semantics
- status-code correctness
- retry behavior
- durable idempotency
- stale-write prevention
- structured error body
- request tracing and metrics

## Resource And Method Semantics

路徑應該描述 resource，method 才描述操作語意。

比較好的 resource-oriented endpoint：

```text
GET /patients/123
POST /appointments
PATCH /appointments/456
POST /appointments/456/cancellations
```

比較弱的 RPC-style endpoint：

```text
POST /getPatient
POST /updateAppointmentStatus
POST /createAppointment
```

`POST` 通常用於 server 建立新 resource 或 action result。它預設不是 idempotent，所以 payment/order/appointment create 這類 side-effect API 要另外設計 idempotency key。

`PUT` 通常表示 replace known resource 的完整 representation。重送同一個完整 request，最後狀態應該收斂到同一個結果。

`PATCH` 是 partial update。它可能 idempotent，也可能不是，取決於 patch semantics。

```text
PATCH { "status": "inactive" }          # usually idempotent
PATCH { "increment_balance_by": 100 }   # not idempotent
```

真正的 production nuance 是：`PUT` 或 `PATCH` 本身都不會自動防止 stale write。只要是 user 可能拿舊畫面提交更新，就還是要 version / ETag / `If-Match`。

## Status Codes You Must Be Crisp On

| Code | 什麼時候用 | 例子 |
|---|---|---|
| `201 Created` | 同步建立成功，而且 resource 現在已經存在 | `POST /appointments` 建立成功 |
| `202 Accepted` | request 被接受，但工作還在處理中 | async job、idempotent retry 發現同 key 還在 `processing` |
| `204 No Content` | 成功但刻意不回 body | delete、某些 update flow |
| `400 Bad Request` | request syntax 或基本格式錯 | JSON 壞掉、必要欄位格式不合法 |
| `401 Unauthorized` | 沒有有效 authentication | missing/expired token |
| `403 Forbidden` | 已 authentication，但沒有 authorization | 使用者不能看別院資料 |
| `409 Conflict` | request 和目前 resource state 或 operation contract 衝突 | 同 idempotency key 換 payload、已取消 appointment 要改成 checked-in |
| `412 Precondition Failed` | client 給的 explicit precondition 不成立 | `If-Match` / version mismatch 防 stale write |
| `422 Unprocessable Entity` | request 格式可理解，但 domain validation 不過 | `end_time < start_time`、invalid enum combination |
| `429 Too Many Requests` | rate limit | client 或 tenant 超出流量限制 |

`419` 要特別小心。它不是標準 HTTP status code，常見於某些 framework 或產品用來表示 session expired / CSRF token expired。面試或 public API 設計時，不要把 `419` 當通用 HTTP 語意；如果團隊內部真的用它，要在 API contract 明確定義。對一般 external API，比較安全是用標準 code 搭配 machine-readable error code。

## Retry-Safe Create

普通的 `POST /orders` 通常不是 idempotent。如果 client 在 DB commit 後 timeout，retry 同一個 request 可能產生 duplicate create。

比較安全的設計會用 idempotency key：

```text
Idempotency-Key: client-generated-unique-key
```

Server 需要存：

- idempotency key
- request fingerprint：method、path、normalized payload hash
- operation status：`processing`、`completed`、`failed`
- original response status code
- original response body 或 created resource id
- timestamps / expiry policy

Replay 規則：

- same key + same payload + `completed`：replay 原本 response 和原本 status code
- same key + same payload + `processing`：回 `202 Accepted`，並附 operation id 或 status URL
- same key + different payload：回 `409 Conflict`
- no record：原子建立 idempotency record，再執行 side effect

關鍵點：

```text
client timeout does not prove the side effect failed
```

Timeout 只代表 client 沒收到結果。Server 可能沒做、可能做到一半 rollback、也可能已經 commit 但 response 掉了。所以 retry-sensitive `POST` 一定要有 durable replay contract。

## 為什麼 Redis Lock 不夠

Lock 可以減少 concurrent execution，但它不是 durable source of truth。如果 process 在 DB commit 後、寫入 response record 或釋放 lock 前 crash，retry 仍然需要 durable idempotency record 判斷原本操作是否完成。

對 side-effect-heavy API，idempotency state 應該存在 durable storage，最好能和 business transaction 有一致性保證。

## Stale-Write Prevention

Update 題目常見問題不是 duplicate create，而是 lost update。可以用 version：

```text
If-Match: version-or-etag
```

Server 只在 submitted version 等於 current version 時更新。否則回傳：

```text
412 Precondition Failed
```

Client 收到 `412` 後不應該 blind retry 同一份 stale payload。比較好的 recovery flow 是：

1. fetch latest resource
2. reapply change if still valid
3. 需要人工判斷時請使用者 reconcile
4. 用新的 version / ETag 再送

錯誤 body 應該讓 client 能 recover：

```json
{
  "error": {
    "code": "STALE_VERSION",
    "message": "Resource was updated by another request",
    "current_version": 8,
    "request_id": "abc-123"
  }
}
```

`409` 和 `412` 的差別：

- `412`: client 帶了 explicit precondition，而 precondition 失敗
- `409`: request 和目前 business/resource state 衝突，但不一定是 `If-Match` 這種 precondition

## Pagination

Offset pagination 簡單，但在大量且持續變動的資料上不穩：

```text
GET /items?page=10&limit=20
```

Cursor pagination 比較安全：

```text
GET /items?cursor=opaque_token&limit=20
```

Cursor 要 encode stable ordering key，例如：

```text
(created_at, id)
```

這樣 inserts/deletes 才不容易造成 duplicate 或 skipped rows。只用 `created_at DESC` 不夠，因為多筆資料可能同 timestamp，需要 `id` 這種 tie-breaker 建立 deterministic total order。

Response shape 應該包含：

```json
{
  "items": [],
  "next_cursor": "opaque-token",
  "has_more": true,
  "request_id": "abc-123"
}
```

Invalid or expired cursor 不應該讓 client 猜。可以用 `400` 或 `422`，但 contract 要固定，並附 recovery action：

```json
{
  "error": {
    "code": "INVALID_CURSOR",
    "message": "The pagination cursor is invalid or expired",
    "action": "restart_from_first_page",
    "request_id": "abc-123"
  }
}
```

## REST vs gRPC

REST 通常適合 public APIs，因為簡單、容易 cache、各種 client 都好接。gRPC 適合 internal service-to-service，因為有 strict contracts、binary encoding、streaming、deadline propagation。

筆記裡的重要點：

```text
gRPC deadlines must propagate downstream.
```

否則上游服務 timeout 了，下游工作還繼續跑，會浪費資源。

但不要說：

```text
gRPC is just faster than HTTP
```

比較安全的講法是：gRPC 對 internal service-to-service 很強，因為 contract、deadline、streaming、codegen 都比較一致；REST 對 external API 通常比較通用、可 debug、容易和瀏覽器 / third-party client 整合。

## Request Path And Failure Hooks

完整 request path 回答可以這樣串：

```text
browser -> DNS -> TCP/TLS -> L7 gateway/load balancer -> FastAPI -> DAL -> Oracle -> response
```

在這條路上要放對東西：

- gateway / edge: TLS termination, WAF, rate limiting, coarse authn
- app: payload validation, authz, idempotency check, business invariant
- DAL / DB: transaction, constraints, lock/version behavior
- response: status code, structured error, request id / trace id

Timeout pushback 的回答是：

```text
timeout is an unknown outcome, not proof of failure
```

所以 write path 要靠 idempotency key、traceability、以及可 replay 的 stored result。

## 要量測什麼

- request id and trace id
- idempotency key and replay outcome
- payload hash mismatch
- timeout count by endpoint
- retry count
- `409` conflict count
- `412` stale-version count
- `422` validation-error count
- invalid cursor count
- `429` rate-limit count
- p95 and p99 latency
- DB connection-pool wait time
- downstream timeout / deadline exceeded count

## 面試回答形狀

我會先從 failure 設計 API。對有 side effects 的 create endpoint，我用 durable idempotency key，存 method/path/payload fingerprint、status、original response status 和 body。client timeout 後 retry，同 key同 payload如果 completed 就 replay 原結果；如果 processing 就回 `202` 和 status URL；如果同 key不同 payload 就回 `409`。對 update，我用 version 或 ETag + `If-Match`，stale 就回 `412`，讓 client fetch latest 後 reconcile。`422` 用在 payload 格式可理解但 domain validation 不過，`419` 則不是標準 HTTP code，不應當成通用 API 語意。Pagination 用 deterministic cursor，例如 `(created_at, id)`，invalid cursor 要回 structured error 和 recovery action。最後用 request ID、trace ID、metrics 讓 client 和 operator 都能 recover。
