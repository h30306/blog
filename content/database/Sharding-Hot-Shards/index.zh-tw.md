---
title: "Sharding, Hot Shards, And Cross-Shard Pain"
summary: "Shard key 不是選一個欄位而已，而是承擔 workload、skew、routing 和 transaction trade-off"
description: "Shard key choice、hot shard、cross-shard query、resharding 的資料庫擴展複習筆記"
date: 2026-05-27
tags: ["database", "database-scaling", "sharding", "hot-shard", "multi-tenant"]
categories: ["database"]
aliases:
  - /zh-tw/distribution-system/sharding-hot-shards/
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 複習重點

- Shard key choice from workload and access patterns
- Tenant locality vs even distribution
- Hot tenant / hot shard detection and mitigation
- Cross-shard joins, ordering, pagination, reporting, and transactions
- Resharding cost and migration risk
- When schema/index/cache/replication should come before sharding

## 心智模型

Sharding 不是：

```text
table too big, split it
```

而是：

```text
choose a partitioning rule that matches the dominant access pattern,
then accept the operations that become harder after the split.
```

Shard key 選錯時，你不是得到 scale，而是得到更難 debug 的 latency、hot spot、cross-shard query 和 resharding problem。

## 什麼時候不該先 Shard

在說 sharding 前，先確認：

- query shape 是否不 SARGable
- index 是否缺失或 order 錯
- full scan 是否是因為 predicate 太寬
- response payload 是否過大
- connection pool 是否配置錯
- primary write bottleneck 是否真的來自單機容量
- read replica 或 cache 是否已經足夠

如果根因是 bad query / bad index，sharding 只是把壞查詢分散到更多地方。

## Shard Key 取捨

以 hospital DAL 來看，直覺會選：

```text
hospital_id
```

優點：

- tenant isolation 清楚
- 大部分 hospital-scoped query 可以單 shard 完成
- 權限 boundary 和 routing 比較自然
- operational ownership 容易理解

問題：

- 大 hospital 可能成為 hot shard
- 跨 hospital reporting 變 cross-shard aggregation
- 如果 hospital size 分布很 skew，資料和流量不平均
- 後續 resharding 會痛

Hash shard key：

- 分布比較平均
- 但 range / tenant-locality 可能變差
- cross-resource transaction 更麻煩

Hybrid strategy：

- tenant-aware routing
- 大 tenant 拆成多個 logical partitions
- small tenants 合併
- reporting path 另外走 async pipeline / warehouse

## Hot Shard

Hot shard 不是只有 data size 太大，也可能是 traffic skew。

常見來源：

- 某個大 hospital / tenant 流量特別高
- 某個 doctor / department 是熱點
- 目前時間區間的 appointment query 全打同一段資料
- write-heavy event 全集中到同一 logical key

症狀：

- 某一 shard p99 latency 明顯高
- connection pool saturation 集中在一 shard
- lock wait / write queue 偏高
- CPU / IO / cache miss 不平均

## Cross-Shard Pain

Sharding 後，這些事情會變貴：

- cross-shard joins
- global search
- global ordering / pagination
- cross-shard transaction
- reporting aggregation
- uniqueness constraint across shards
- foreign key enforcement

例如跨院區報表：

```text
get appointments by status across all hospitals last month
```

如果資料按 `hospital_id` shard，這個 query 需要 fan out 到多個 shards，再 merge aggregate。這不只是慢，也會讓 partial failure 和 retry behavior 變複雜。

## Resharding Pain

Shard key 一旦上線，就會進入 routing、storage、backup、monitoring、migration、deploy pipeline。

Resharding 會牽涉：

- dual-write 或 change data capture
- backfill
- routing table migration
- consistency validation
- cutover and rollback
- old and new key coexistence

所以面試中不能只說「以後再 reshard」。要說你如何避免早期選錯，以及如何觀察何時真的需要拆。

## Mitigation

Hot shard mitigation 依情況：

- split large tenant
- move hot tenant to dedicated shard
- use virtual shards / logical partitions
- isolate reporting workload
- add cache for read-heavy non-critical data
- batch or queue write bursts
- redesign schema to remove hot owner row

但每個 mitigation 都有代價。不要把它講成免費。

## 我要量測什麼

- per-shard QPS, p95, p99
- per-shard CPU, IO, storage
- per-shard connection pool saturation
- hot tenant / hot key distribution
- cross-shard query count
- fanout width
- partial failure and retry rate
- resharding/backfill progress and validation mismatch

## 60-90 秒回答

Shard key 要從 workload 選，不是從 schema 直覺選。以 hospital DAL 來說，`hospital_id` 很自然，因為多數 query 和權限邊界都以 hospital 為範圍，單 shard query 會很乾淨。但它也會遇到大 hospital hot shard、跨院區報表 fanout、cross-shard transaction 和 resharding pain。Sharding 前我會先確認 query/index/schema、read replica、cache 是否已經解決主要瓶頸。真的要 shard 時，我會量 per-shard QPS/latency/storage、hot tenant distribution、cross-shard query 比例，並準備大 tenant split 或 dedicated shard 的策略。
