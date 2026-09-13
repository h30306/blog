---
title: "Replication Lag And Replica Routing"
summary: "把 read replica 從讀流量擴充，講到 read-after-write correctness 和 routing policy"
description: "Primary/replica、replication lag、read-after-write consistency 的資料庫擴展複習筆記"
date: 2026-05-26
tags: ["database", "database-scaling", "replication", "read-replica", "consistency"]
categories: ["database"]
aliases:
  - /zh-tw/distribution-system/replication-lag-and-replica-routing/
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 複習重點

這篇要處理的不是「replica 可以分擔 read」這種表層答案。

Tier A/S 強度要能回答：

- primary / replica write path 長什麼樣
- replication lag 會造成哪一種使用者可見 bug
- 哪些 endpoint 必須 read-your-writes，哪些可以接受 stale data
- write 後的 immediate read 要怎麼 route
- lag 超過預期 window 時要 fallback、pending、還是 degrade
- 為什麼 replicas 不會修好 bad query / missing index / primary write bottleneck
- 要量哪些 metrics 才知道 replica routing 真的健康

一句話：

```text
Read replicas scale stale-tolerant reads, not every read.
The hard part is deciding which reads are allowed to be stale.
```

## Tier A/S 判斷

如果答案只有：

```text
replicas help reads, but replication lag may make data stale
```

這還不夠。

強回答需要補上：

- write 已經在 primary commit，不代表 replica 也立刻可見
- lag 不是抽象 eventual consistency，而是 read-after-write inconsistency
- freshness policy 應該按 endpoint 決定，不是全站同一條規則
- post-write read 可以 primary pin、session stickiness、resource stickiness，或使用 version / LSN / timestamp gating
- fixed sticky window 是 heuristic，不是 correctness proof
- lag spike、failover、reporting query、long apply backlog 都會讓策略失效
- observability 要能回答「這次 stale 是 replica lag、cache、還是 routing bug」

## Primary / Replica Mental Model

最基本的資料流：

```text
client
  -> API service
  -> write transaction on primary
  -> commit success
  -> replication stream / log shipping / apply on replica
  -> later reads may hit primary or replica
```

Replica 的價值：

- 分擔 read QPS
- 隔離某些 read-heavy workload
- 讓 reporting / dashboard 不一定壓在 primary 上
- 提供 HA / failover 架構的一部分

但 replica 的成本：

- freshness 不再是單一答案
- routing policy 變成 correctness decision
- lag spike 會變成 product bug
- debugging 要追 read source 和 observed version

## 典型 Product Bug

Appointment confirmation：

```text
POST /appointments/123/confirm
  -> primary commit success

GET /appointments/123
  -> routed to lagging replica
  -> returns old status = PENDING
```

使用者看到的不是「系統 eventually consistent」。

使用者看到的是：

- 剛剛明明成功，畫面卻還沒更新
- 重按 confirm
- 找客服
- 下游流程根據舊狀態做 decision

Billing / payment 更危險：

```text
payment captured on primary
invoice page reads lagging replica
UI still shows unpaid
user retries payment
```

這會把 stale read 轉成 duplicate-action risk。

所以面試答案要先講 product impact，不要只講資料庫同步延遲。

## Freshness 分級

不要說：

```text
all reads go to replicas
```

也不要說：

```text
all reads go to primary
```

比較好的做法是把 endpoint 分級。

### Primary-Consistent Reads

這類 read 需要看見最新狀態，通常走 primary 或強制 freshness gate。

例子：

- payment result after charge
- appointment booking / confirmation result
- patient record immediately after update
- mutation workflow 的下一步 validation
- idempotency result lookup after retry
- admin action 成功後的 immediate status read

判斷標準：

```text
If stale data can cause duplicate action, wrong workflow, or user-visible contradiction,
do not blindly route it to a replica.
```

### Bounded Read-Your-Writes

這類 read 平常可以走 replica，但 write 後的一段時間需要 fresh。

例子：

- 使用者更新 profile 後馬上刷新
- appointment list 在剛新增或取消後
- case note list 在剛新增 note 後

常見策略：

```text
after a successful write, pin related reads to primary for N seconds
```

或：

```text
after a successful write, pin reads for this user / session / resource to primary
until freshness is proven.
```

### Stale-Tolerant Reads

這類可以走 replica。

例子：

- reporting dashboard
- historical logs
- read-mostly reference data
- catalog-like lookup
- aggregate metrics with freshness label

但要說清楚：

```text
stale-tolerant does not mean unboundedly stale.
```

Dashboard 可以接受「資料延遲 30 秒」，但不代表可以顯示昨天的資料而沒有告警。

### Async / Pending UX

有些流程不能保證立即可見，或保證成本太高。

這時候比起顯示錯的舊狀態，更好的做法可能是：

