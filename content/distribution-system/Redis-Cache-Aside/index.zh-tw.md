---
title: "Redis Cache-Aside And Query Fixes"
summary: "Redis 什麼時候是正確解，什麼時候只是遮住 query/index/schema 問題"
description: "Cache-aside、invalidation、stale reads、hot keys、Redis vs DB fixes 的複習筆記"
date: 2026-05-28
tags: ["distributed-systems", "redis", "cache-aside", "caching", "database-scaling"]
categories: ["distribution-system"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 複習重點

- Cache-aside read path and write invalidation
- Data freshness and stale-read tolerance by endpoint
- Cache stampede, TTL jitter, single-flight, stale-while-revalidate
- Hot key detection and mitigation
- Redis outage fallback and DB protection
- When to fix query/index/schema before adding Redis

## 心智模型

Redis 不是：

```text
DB slow -> add cache
```

比較好的判斷是：

```text
cache repeated expensive reads only when stale-data risk and invalidation cost are acceptable.
```

如果 root cause 是 query 不 SARGable、index order 錯、schema shape 不適合，先加 Redis 只是在把問題藏起來。Cache miss、cold start、invalidation bug、Redis outage 時，問題還是會回到 DB。

## Cache-Aside

Cache-aside 的基本流程：

```text
read cache
if miss:
    read database
    write cache with TTL
return data
```

Write path 常見做法：

```text
write database
delete or refresh cache key
```

重點是 write path，不是只有 read hit。

如果更新 DB 後沒有正確 invalidate cache，使用者會讀到 stale data。這有時可接受，有時是 correctness bug。

## 哪些資料適合 Cache

比較適合：

- read-heavy
- expensive to compute or query
- stale 幾秒可接受
- key shape 穩定
- invalidation rule 清楚

例如：

- hospital profile / department metadata
- read-mostly reference data
- dashboard summary with freshness label
- expensive non-critical aggregation

不適合或要很小心：

- payment state immediately after charge
- appointment booking capacity
- patient record after mutation
- permission / auth decision with high security impact
- highly personalized rapidly changing state

## Invalidation 策略

常見選項：

- TTL only: 簡單，但 stale window 固定存在
- write-through refresh: write DB 後同步更新 cache
- delete-on-write: write DB 後刪 key，下次 miss 重建
- event-driven invalidation: DB change / domain event 後 async invalidate
- versioned key: 用 version 避免舊值覆蓋新值

每種都有 trade-off：

- delete-on-write 簡單但可能造成 miss burst
- refresh-on-write 多一步 failure mode
- event-driven 有 delay 和 delivery failure
- TTL 太短 hit rate 差，太長 stale risk 高

## Cache Stampede

如果 hot key expire，很多 requests 同時 miss，會全部打 DB。

Mitigation：

- single-flight / request coalescing
- short lock around rebuild
- TTL jitter
- stale-while-revalidate
- pre-warm critical keys
- rate limit expensive rebuild path

這也是為什麼 Redis 不是「加上去就好了」。Cache 本身會帶新的 failure mode。

## Hot Key

Hot key 是大量 traffic 集中在同一個 cache key。

症狀：

- Redis single key QPS 過高
- one Redis node CPU/network 特別高
- p99 latency spike
- DB 在 key expire 後被打爆

Mitigation：

- key replication / local cache for read-only data
- request coalescing
- split key if data naturally separable
- precompute / prewarm
- TTL jitter

## Redis Down 怎麼辦

要先決定 cache 是 optimization 還是 correctness dependency。

如果 Redis 只是 optimization：

- fallback DB
- rate limit fallback
- circuit breaker
- skip cache write temporarily
- monitor DB pressure

如果 Redis 參與 correctness，例如 lock 或 rate limit，則要非常小心；通常不能把 Redis 當唯一 durable source of truth。對 duplicate payment/order 類問題，durable idempotency record 應該在 DB。

## Redis vs Query / Index / Schema Fix

我會先問：

1. 慢是因為 repeated read，還是 single query 本身很爛？
2. Query 是否 SARGable？
3. Index order 是否符合 predicate/order？
4. Projection 是否太寬？
5. Schema 是否導致每次都要昂貴 join / aggregation？
6. Data freshness 是否允許 stale？
7. Cache invalidation 是否清楚？

如果 single query 本身每次都掃爆 DB，cache hit 看起來很快，但 miss 仍然很危險。先修 query/index/schema 才是根本。

## 我要量測什麼

- cache hit / miss rate
- p95 / p99 latency by hit vs miss
- DB QPS during cache miss
- hot key distribution
- key eviction count
- stale-read incidents
- cache rebuild duration
- Redis CPU, memory, network
- fallback-to-DB rate
- invalidation failure count

## 60-90 秒回答

Redis 適合 cache repeated expensive reads，而且前提是資料可以接受一定 stale window、key 設計穩定、invalidation 規則清楚。我不會把 Redis 當成慢查詢的第一解；如果 query 不 SARGable、index order 錯、projection 太寬或 schema shape 不對，cache miss 時問題還是會回來。Cache-aside 要講完整 read miss 和 write invalidation：讀不到就查 DB 並寫 cache，寫入 DB 後刪除或刷新 cache。還要處理 cache stampede、hot key、Redis down 的 fallback。對 payment、booking capacity、patient record mutation 後的立即讀取，我會非常小心，通常不能靠 stale cache 當 correctness source。
