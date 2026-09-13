---
title: "LeetCode 1049: Last Stone Weight II"
summary: "LeetCode 解題筆記：Last Stone Weight II"
description: "2026-08-19 的 LeetCode 學習紀錄"
date: 2026-08-19
tags: ["medium", "dynamic-programming", "knapsack", "subset-sum"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-08-19
來源筆記：`notes/day45-week8-day3-ones-and-zeroes-last-stone-redis-cache-aside.md`

## 解題思路

這篇整理 Last Stone Weight II 的解題筆記，重點放在 `0/1` subset partition with best-half approximation、狀態定義、轉移式與容易犯錯的地方。

## 解法

以下內容整理自當天的 learning note，保留英文關鍵句，方便之後直接拿來做面試口說複習。

- **Pattern:** `0/1` subset partition with best-half approximation.

## Why This Fits
If the stones are partitioned into two groups with sums:
```text
A and B
```

then the final remaining weight is:
```text
|A - B|
```

So the real goal is:
```text
find a reachable subset sum as close as possible to total / 2
```

## Core State / Invariant
```text
dp[s] = whether some subset of processed stones can make sum s
```

## Base Case
```text
dp[0] = true
```

Reason:
```text
choosing no stones makes sum 0
```

## Transition
For each stone, iterate backward:
```text
dp[s] |= dp[s - stone]
```

## Final Answer
Find the largest reachable:
```text
s <= total // 2
```

Then return:
```text
total - 2 * s
```

## Complexity
```text
Time: O(len(stones) * target)
Space: O(target)
```

## Common Mistakes
- treating smash operations as simulation instead of partitioning
- using forward iteration and reusing one stone
- thinking maximize-value DP is required
- forgetting the final scan for best reachable half

## Strong Spoken Explanation
I reframe the smash process as partitioning stones into two groups. If the group sums are `A` and `B`, the final leftover is `|A - B|`, so I want the two sums as close as possible. That means I only need subset sums up to `total // 2`. I use boolean `0/1` DP where `dp[s]` tells me whether sum `s` is reachable from the processed stones. After filling the table, I scan downward from `total // 2` for the largest reachable `s` and return `total - 2 * s`.

## Compare Drill - `0/1` Vs Unbounded Knapsack

You should be able to say:
- `LC 416`:
  - `0/1` reachability
- `LC 518`:
  - unbounded counting combinations
- `LC 474`:
  - two-capacity `0/1` maximization
- `LC 1049`:
  - `0/1` reachability to best-half target

Current status:
- partial pass
- worth one faster no-notes recap

## Topic - Redis Cache-Aside, Invalidation, And Stale-Read Trade-Offs

## First Judgment
If your answer is only:
```text
cache-aside means read cache first, then DB, and set cache on miss
```

that is below Tier A/S mid-level bar.

A stronger answer must say:
- which endpoints are cacheable
- how cache entries are invalidated or refreshed after writes
- how much staleness is acceptable
- what happens during hot-key storms or Redis outage

## What A Strong Mid-Level Candidate Must Know
- cache-aside flow:
  - read from cache
  - on miss, read DB
  - write result into cache
- invalidation choices:
  - delete-on-write
  - write-through / explicit refresh
  - TTL plus background refresh
- stale-read trade-off:
  - some endpoints tolerate seconds of drift
  - payment / booking / critical status endpoints often should not
- hot-key and stampede risks:
  - many requests pile onto one key
  - expiry can cause DB surge
- fallback behavior:
  - Redis down should not take down the whole product path by default

## Strong Answer Components
- name three endpoints you would cache and why
- name three endpoints you would not cache and why
- describe the write path after an update:
  - invalidate
  - refresh
  - or accept bounded TTL staleness
- explain one stale-read trade-off that is acceptable and one that is not
- mention one mitigation for:
  - stampede
  - hot key
  - Redis outage

## Concrete ASUS / Hospital Examples
- good cache candidates:
  - hospital metadata
  - doctor directory
  - static configuration / feature flags
- risky cache candidates:
  - appointment availability
  - payment status
  - critical patient-state transitions
- mixed case:
  - dashboard summary may tolerate slight staleness, but drill-down action pages may not

## Failure Cases And Edge Cases
- cache entry expires and thousands of requests thump the DB
- cache shows old appointment availability after a booking update
- Redis hot key gets disproportionate traffic
- stale negative cache hides a just-created resource
- Redis outage causes large miss storms on the DB

## Trade-Offs
- long TTL:
  - better hit rate
  - more stale data risk
- short TTL:
  - fresher data
  - more DB pressure and more stampede risk
- delete-on-write:
  - simple
  - next read may stampede
- write-through / refresh-on-write:
  - fresher cache
  - more write-path complexity

## What Breaks At Scale
- hot keys distort otherwise healthy cache hit rates
- miss storms create secondary DB incidents
- stale status pages trigger repeated user actions
- cache hides bad query design until load pattern shifts

## What To Log Or Measure
- hit rate and miss rate by endpoint
- cache fill latency
- Redis error / timeout rate
- hot-key frequency
- fallback-to-DB rate
- DB QPS after cache expiry events
- stale-read incident reports on user-facing endpoints

## Interviewer Pushback Questions
1. How do you invalidate cache after a write?
2. Which endpoints in the hospital DAL would you never cache?
3. How do you stop a cache stampede after expiry?
4. What if Redis is down?
5. When is Redis hiding a DB/index problem instead of solving one?

## Strong 60-90 Second Answer
I would treat Redis as an endpoint-specific optimization, not a default answer. For cache-aside, reads hit Redis first, fall back to the DB on miss, then populate the cache. The real design work is deciding freshness and invalidation. For stable metadata or directory-style reads, cache-aside with TTL is fine. For appointment availability or payment status, I would be much more careful because stale data can trigger real product bugs. After writes, I would usually prefer delete-or-refresh behavior rather than relying only on TTL. I would also name the operational risks: stampede on expiry, hot keys, stale negative cache, and Redis outages. The system should measure hit rate, fallback-to-DB rate, Redis errors, and user-visible stale-read incidents before I call the cache design healthy.

## Deliverables

By the end of W8D3, you should be able to:
- explain `LC 474` as a two-capacity `0/1` knapsack with backward loops in both dimensions
- explain `LC 1049` as a partition problem, not a simulation problem
- compare `0/1` vs unbounded knapsack across at least four Week 8 problems
- name cacheable vs non-cacheable hospital endpoints
- explain one invalidation strategy and one stale-read trade-off
- answer what happens during stampede, hot-key traffic, and Redis outage

## 收穫

- 先講清楚 state meaning，再寫 recurrence。
- base case、迴圈方向、return value 要在 coding 前確認。
- 如果是 DP 壓縮、graph traversal、或 greedy frontier，要能說出 invariant 為什麼成立。

## 遇到的問題

原始筆記沒有另外紀錄失誤點。