- `processing`
- `pending confirmation`
- `refreshing`
- `last updated at`
- 暫時 disable duplicate action button

這不是逃避 consistency，而是把不可保證的 freshness 誠實呈現給使用者。

## Read-After-Write Routing 策略

### Strategy 1 - Endpoint-Based Primary Routing

最直接：

```text
freshness-critical endpoints always read primary
```

優點：

- 正確性直覺清楚
- debug 簡單
- 不依賴 lag window 猜測

缺點：

- primary 負載比較高
- 如果分類過寬，就吃不到 replica 的 read scaling

適合：

- payment status
- booking confirmation
- user action 後的 critical status

### Strategy 2 - Sticky Read-After-Write Window

常見實務做法：

```text
after write success, route related reads to primary for 5-30 seconds
```

stickiness 可以綁：

- session
- user
- tenant
- resource id
- request context

優點：

- 實作相對簡單
- 對常見短 lag 有效
- 不需要每個 replica 都支援精準 catch-up 查詢

缺點：

- window 太短：lag spike 時仍讀到 stale
- window 太長：primary 被太多 read 打回來
- 多 device / 多 session 可能沒有共享同一個 marker
- 這是 heuristic，不是嚴格 correctness proof

面試要講這句：

```text
Sticky read-after-write is practical, but it is still a bounded heuristic unless tied to real freshness signals.
```

### Strategy 3 - Version / Timestamp / LSN Gating

更強的做法是讓 read 帶著 freshness requirement。

例如 write 回傳：

```json
{
  "appointment_id": "123",
  "status": "CONFIRMED",
  "commit_version": "v84291"
}
```

後續 read 要求：

```text
serve from a replica only if replica_version >= v84291
otherwise route to primary or return pending
```

可能使用的 marker：

- commit timestamp
- monotonically increasing version
- log sequence number / GTID / WAL position
- application-level updated_at with caveats

優點：

- 比 fixed window 更接近 correctness
- 可以避免 lag 很短時過度打 primary
- 可以在 lag spike 時準確 fallback

缺點：

- 依賴資料庫 / middleware 能暴露可比較的 replication progress
- 系統複雜度提高
- clock-based marker 要小心 clock skew 和語意不精準

### Strategy 4 - Lag-Aware Replica Selection

如果有多個 replicas，不要隨機選。

可以依照：

- lag threshold
- region / latency
- workload class
- query type
- replica health

來選 replica。

例如：

```text
critical stale-tolerant reads require replica lag < 2s
analytics reads can tolerate lag < 5m
```

如果所有 replica 都超過 threshold：

- route to primary
- return stale data with label
- disable non-critical panel
- return `202` / pending for async workflow

## Failure Matrix

| Failure | 使用者看到什麼 | 可能原因 | 正確反應 |
|---|---|---|---|
| Immediate read misses new row | 剛建立的資料不見 | read hit lagging replica | primary pin 或 version gate |
| Old status after successful mutation | UI 顯示舊狀態 | replica lag 或 cache stale | log source，freshness-critical path bypass stale layer |
| Sticky window 失效 | 偶發 stale bug | lag spike > fixed window | dynamic fallback 或 primary read |
| Replica slow but not stale | read latency 高 | expensive query / overloaded replica | query/index fix，read pool isolation |
| Primary still overloaded | replicas 加了還是慢 | writes / critical reads / locks 都在 primary | narrow primary-consistent reads，fix write path |
| Different refresh sees different data | replica A/B lag 不同 | load balancing across replicas | session affinity 或 version-aware routing |
| Stale cache refilled from stale replica | cache 又裝回舊值 | cache miss 從 lagging replica 補 | post-write bypass 或 refill from primary |
| Failover 後 routing 錯 | writes/read 路由到錯角色 | topology change | role discovery、health check、circuit breaker |

## Replicas 解不了什麼

Replicas 是 read scaling tool，不是萬用 DB fix。

它解不了：

- bad query shape
- missing / wrong index
- non-SARGable predicate
- over-wide response payload
- primary write bottleneck
- lock contention
- transaction 太長
- connection pool pressure on writer
- cross-entity correctness invariant

如果原始 query 是：

```text
scan huge table -> filter late -> return wide rows
```

加 replicas 只是把壞 access pattern 複製到更多機器。

強回答要有這個順序：

1. 先確認瓶頸是 read QPS 還是 bad query。
2. 如果 query/index/schema 明顯錯，先修 access path。
3. 如果 read-heavy 且 stale 可接受，再用 replicas 分擔。
4. 如果 write bottleneck 或 lock contention 在 primary，replicas 不會根治。

## Replicas Vs Redis

這兩個不是互換品。

| 工具 | 解什麼 | 新問題 |
|---|---|---|
| Read replica | DB read capacity | replication lag, freshness routing |
| Redis cache | repeated expensive read / low-latency hot data | invalidation, stale cache, stampede, outage fallback |

