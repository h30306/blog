---
title: "Redis Cache-Aside"
summary: "Cache-aside、invalidation、stale reads、hot keys 與 Redis outage fallback"
description: "分散式 cache 的 cache-aside、invalidation、stale reads、hot keys 與 Redis fallback 複習筆記"
date: 2026-05-28
tags: ["distributed-systems", "redis", "cache-aside", "caching", "consistency"]
categories: ["distribution-system"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 複習重點

Redis / cache 題目不能只回答：

```text
read cache first, miss then read DB
```

Tier A/S 強度要能回答：

- 什麼 endpoint 可以 cache，什麼 endpoint 不該 cache
- cache-aside、read-through、write-through、write-behind 的取捨
- TTL 怎麼選，stale window 能不能被 product 接受
- write 後要 delete、refresh、event invalidate，還是接受 bounded stale
- cache stampede、hot key、negative cache、cold start 怎麼處理
- Redis down 時是 fallback DB、degrade，還是 fail closed
- Redis 什麼時候是正確解，什麼時候只是遮住 bad query / index / schema
- 要 log 什麼才能 debug stale value 來自 cache、replica、還是 DB 本身

一句話：

```text
Cache is not just a faster read path.
It is a second data visibility layer with freshness, invalidation, and failure-mode cost.
```

## Tier A/S 判斷

如果答案只有：

```text
Redis makes reads faster, use TTL and invalidate after write.
```

這還不夠。

強回答要補上：

- cache 前先確認 DB path 是否健康
- freshness 要按 endpoint 分級
- stale data 何時只是 UX issue，何時是 correctness bug
- cache miss / rebuild / Redis outage 不能把 DB 打爆
- hot key 可能讓 cache tier 自己變 bottleneck
- negative caching 會遮住剛建立的資源
- cache 和 replica 疊在一起會讓 stale source 更難 debug
- payment / booking / auth 類資料不能把 Redis 當唯一 correctness source

## 心智模型

Redis 不是：

```text
DB slow -> add cache
```

比較好的判斷：

```text
Cache repeated expensive reads when the DB path is reasonable,
the data has reuse,
and the endpoint can tolerate the freshness model.
```

Cache 可以降低：

- repeated read latency
- DB read QPS
- repeated aggregation cost
- hot metadata lookup

但它會新增：

- stale reads
- invalidation complexity
- cache stampede
- hot key bottleneck
- Redis outage fallback
- warmup / cold start problem
- debugging 多一層 data source

## 先問：應不應該 Cache？

加 Redis 前先問七個問題：

1. 這個 endpoint 是 read-heavy 嗎？
2. 同一個 key 會被重複讀嗎？
3. DB query 本身已經合理嗎？
4. stale 幾秒、幾分鐘、或完全不能 stale？
5. write 後 invalidation 規則清楚嗎？
6. cache miss 時 DB 能承受嗎？
7. Redis down 時 product 要 fallback、degrade，還是 fail closed？

如果答案不清楚，不要急著 cache。

## Good Cache Candidates

比較適合 cache：

- hospital metadata
- department / doctor directory
- read-mostly reference data
- feature/config snapshot
- dashboard summary with freshness label
- expensive non-critical aggregation
- permission-derived view snapshot with short TTL and clear invalidation

共同特性：

- read-heavy
- repeated access
- 內容相對穩定
- stale 有明確上限
- key shape 穩定
- invalidation 可以說清楚

## Risky Cache Candidates

要非常小心：

- payment status immediately after charge
- appointment booking capacity
- patient record immediately after mutation
- permission / authorization decision with high security impact
- idempotency result as non-durable Redis-only state
- inventory / slot availability that changes rapidly
- highly personalized state that changes often

判斷標準：

```text
If stale data can cause duplicate action, wrong authorization, or broken business invariant,
cache cannot be treated as the source of truth.
```

可以 cache 不代表可以直接信任 cache。

## Cache-Aside

Read path：

```text
read Redis
if hit:
    return cached value
if miss:
    read DB
    write Redis with TTL
    return DB value
```

Write path 常見做法：

```text
write DB
delete cache key
```

或：

```text
write DB
refresh cache value
```

Cache-aside 的重點不是 read miss，而是 write 後 cache 跟 DB 如何重新收斂。

### Delete-On-Write

流程：

```text
commit DB write
delete cache key
next read rebuilds from DB
```

優點：

- 簡單
- 避免 write path 要計算完整新 cache value
- 比 TTL-only 更快移除舊資料

缺點：

- delete 失敗會留下 stale value
- next read 可能引發 miss burst
- concurrent read 可能在 delete 前讀到舊值
- 如果 rebuild 從 lagging replica 讀，可能把舊值寫回 cache

### Refresh-On-Write

流程：

```text
commit DB write
compute latest cache value
set cache key
```

優點：

- 下一個 read 比較可能 hit fresh cache
- 適合新值容易計算的場景

缺點：

- write path 更重
- refresh 失敗會造成 DB/cache 不一致
- concurrent writes 可能造成舊 refresh 覆蓋新 value

需要搭配：

- versioned value
- compare-and-set
- monotonic update
- event ordering

### TTL-Only

流程：

```text
set key with TTL
do not explicitly invalidate on write
```

優點：

- 最簡單
- 適合 stale 可接受的資料

缺點：

- stale window 固定存在
- write 後使用者可能一直看到舊值直到 TTL 到期
- TTL 太短 hit rate 差，太長 correctness risk 高

適合：

- metadata
- reference data
- dashboard summary
- non-critical aggregate

不適合：

- payment result
- booking capacity
- mutation 後的 immediate status

## Read-Through / Write-Through / Write-Behind

Cache-aside 是 application 自己控制 cache miss 和 fill。

Read-through：

```text
application reads cache layer
cache layer loads DB on miss
```

優點是 app code 簡化；缺點是資料來源和 fallback behavior 容易被抽象藏起來。

Write-through：

```text
write goes through cache layer and DB/cache are updated together
```

優點是 cache 較新；缺點是 write latency 和 failure handling 變複雜。

Write-behind：

```text
write cache first, async flush to DB later
```

這通常要非常小心，因為 Redis 不是 durable source of truth。除非你非常確定 durability、ordering、replay、DLQ、reconciliation，否則不該把 critical payment / booking state 放在 write-behind。

## Key Design

好的 cache key 要包含：

- namespace
- entity type
- id
- version or schema version
- tenant / hospital scope when needed
- language / locale if response differs
- auth scope if response depends on permissions

例如：

```text
hospital:{hospital_id}:doctor-directory:v3
patient:{patient_id}:profile-summary:v2
dashboard:{hospital_id}:{date}:summary:v5
```

避免：

- key 沒有 tenant scope，造成跨 tenant data leak
- key 沒有 version，schema 改了卻讀到舊格式
- key 包含過多高 cardinality 參數，導致 hit rate 極低
- key 太粗，導致 invalidation 影響太大

Security 注意：

```text
If the cached response depends on who is asking, the key must include the authorization scope
or the endpoint must not cache the personalized response directly.
```

## Invalidation Strategies

### 1. Delete-On-Write

適合：

- cache value 可以下次 read 再重建
- write path 不想計算完整 response
- stale window 要比純 TTL 更短

需要補：

- delete failure retry
- idempotent invalidation
- after-commit invalidation，不要 transaction rollback 後刪 cache

### 2. Refresh-On-Write

適合：

- write 後下一個 read 很快
- 新值容易計算
- stale risk 高但仍可 cache

需要補：

- version check 防止舊 refresh 覆蓋新值
- refresh failure fallback
- write latency 增加

### 3. Event-Driven Invalidation

流程：

```text
DB write commits
domain event / outbox emits change
consumer invalidates or refreshes cache
```

優點：

- write path 可以較輕
- 多個 cache key 可以由 consumer 處理

缺點：

- event delivery delay
- consumer lag
- duplicate events
- out-of-order events
- invalidation gap

要搭配：

- idempotent consumer
- versioned event
- retry / DLQ
- monitoring invalidation lag

### 4. Versioned Keys

做法：

```text
cache key includes data version
```

例如：

```text
doctor-directory:{hospital_id}:v42
```

優點：

- 舊 key 不會覆蓋新 key
- schema 變更容易切換

缺點：

- 舊 key 清理要管理
- version source 要可靠
- key 數量可能膨脹

## Stale-Read Trade-Off

要能說清楚哪種 stale 可接受。

可接受：

- doctor directory 晚幾分鐘更新
- dashboard aggregate 標示 `last updated at`
- reference data 有 TTL
- non-critical search result 稍微延遲

不可接受或要非常小心：

- payment 已成功但 UI 顯示 unpaid
- appointment slot 已被訂走但 cache 顯示 available
- patient note 更新後讀到舊版本造成覆蓋
- authorization 變更後 cache 還允許存取

強回答：

```text
Staleness is a product and correctness decision, not only a cache setting.
```

## Negative Caching

Negative caching 是 cache `not found` 或空結果。

適合：

- 防止不存在 key 被大量打 DB
- 搜尋空結果短時間內重複出現
- external lookup 失敗成本高

風險：

```text
resource is created right after a cached negative result
```

例子：

1. `GET /patients/123` 查不到，cache `not found`
2. patient 被建立成功
3. cache 還回 `not found`

解法：

- negative cache TTL 要短
- create/update 後刪除相關 negative key
- freshness-critical create flow 不依賴 negative cache
- cache key 包含 tenant / scope，避免跨 tenant 錯誤

## Cache Stampede

Stampede 發生在 hot key expire 或 Redis miss 時，大量 requests 同時打 DB。

典型：

```text
popular dashboard key expires
10k requests miss together
all rebuild from DB
DB latency spikes
more retries arrive
```

Mitigation：

- single-flight / request coalescing
- per-key rebuild lock with short timeout
- TTL jitter
- stale-while-revalidate
- background refresh before expiry
- pre-warm critical keys after deploy
- rate limit expensive rebuild path
- serve stale value when DB is degraded

注意：

```text
The rebuild path must be protected, not just the happy cache-hit path.
```

## Hot Key

Hot key 是大量 traffic 集中到同一個 key。

症狀：

- one Redis node CPU / network 特別高
- single key QPS 遠高於其他 keys
- p99 cache latency spike
- key expire 時 DB 被打爆
- cluster mode 下 slot 分布平均，但某個 slot/key 超熱

Mitigation：

- local in-process cache for ultra-hot read-only value
- key replication / client-side fanout read copies
- split key by natural dimension
- precompute smaller chunks
- TTL jitter
- single-flight
- stale-while-revalidate

例子：

```text
dashboard:{hospital_id}:today
```

如果所有人都讀同一個 dashboard，可以改成：

- per-department summary
- background precomputed summary
- local short TTL cache
- stale display with async refresh

## Redis Down 怎麼辦

先分類 Redis 在這條 path 是：

```text
optimization
```

還是：

```text
correctness dependency
```

### Redis As Optimization

如果 Redis 只是加速：

- fallback DB
- limit fallback QPS
- circuit breaker
- shed non-critical traffic
- serve stale local snapshot if acceptable
- skip cache write temporarily
- monitor DB pressure

但 fallback DB 不是免費：

```text
Redis outage can turn into DB outage if every miss falls through at full speed.
```

### Redis As Correctness Dependency

如果 Redis 用於：

- lock
- rate limit
- dedupe
- session
- idempotency

要非常小心。

對 payment / order / booking 類 critical mutation：

```text
Redis should not be the only durable source of truth.
```

更安全做法：

- durable idempotency table
- DB unique constraint
- transaction boundary
- outbox / reconciliation
- Redis 只當 fast path 或 short-lived coordination layer

## Redis vs Query / Index / Schema Fix

Redis 不是慢查詢的反射動作。

先診斷：

- query plan 是否合理
- 是否 full scan
- predicate 是否 SARGable
- composite index order 是否對
- projection 是否太寬
- join 是否 N+1
- schema 是否不適合 access pattern
- read 是否重複且 cache locality 高
- freshness 是否可接受

如果 DB path 爛：

```text
fix query/index/schema first, otherwise cache miss will reveal the same bottleneck.
```

如果 DB path 合理，但同一批資料被大量重複讀：

```text
Redis may be the right next layer.
```

好的回答不是 Redis vs index 二選一，而是：

```text
The database path should remain survivable when cache misses or Redis degrades.
```

## Cache + Replica 的組合風險

Redis 和 read replica 可以一起用，但 freshness 會更難。

危險路徑：

```text
cache miss
  -> read lagging replica
  -> refill cache with stale value
  -> stale value survives TTL
```

對 write-after-read critical endpoint：

- write 後短時間 bypass cache
- cache refill 從 primary 讀
- 或要求 replica catch up 到 version
- cache value 帶 version / updated_at
- stale response 要標示

Debug 時要知道：

- response 來自 cache hit？
- cache miss 後讀 primary 還是 replica？
- cached value 的 version 是多少？
- replica 當時 lag 多少？

## Failure Matrix

| Failure | 使用者看到什麼 | 根因 | 修法 |
|---|---|---|---|
| Stale cache after write | 更新後仍看到舊資料 | invalidation fail / TTL-only | after-commit delete, versioned key, short stale window |
| Cache stampede | DB 突然被 miss 打爆 | hot key expire | single-flight, jitter, stale-while-revalidate |
| Hot key | Redis p99 spike | one key receives massive QPS | local cache, split key, key replication |
| Negative cache stale | 新建資料仍顯示 not found | cached negative result | short TTL, invalidate on create |
| Redis outage -> DB outage | Redis 掛了 DB 也爆 | unbounded fallback | circuit breaker, rate limit, degrade |
| Cache refill stale | cache 被舊資料重新填滿 | miss reads lagging replica | refill from primary or version gate |
| Wrong auth cache | 使用者看到不該看的資料 | key missing auth scope | include scope or do not cache personalized response |
| Old refresh overwrites new | cache 回到舊版 | out-of-order refresh | versioned values, compare-and-set |

## 設計範例：Doctor Directory

這是好的 cache candidate。

原因：

- read-heavy
- 更新頻率低
- stale 幾分鐘通常可接受
- key shape 清楚

Key：

```text
doctor-directory:{hospital_id}:v3
```

Read：

```text
cache hit -> return
cache miss -> DB query -> set TTL with jitter
```

Write：

```text
doctor profile update commits
delete doctor-directory:{hospital_id}:v3
optionally publish invalidation event
```

Metrics：

- hit rate
- fill latency
- stale complaint
- invalidation failure
- Redis latency

## 設計範例：Appointment Availability

這是 risky cache candidate。

原因：

- 資料變動快
- stale availability 會造成使用者選到已不存在的 slot
- correctness 仍必須靠 DB transaction / constraint / lock

可以怎麼做：

- cache read-only slot suggestions with short TTL
- booking confirmation 必須走 DB authoritative path
- write 後 invalidate affected slot keys
- UI 標示 availability can change
- final booking transaction re-check capacity

強回答：

```text
Cache can help discovery, but the final booking decision must be made against the source of truth.
```

## 設計範例：Dashboard Summary

Dashboard 通常適合 cache，但要標示 freshness。

策略：

- precompute summary
- cache by tenant/date/filter
- TTL + jitter
- background refresh
- stale-while-revalidate
- `last_updated_at`

如果 dashboard 很重：

- 不要每次 miss 都同步跑巨大 aggregation
- 用 background job / materialized summary
- cache miss 時可回 stale value 或 pending

## What Breaks At Scale

規模變大後常見問題：

- cache hit rate 平均很高，但某 critical endpoint 一直 miss
- hot key 壓垮單 Redis node
- cache expiration 同步造成 DB spike
- Redis deploy / failover 造成 cold cache
- fallback DB 沒 rate limit，Redis 小故障變 DB 大故障
- stale data 造成 duplicate action / support ticket
- cache key 爆炸導致 memory pressure 和 eviction
- invalidation consumer lag 導致長時間 stale
- cache response 沒帶 tenant/auth scope 造成 data leak

## What To Log

每次 read 最好記：

- endpoint
- cache key namespace
- cache hit / miss
- cache value version / updated_at
- Redis node / latency
- fallback source: primary / replica
- post-write bypass marker
- tenant / auth scope hash
- rebuild duration
- stale-while-revalidate served or not

每次 write / invalidation 最好記：

- affected keys
- after-commit invalidation result
- event id / version
- invalidation consumer lag
- refresh success / failure
- compare-and-set result

## What To Measure

Cache metrics：

- hit rate by endpoint
- miss rate by endpoint
- hit latency vs miss latency
- cache fill latency
- Redis CPU / memory / network
- Redis timeout / error rate
- eviction count
- hot key distribution
- key cardinality

DB protection metrics：

- fallback-to-DB rate
- DB QPS during miss bursts
- slow query during cache degraded window
- stampede prevention hit count
- rebuild concurrency per key

Correctness metrics：

- stale-read incident count
- negative-cache false miss
- duplicate action after stale page
- invalidation failure count
- invalidation lag
- auth/cache scope violation alert

## Debugging Playbook

問題：

```text
I updated a doctor's profile, but the old value is still shown.
```

排查：

1. write 是否 commit？
2. affected cache keys 是哪些？
3. invalidation 是 after commit 還是 commit 前？
4. delete / refresh 是否成功？
5. read 是 cache hit、miss 後 DB、還是 replica refill？
6. cached value version / updated_at 是多少？
7. 是否有多個 key namespace 漏刪？
8. TTL 是否比 product freshness window 長？

問題：

```text
DB load spiked exactly at Redis key expiry.
```

排查：

1. 哪些 keys 同時 expire？
2. 是否沒有 TTL jitter？
3. 是否缺 single-flight？
4. rebuild query 是否 expensive？
5. fallback 是否沒有 rate limit？
6. 是否可以 serve stale-while-revalidate？

## 10-15 分鐘 Deep Dive 路線

可以照這個順序講：

1. 先判斷 endpoint 能不能 cache：

```text
read-heavy, repeated, stable enough, clear invalidation, acceptable stale window
```

2. 畫 cache-aside read path：

```text
client -> API -> Redis -> DB on miss -> Redis fill -> response
```

3. 畫 write path：

```text
DB commit -> after-commit delete/refresh -> optional event invalidation
```

4. 討論 freshness：

- metadata stale OK
- dashboard stale with label OK
- payment / booking / auth stale dangerous

5. 討論 failure：

- stampede
- hot key
- Redis down
- negative cache
- stale refill from replica

6. 討論 protection：

- single-flight
- TTL jitter
- stale-while-revalidate
- circuit breaker
- rate-limited DB fallback
- versioned keys

7. 最後補 metrics：

- hit/miss
- latency
- stale incident
- invalidation lag
- fallback DB pressure

## 30-45 分鐘設計追問

Prompt：

```text
Design a caching layer for a hospital backend.
Some metadata reads are hot, dashboards are expensive,
but booking/payment correctness cannot be stale.
```

回答架構：

### 1. 分 endpoint

Cache：

- doctor directory
- hospital metadata
- stable config
- dashboard summary with freshness label

Do not blindly cache：

- payment status after charge
- appointment booking capacity
- patient record after mutation
- auth-sensitive personalized response

### 2. Key Design

- namespace
- tenant scope
- entity id
- version
- locale/filter
- auth scope if needed

### 3. Read / Write Policy

- cache-aside for normal reads
- after-commit delete for mutable records
- background refresh for expensive dashboard
- versioned keys for schema/value ordering

### 4. Failure Handling

- Redis timeout: short timeout and fallback/degrade
- miss storm: single-flight + stale-while-revalidate
- hot key: local cache / split / precompute
- stale data: version check / freshness label / bypass after write

### 5. DB Protection

- fallback rate limit
- circuit breaker
- serve stale for non-critical data
- do not cache over a broken query path

### 6. Observability

- hit rate by endpoint
- miss burst
- stale incident
- invalidation lag
- DB QPS during Redis degradation
- hot keys

## Interview Pushback

1. How do you invalidate cache after a write?
2. Why is TTL alone not enough?
3. How do you stop 10k requests from stampeding the DB?
4. What if Redis is down?
5. Which endpoints should never use stale cache?
6. How do you avoid caching data across tenant/auth boundaries?
7. How do you debug stale data if both Redis and replicas exist?
8. When is Redis hiding a bad query instead of solving the problem?
9. What is negative caching, and what can go wrong?
10. How do you keep old cache refreshes from overwriting newer data?

## 60-90 秒回答

Redis 適合 repeated expensive reads，但前提是 DB path 本身合理、資料有重複讀取價值、endpoint 可以接受明確 stale window，而且 invalidation 規則清楚。Cache-aside 的 read path 是先讀 Redis，miss 才讀 DB 並回填；write path 不能忘，通常要在 DB commit 後 delete 或 refresh cache key。Doctor directory、metadata、dashboard summary 是好候選；payment status、booking capacity、mutation 後的 patient record 和 auth-sensitive response 要非常小心，不能把 stale cache 當 correctness source。我也會處理 stampede、hot key、negative cache、Redis down fallback，並確保 fallback 不會把 DB 打爆。最後我會量 hit/miss、hit vs miss latency、fallback-to-DB rate、hot key、invalidation lag 和 stale-read incidents。

## 最後要能交付

讀完這篇，要能做到：

- 解釋 cache-aside read path 和 write invalidation path
- 說出哪些 endpoint 可以 cache、哪些不該直接 cache
- 比較 TTL-only、delete-on-write、refresh-on-write、event invalidation、versioned key
- 設計 tenant-safe / auth-safe cache key
- 解釋 stale-read trade-off 和 product correctness boundary
- 處理 cache stampede、hot key、negative cache
- 說出 Redis down 時 fallback / degrade / circuit breaker 設計
- 區分 Redis、read replica、DB query/index fix 解的問題
- 說出如何 debug stale data 是 cache、replica、還是 invalidation 問題
- 扛住 10-15 分鐘 deep dive 和 30-45 分鐘 design pushback
