---
title: "LeetCode 1155: Number of Dice Rolls With Target Sum"
summary: "LeetCode 解題筆記：Number of Dice Rolls With Target Sum"
description: "2026-08-23 的 LeetCode 學習紀錄"
date: 2026-08-23
tags: ["medium", "dynamic-programming", "counting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-08-23
來源筆記：`notes/day44-week8-day2-target-sum-dice-rolls-shard-key-hot-shard.md`

## 解題思路

這篇整理 Number of Dice Rolls With Target Sum 的解題筆記，重點放在 layered counting DP with bounded per-step choices、狀態定義、轉移式與容易犯錯的地方。

## 解法

以下內容整理自當天的 learning note，保留英文關鍵句，方便之後直接拿來做面試口說複習。

- **Pattern:** layered counting DP with bounded per-step choices.

## Why This Fits
This is not subset choice and not unbounded reuse.

The real question is:
```text
after rolling exactly d dice, how many ways produce sum s?
```

## Core State / Invariant
2D form:
```text
dp[d][s] = number of ways to make sum s using exactly d dice
```

Compressed form:
```text
dp[s] = number of ways from the previous dice layer
newDp[s] = number of ways for the current dice layer
```

## Base Case
Before rolling any dice:
```text
dp[0] = 1
```

Reason:
```text
there is exactly one way to make sum 0 with 0 dice
```

## Transition
For each die, for each target sum, try every face:
```text
newDp[s] += dp[s - face]
```

when:
```text
s - face >= 0
```

Apply modulo after each addition.

## Why `newDp` Is Required
The current layer must only read:
```text
states from d - 1 dice
```

If updated in place, one die could contribute multiple times in the same layer, which is incorrect.

## Complexity
```text
Time: O(n * target * k)
Space: O(target)
```

## Common Mistakes
- wrong base-case explanation for `dp[0]`
- trying to reuse a single array in place like `LC 518`
- saying this is unbounded knapsack
- forgetting modulo in the recurrence

## Strong Spoken Explanation
I model this as counting ways by dice layer. `dp[s]` means the number of ways to make sum `s` from the previous number of dice, and for each new die I build a fresh `newDp`. For each target sum and each face value from `1` to `k`, I add the number of ways to reach `s - face` from the previous layer. The key invariant is that when computing the layer for `d` dice, I must only read states from `d - 1` dice, which is why I use `newDp` instead of in-place updates.

## Problem 3 - Graph Maintenance: LC 1631 Or LC 743
- **Pattern:** shortest-path recall only.

## Why This Slot Exists
Week 8 is knapsack-heavy, so one graph slot prevents:
- Dijkstra drift
- shortest-path explanation decay

## Must-Hit Spoken Lines
If using `LC 1631`:
```text
path cost is the maximum edge effort on the path, so relaxation uses max(current_effort, edge_cost)
```

If using `LC 743`:
```text
this is single-source shortest path with non-negative weights, so Dijkstra fits
```

## Current Status
- not completed today

## Topic - Shard Key Choice, Hot Shards, And Cross-Shard Query Pain

## First Judgment
If your answer is only:
```text
I would shard by hospital_id so each hospital goes to one shard
```

that is below Tier A/S mid-level bar.

A stronger answer must say:
- what the dominant read and write patterns are
- whether the key distributes traffic and storage well
- what happens if one hospital is much hotter than the rest
- what queries become cross-shard and how painful that is

## What A Strong Mid-Level Candidate Must Know
- why sharding exists:
  - one primary may hit write, storage, or connection limits
- shard key choice must consider:
  - distribution
  - locality
  - query routing
  - future resharding pain
- common shard-key pitfalls:
  - one giant tenant
  - time-based hot partition
  - keys that force too many cross-shard fan-outs
- hot shard problem:
  - one shard gets a disproportionate share of read or write load
- cross-shard pain:
  - joins
  - aggregations
  - transactions
  - rebalancing

## Strong Answer Components
- name the first bottleneck:
  - write throughput
  - connection pool pressure
  - one hot tenant
  - large tenant-specific range scans
- choose a shard key and defend it from workload shape
- say what still stays hard:
  - cross-shard patient search
  - cross-hospital reporting
  - multi-tenant billing aggregate
- mention mitigation:
  - tenant + hash suffix
  - separate hot tenant
  - precomputed aggregates
  - asynchronous cross-shard analytics

## Shard-Key Decision Framework
Before choosing a key, answer these in order:
1. What is the dominant routing unit?
   - hospital
   - patient
   - appointment
   - region / tenant
2. Which operations must stay single-shard?
   - transactional writes
   - tenant-scoped reads
   - common range scans
3. Where is skew likely?
   - one giant hospital
   - one time-window burst
   - one high-traffic entity type
4. Which queries can tolerate fan-out or async paths?
   - reporting
   - cross-hospital search
   - global analytics
5. What cheaper fix should be ruled out first?
   - bad index / query
   - slow replica routing
   - cacheable hot reads
   - connection-pool tuning

## Concrete ASUS / Hospital Examples
- if most traffic is scoped to one hospital:
  - `hospital_id` is a natural locality key
- if one hospital can dominate traffic:
  - plain `hospital_id` may create a hot shard
  - consider isolating that tenant or hashing within tenant-specific buckets
- if the product needs global doctor search or cross-hospital analytics:
  - those become fan-out reads or need a separate reporting path

## Failure Cases And Edge Cases
- one large hospital gets most write traffic and saturates one shard
- time-correlated writes hit one shard because the key has poor distribution
- cross-shard joins become slow, operationally fragile, or unsupported
- resharding needs data movement and dual-write / backfill complexity
- application code accidentally loses routing discipline and broadcasts too often

## Trade-Offs
- tenant-local shard key:
  - simple routing and good tenant locality
  - risk of hot tenant imbalance
- hash-based shard key:
  - better distribution
  - worse locality and harder range reads
- more shards:
  - more headroom
  - more operational overhead, rebalancing cost, and fan-out pain

## What Breaks At Scale
- one shard becomes the bottleneck long before average shard utilization looks bad
- cross-shard analytics pile up latency and coordination cost
- resharding windows get harder as data grows
- debugging performance becomes harder because `slow query` is now `slow fan-out workflow`

## What To Log Or Measure
- per-shard QPS
- per-shard write rate
- per-shard storage growth
- hot-tenant traffic skew
- cross-shard query rate
- tail latency by shard
- rebalance / reshard duration and error rate

## What To Draw In 5-10 Minutes
For a strong mid-level answer, be able to sketch:
- request router / app tier
- shard map or routing function
- primary + replica inside one shard
- one hot-tenant path
- one cross-shard reporting path that goes through async aggregation instead of OLTP fan-out on the critical request path

The drawing should support this explanation:
```text
tenant-scoped writes stay on one shard,
tenant-scoped reads route directly,
cross-shard analytics leave the request path and run through a separate reporting flow
```

## 30-45 Minute Design Pushback
If the interviewer turns this into a design discussion, your answer should sound like:
1. Start with why one primary is hurting:
   - write CPU
   - storage growth
   - connection pressure
   - tenant skew
2. Reject premature sharding if the real issue is still:
   - one bad query
   - missing composite index
   - replica lag after writes
   - cacheable read hotspots
3. Choose the first shard strategy:
   - `hospital_id` if most requests are tenant-local and tenant sizes are reasonably balanced
   - isolate very large tenants if skew is real
   - use tenant + hash or entity-level bucketing only if a single tenant still overloads one shard
4. Say what becomes harder immediately:
   - cross-hospital search
   - billing aggregates
   - multi-shard transactions
   - resharding and backfills
5. Give the operational control loop:
   - measure skew
   - detect hot shards
   - split or isolate the hot tenant
   - move reporting off the OLTP path

## Integrity And Failure Boundaries
A strong answer should also mention what correctness becomes harder after sharding:
- multi-shard transactions are harder to keep simple and fast
- uniqueness constraints may stop being globally cheap
- idempotent writes still matter because retries can hit the router again during failures
- resharding introduces backfill, dual-read, or dual-write risk if cutover is careless

## Interviewer Pushback Questions
1. Why is `hospital_id` a good shard key here, and when does it fail?
2. What if one hospital is 20x larger than the others?
3. Which queries become cross-shard, and how would you handle them?
4. How would you detect a hot shard early?
5. When would replication or caching help more than sharding?

## Strong 60-90 Second Answer
I would choose a shard key from the dominant access pattern, not just from schema shape. In a hospital DAL, if most reads and writes are scoped to one hospital, `hospital_id` gives good routing locality, but I would immediately ask whether one hospital can dominate traffic. If tenant size is skewed, plain `hospital_id` can create a hot shard, so I may need a mitigation like isolating large tenants or adding a hashed sub-bucket for the hottest entity paths. I would also call out what becomes painful after sharding: cross-hospital reporting, global search, joins, and multi-shard transactions. Before claiming sharding is the right move, I would measure traffic skew, per-shard load, cross-shard query rate, and whether the real bottleneck is still just one slow query or connection-pool pressure on the current primary.

## Deliverables

By the end of W8D2, you should be able to:
- derive `LC 494` from sign assignment into exact subset-sum counting
- explain why `LC 1155` needs per-die layers and `newDp`
- say one clean difference between `LC 494`, `LC 518`, and `LC 1155`
- defend one shard key choice for the hospital DAL and say when it fails
- explain one hot-shard failure mode and one mitigation
- answer what cross-shard operation gets painful first and how you would measure it
- draw one sharded hospital-DAL request flow with OLTP routing and separate reporting path
- answer under pushback:
  - why sharding is needed now instead of later
  - why replication or Redis is not enough
  - what would break during skew or resharding

## 收穫

- 先講清楚 state meaning，再寫 recurrence。
- base case、迴圈方向、return value 要在 coding 前確認。
- 如果是 DP 壓縮、graph traversal、或 greedy frontier，要能說出 invariant 為什麼成立。

## 遇到的問題

原始筆記沒有另外紀錄失誤點。