Replica lag：

```text
primary is newer than replica for a while
```

Cache invalidation bug：

```text
database is newer than cache because cache update/delete/refill policy failed
```

如果 endpoint 是 payment status 或 appointment status immediately after write，盲目疊 Redis + replica 會讓 debug 更難：

```text
Is the stale value from cache?
Was cache refilled from a lagging replica?
Did routing ignore the post-write marker?
```

所以 freshness-critical path 應該保持簡單。

## 設計範例：Appointment Confirmation

目標：

```text
After POST /appointments/{id}/confirm returns success,
the user must not see the appointment as unconfirmed on refresh.
```

Write path：

```text
API -> primary transaction -> commit -> response includes status/version
```

Read policy：

- immediate GET by same user/resource goes primary
- appointment confirmation page is primary-consistent
- appointment list can use post-write stickiness for that user/resource
- background reporting can read replica

Fallback：

- if replica lag exceeds threshold, route related reads to primary
- if primary pressure is high, only critical read paths stay primary
- if freshness cannot be guaranteed cheaply, show `pending confirmation`

Metrics：

- confirm write latency
- immediate read source
- stale status mismatch count
- duplicate confirm click rate
- fallback-to-primary rate
- replica lag at time of read

## 設計範例：Billing / Payment

目標：

```text
After payment succeeds, the invoice page must not encourage a duplicate payment.
```

Read policy：

- payment result read: primary
- idempotency result lookup: primary or strongly consistent store
- invoice status immediately after payment: primary or pending
- historical invoice list: replica allowed if freshness label exists

Why：

- stale unpaid status can cause duplicate user action
- idempotency protects write side, but stale read still hurts UX and support
- if external payment result is ambiguous, use idempotency/reconciliation, not stale replica state

## 設計範例：Reporting Dashboard

Reporting 是比較好的 replica candidate。

理由：

- read-heavy
- 不在 critical mutation path
- 可以標示 freshness
- 可以接受 bounded delay

但還是要小心：

- long-running report query 可能拖慢 replica apply
- dashboard query 如果沒 index，replica 也會很慢
- reporting workload 應該跟 user-facing OLTP read 隔離

強回答：

```text
I would not let heavy reporting queries compete with user-facing read replicas unless the capacity and lag budget are explicit.
```

## Scale 下會壞什麼

當 tenants / hospitals / traffic 放大，常見問題：

- write bursts 讓 replica lag 擴大
- read-your-writes traffic 打回 primary，primary pool 又滿
- hot tenant 讓特定 replica 或 primary partition 壓力集中
- reporting query 吃掉 replica I/O / CPU，讓 apply 更慢
- failover 後 topology 改變，但 app routing cache 還沒更新
- read pool 看起來健康，但 freshness-critical endpoints 一直 fallback primary
- stale reads 造成 duplicate click、support ticket、client retry，進一步放大流量

這就是為什麼不能只看平均 QPS。

## What To Log

每個 read request 最好可以知道：

- endpoint
- user / tenant / resource id
- read source: primary, replica id, cache
- whether request had post-write marker
- required freshness version / timestamp
- served version / timestamp
- replica lag at serve time
- fallback reason
- trace id / correlation id

每個 write request 最好可以知道：

- commit success time
- returned version / timestamp
- affected resource
- idempotency key if relevant
- immediate follow-up reads

這些 log 讓你能回答：

```text
The user saw stale data because the GET after write went to replica-2,
which was 18 seconds behind, and the post-write primary pin marker was missing.
```

## What To Measure

系統層：

- replica lag by node
- primary QPS / replica QPS
- primary write latency
- replica read latency
- connection pool saturation by role
- slow query count by role
- failover events and routing errors
- replication apply delay

產品層：

- read-after-write fallback-to-primary rate
- stale-read incident count on critical endpoints
- duplicate action rate after mutation
- support tickets related to "update not showing"
- pending-state duration
- freshness label age distribution

不要只看：

```text
replica lag average = 1s
```

因為 product bug 可能發生在：

- p99 lag
- one bad replica
- one tenant
- one endpoint
- one post-write flow

## Debugging Playbook

問題：

```text
I confirmed an appointment, refreshed, and still saw pending.
```

排查順序：

1. write 是否真的 commit？
2. response 是否帶了 status / version / resource id？
3. follow-up read 打到 primary、哪台 replica、還是 Redis？
4. read request 是否帶 post-write marker？
5. routing layer 是否正確判斷 freshness requirement？
6. replica 當時 lag 多少？
7. 如果有 cache，cache 是何時寫入，從 primary 還是 replica refill？
8. 是否有多 device / 多 session 沒共享 stickiness？
9. 是否 UI 根據 stale response 啟用了 duplicate action？

