---
title: "Replication Lag And Replica Routing"
summary: "把 read replica 從讀流量擴充，講到 read-after-write correctness 和 routing policy"
description: "Primary/replica、replication lag、read-after-write consistency 的分散式系統複習筆記"
date: 2026-05-26
tags: ["distributed-systems", "database-scaling", "replication", "read-replica", "consistency"]
categories: ["distribution-system"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 複習重點

- Primary / replica model and async replication
- Replication lag and read-after-write inconsistency
- Endpoint-level freshness classification
- Post-write primary pinning and replica catch-up checks
- Why replicas do not fix bad query/index/schema design
- What to measure when scaling a hospital DAL read path

## 心智模型

Read replica 不是：

```text
reads are slow, add replicas
```

比較好的 mental model 是：

```text
replicas increase read capacity, but they introduce freshness choices.
```

一旦 write 先到 primary，而 replica async catch up，使用者立刻讀 replica 就可能看不到剛寫成功的資料。

這不是抽象的 eventual consistency，而是 product-visible bug。

## 典型 Bug

使用者更新 appointment status：

```text
POST /appointments/123/confirm -> primary commit success
GET /appointments/123 -> routed to lagging replica
```

如果 replica 還沒追上，UI 可能顯示 appointment 還沒 confirm。使用者可能重按、客服看到錯狀態、下游流程也可能根據舊資料做錯判斷。

## Endpoint Freshness 分類

不要說「全部走 primary」或「全部走 replica」。要按 endpoint 分類：

Primary-consistent reads:

- payment result after charge
- appointment booking confirmation
- patient record immediately after update
- admin mutation workflow 下一步需要依賴剛寫入資料

Replica-tolerant reads:

- public lookup / catalog-like pages
- reporting dashboards with freshness label
- historical logs
- non-critical list pages

Mixed policy:

- normal list page 可走 replica
- write 後的一段 read-your-writes window 走 primary
- lag 超過 threshold 時 fallback to primary 或 degrade response

## Read-After-Write Routing

常見策略：

```text
after write, pin this user/session/resource reads to primary for N seconds
```

或是帶一個 freshness marker：

```text
client observed write version/timestamp -> read requires replica caught up to at least that point
```

如果 replica 無法證明已追上，就：

- route to primary
- return retry-after
- show stale-but-labeled data
- degrade non-critical panel

選哪個要看 endpoint correctness。

## Replicas 解不了什麼

這是 note 裡很重要的修正：replica 不是萬用 scaling fix。

Replicas 不會修好：

- bad query shape
- missing / wrong index
- low-selectivity scan
- primary write bottleneck
- connection pool pressure on writer
- transactional contention
- over-wide response payload

如果原本 query 每次都 full scan 大表，複製出更多 replica 只是把同一個壞 access pattern 複製很多份。

## Scale 下會壞什麼

當 hospitals / tenants / traffic 放大：

- replicas 可能 lag 變大
- read pool 和 write pool 需要分開觀察
- hot tenants 可能讓某些 replicas 壓力特別大
- reporting query 可能拖慢 replica catch-up
- failover 後 primary/replica role change 會影響 routing
- stale reads 會變成使用者可見的不一致

## 設計 Hospital DAL 的回答方式

我會先把 endpoint 分三類：

1. Mutations and immediately-after-write reads stay primary-consistent.
2. Normal read-heavy list/search endpoints can use replicas if stale data is acceptable.
3. Reporting and analytics should be isolated from OLTP paths, possibly with replica or warehouse strategy.

然後加 routing rules：

- write path always primary
- post-write read-your-writes window primary
- replica reads require lag below threshold
- critical reads can force primary
- degraded mode labels or disables stale panels

## 我要量測什麼

- replica lag in seconds / bytes / log sequence distance
- read-after-write fallback count
- stale-read complaints or consistency mismatch metrics
- primary vs replica QPS
- primary write latency
- replica query latency
- connection pool saturation by role
- slow queries on replicas
- failover events and routing errors

## 60-90 秒回答

Read replicas 增加 read capacity，但會帶來 freshness 問題。最典型是 write 已經在 primary commit，下一個 read 卻被 route 到 lagging replica，使用者看不到自己的更新。所以我會按 endpoint 分 freshness：payment、booking confirmation、patient record update 後的讀取要 primary-consistent；reporting 或非關鍵 list 可以接受 replica stale，但要有 freshness policy。Write 後可以短時間 pin primary，或要求 replica catch up 到某個 version/timestamp。Replica 也不是修慢查詢的方法；如果 query/index/schema 本身很差，應先修 access path，再談 replication。