這種回答會比「replica lag 造成的」強很多，因為你講出完整 debug path。

## 10-15 分鐘 Deep Dive 路線

可以照這個順序講：

1. 畫 request path：

```text
client -> API -> primary write -> replication stream -> replicas -> read router
```

2. 說明 replication lag 造成的 bug：

```text
write succeeded, but immediate read sees old state
```

3. 把 endpoint 分 freshness：

| Endpoint | Policy |
|---|---|
| payment result | primary |
| appointment confirmation | primary or proven-fresh replica |
| patient record after update | post-write primary pin |
| normal list/search | replica if stale acceptable |
| reporting dashboard | replica / reporting store with freshness label |

4. 選 routing strategy：

- primary by endpoint
- sticky window after write
- version / LSN gating
- lag-aware replica selection
- pending UX when freshness cannot be cheap

5. 講 fallback：

- lag under threshold: use replica
- lag too high: primary or pending
- primary overloaded: narrow critical paths, optimize query/write path
- failover: refresh topology and use health checks

6. 講 observability：

- source logging
- lag by node
- fallback rate
- stale incident count
- duplicate action rate
- p95 / p99 latency by role

## 30-45 分鐘設計追問

Prompt：

```text
Scale a hospital backend from 10 to 500 hospitals.
Reads are growing fast, writes still go through one primary,
and some patient-facing pages refresh immediately after updates.
```

回答架構：

### 1. 先問 bottleneck

- read QPS 是否真的壓垮 primary？
- slow query 是不是 index / query shape 問題？
- writes、locks、transactions 是否才是瓶頸？
- 哪些 endpoints 真的可以 stale？

### 2. 分 workload

- OLTP mutation path
- immediate post-write reads
- stale-tolerant browsing / search
- reporting / analytics
- background jobs

### 3. 設計 read router

Router inputs：

- endpoint policy
- user / session marker
- resource id
- last write version
- replica health / lag
- feature flag / failover state

Router outputs：

- primary
- specific replica
- pending response
- stale-labeled response
- degraded response

### 4. 處理 pushback

如果問「為什麼不所有 read 都走 replica」：

```text
because read traffic and freshness-critical read traffic are different workloads.
```

如果問「為什麼不所有 read 都走 primary」：

```text
because stale-tolerant reads should not consume writer capacity if replicas can serve them safely.
```

如果問「lag spike 怎麼辦」：

```text
fixed sticky windows are not enough; use lag-aware fallback or primary routing for critical paths.
```

如果問「Redis 可不可以解」：

```text
Redis helps repeated reads, but it adds invalidation complexity and can be refilled from stale sources.
It does not remove the need for endpoint-level freshness policy.
```

## Interview Pushback

1. How do you handle a read right after a write if replicas lag?
2. Which endpoints can tolerate stale reads, and which cannot?
3. Why is a sticky read-after-write window only a heuristic?
4. What if lag exceeds the stickiness window?
5. How would version / LSN gating improve the design?
6. Why are replicas not a fix for bad query shape?
7. Why can adding replicas still leave primary overloaded?
8. How do you debug whether stale data came from replica lag or Redis?
9. What changes during failover?
10. How do you measure product impact, not just database lag?

## 60-90 秒回答

Read replicas 可以分擔 read load，但它們引入 freshness trade-off。寫入通常先 commit 到 primary，replica 之後才 catch up，所以典型 bug 是 read-after-write inconsistency：例如 appointment confirm 成功後，下一個 GET 打到 lagging replica，使用者看到舊 status 或 not found。我的做法不是把所有 read 都丟 replica，而是按 endpoint 分級：payment、booking confirmation、剛更新後的 patient record 要 primary-consistent 或 proven-fresh；dashboard、historical logs、非關鍵 list 可以走 replica 並標 freshness。Write 後可以短時間 pin primary，或用 version / LSN gating 確認 replica 已追上；lag 超過 threshold 就 fallback primary、pending 或 degrade。最後我會強調 replicas 不會修 bad query/index/schema 或 primary write bottleneck，所以要量 replica lag、fallback rate、stale incident、primary/replica pool 和慢查詢。

## 最後要能交付

讀完這篇，要能做到：

- 畫出 primary write、replication apply、read router 的 request path
- 用 appointment 或 payment flow 說明 read-after-write inconsistency
- 把 endpoints 分成 primary-consistent、bounded read-your-writes、stale-tolerant
- 比較 primary routing、sticky window、version / LSN gating、pending UX
- 說出 sticky window 何時失效
- 解釋 replicas 為什麼不修 bad query / missing index / primary write bottleneck
- 區分 replica lag 和 Redis invalidation bug
- 設計一個 read router 的 inputs / outputs
- 列出 debugging log 欄位和 production metrics
- 扛住 lag spike、failover、primary overload、Redis pushback
