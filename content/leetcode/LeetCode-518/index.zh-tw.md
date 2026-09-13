---
title: "LeetCode 518: Coin Change 2"
summary: "LeetCode 解題筆記：Coin Change 2"
description: "2026-08-23 的 LeetCode 學習紀錄"
date: 2026-08-23
tags: ["medium", "dynamic-programming", "unbounded-knapsack"]
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
來源筆記：`notes/day43-week8-day1-partition-coin-change-replication-lag.md`

## 解題思路

這篇整理 Coin Change 2 的解題筆記，重點放在 unbounded knapsack counting combinations、狀態定義、轉移式與容易犯錯的地方。

## 解法

以下內容整理自當天的 learning note，保留英文關鍵句，方便之後直接拿來做面試口說複習。

- **Pattern:** unbounded knapsack counting combinations

## Why This Fits
Each coin can be reused:
```text
any number of times
```

The question is:
```text
how many combinations make the amount?
```

## Core State / Invariant
```text
dp[a] = number of combinations to make amount a using the coins processed so far
```

## Base Case
```text
dp[0] = 1
```

Reason:
```text
there is exactly one way to make amount 0: choose no coins
```

## Transition
For each `coin`:
```text
dp[a] += dp[a - coin]
```

when:
```text
a >= coin
```

## Why Loop Direction Matters
Iterate amount forward:
```text
for a from coin up to amount
```

Reason:
```text
forward iteration lets the current coin be reused in the same coin round
```

## Complexity
```text
Time: O(len(coins) * amount)
Space: O(amount)
```

## Common Mistakes
- iterating amount backward and accidentally enforcing `0/1`
- putting amount as the outer loop and counting permutations instead of combinations
- saying `dp[a]` is minimum coins instead of number of ways
- forgetting why `dp[0] = 1`

## Strong Spoken Explanation
I define `dp[a]` as the number of combinations to make amount `a` using the coins processed so far. The base case is `dp[0] = 1`, because there is exactly one way to make amount zero: choose nothing. For each coin, I iterate amounts forward so the same coin can be reused in the same round. The transition is `dp[a] += dp[a - coin]`. Keeping coins as the outer loop makes the answer combinations rather than permutations.

## Problem 3 - Review: LC 322 Coin Change
- **Pattern:** unbounded knapsack optimization

## Why This Review Matters
`LC 322` looks close to `LC 518`, but the answer shape is different:
- `LC 518`: count combinations
- `LC 322`: minimize number of coins

That means the state meaning, sentinel handling, and spoken answer all change.

## Core State / Invariant
```text
dp[a] = minimum number of coins needed to make amount a
```

## Base Case
```text
dp[0] = 0
```

Unreachable amounts start at:
```text
infinity or a large sentinel
```

## Transition
For each `coin`:
```text
dp[a] = min(dp[a], dp[a - coin] + 1)
```

## Complexity
```text
Time: O(len(coins) * amount)
Space: O(amount)
```

## Common Mistakes
- saying `LC 518` and `LC 322` are basically the same
- forgetting unreachable sentinel values
- mixing `count` semantics with `min` semantics

## Strong Spoken Explanation
This is still unbounded coin use, but the state is no longer the number of ways. Now `dp[a]` means the minimum number of coins needed to make amount `a`, so the transition is `min`, not addition. That is why `LC 322` and `LC 518` belong to the same family but require different answer-shape reasoning.

## Fast Compare Drill - `0/1` Vs `Unbounded`

## Recognition Cues
- `0/1`:
  - each item can be taken at most once
  - subset or assignment style wording
  - compressed 1D sum loop usually goes backward
- `unbounded`:
  - same value can be reused many times
  - coin, rod, or repeatable resource wording
  - compressed 1D sum or amount loop usually goes forward

## State-Meaning Drill
- `LC 416`:
  - `dp[s] = reachable or not`
- `LC 518`:
  - `dp[a] = number of combinations`
- `LC 322`:
  - `dp[a] = minimum number of coins`

## Strong 45-Second Answer
I do not classify knapsack problems by surface wording alone. I ask three things: can each item be reused, what exactly does `dp[...]` represent, and what loop direction preserves that meaning in 1D compression. `LC 416` is `0/1` reachability so the target loop goes backward. `LC 518` is unbounded counting so the amount loop goes forward. `LC 322` is also unbounded, but its state is minimum coins, so the recurrence and invalid-state handling are different.

## Topic - Replication Lag, Read-After-Write, And Replica Routing

## First Judgment
If your answer is only:
```text
replicas scale reads but can be stale
```

that is below Tier A/S mid-level bar.

A strong answer must say:
- what the write path is
- what bug lag creates for the user or downstream workflow
- which endpoints require read-your-writes behavior
- what routing rule you apply immediately after a write
- what happens when real lag exceeds your routing window
- what you measure to prove the design is healthy

## What A Strong Mid-Level Candidate Must Know
- writes usually land on the primary first
- replicas apply that change later, not instantly
- lag creates read-after-write inconsistency, not just vague staleness
- consistency should be chosen by endpoint, not one global slogan
- routing options include:
  - temporary read-from-primary after write
  - session or user stickiness for a bounded window
  - version or LSN based gating if the stack supports it
  - explicit `pending` or `processing` UX when freshness cannot be guaranteed cheaply
- replicas do not fix:
  - bad query shape
  - missing indexes
  - the primary write bottleneck
  - bad transactional design

## Strong Answer Components
- start from one concrete hospital flow:
  - create appointment
  - capture payment
  - update patient demographics
- name the actual failure:
  - newly created row not visible
  - old status still shown
  - user retries because the previous success is not visible yet
- classify endpoints by freshness requirement:
  - primary-consistent
  - bounded post-write primary routing
  - stale-tolerant
- say what evidence would make you add replicas instead of first fixing query or index design

## Concrete Hospital Examples

### Example 1 - Appointment Confirmation
Flow:
```text
POST /appointments -> commit on primary -> immediate GET /appointments/{id}
```

Lag bug:
```text
the write succeeded, but the user sees not found or pending because the GET hit a lagging replica
```

Strong answer:
- the immediate confirmation path should read from primary or use a post-write consistency rule
- a lagging replica is not acceptable for this endpoint

### Example 2 - Billing Status After Payment Capture
Flow:
```text
payment status becomes captured on primary -> user refreshes invoice page
```

Lag bug:
```text
invoice still shows unpaid, user retries payment, duplicate-risk workflow begins
```

Strong answer:
- billing or payment status is usually not a stale-tolerant read
- if freshness is not guaranteed, show explicit pending state rather than pretending the old state is correct

### Example 3 - Reporting Dashboard
Flow:
```text
daily hospital metrics, admin dashboards, or trend charts
```

Trade-off:
```text
slightly stale data is often acceptable if the read load is heavy
```

Strong answer:
- this is a much better replica candidate
- but only after the base query is already reasonable

## Failure Cases And Edge Cases
- write commits on primary, immediate read on replica misses the row
- different replicas are at different lag points, so the same user sees inconsistent results across refreshes
- stale status causes duplicate user actions
- lag spikes during failover, heavy write bursts, or long-running replica apply backlog
- replicas spread reads, but the primary remains overloaded because critical endpoints still need primary consistency

## Trade-Offs
- more primary reads:
  - fresher reads
  - more pressure on the writer
- more replica reads:
  - better read scale
  - more stale-read risk
- bounded post-write stickiness:
  - pragmatic and common
  - still fails if lag exceeds the chosen window
- explicit pending UX:
  - more honest under async visibility
  - adds product and API complexity

## What Breaks At Scale
- larger write bursts create more noticeable lag windows
- read-your-writes traffic may still concentrate on primary and exhaust its pool
- stale status pages can amplify retries and create self-inflicted load spikes
- adding replicas without query discipline can just multiply expensive reads
- primary write throughput or lock contention remains the real bottleneck even if replica capacity looks healthy

## What To Log Or Measure
- replica lag by node
- primary and replica connection-pool saturation
- immediate-after-write fallback-to-primary rate
- stale-read incidents on critical endpoints
- duplicate action rate after write-heavy flows
- slow-query rate on primary and replicas
- per-endpoint primary vs replica routing split

## Interviewer Pushback Questions
1. How do you handle a read right after a write if replicas lag?
2. Which endpoints in a hospital DAL would you keep primary-consistent?
3. Why are replicas not the right first move for every DB scaling problem?
4. What if your stickiness window is shorter than the actual lag spike?
5. How would you prove lag is a real product problem, not just a theoretical one?

## Strong 60-90 Second Answer
In a primary and replica setup, the write commits on the primary first and replicas catch up later, so the first bug to name is read-after-write inconsistency. For example, if an appointment confirmation succeeds but the immediate follow-up GET hits a lagging replica, the user may see `not found` or the old status. So I would classify endpoints by freshness requirement rather than saying `all reads go to replicas`. Confirmation, payment, and user-facing status endpoints usually need primary-consistent reads or bounded post-write primary routing. Reporting and analytics can usually tolerate replica lag. I would also say replicas do not fix bad query shape or primary write bottlenecks, so I would measure lag, fallback-to-primary rate, and endpoint-level stale-read incidents before calling the system healthy.

## Strong 10-15 Minute Deep Dive Shape
If the interviewer pushes deeper, structure the answer in this order:
1. Request flow:
   - client write
   - primary commit
   - replication apply
   - follow-up read
2. Consistency classification:
   - which endpoints must see fresh state
   - which can tolerate bounded staleness
3. Routing strategy:
   - primary on immediate follow-up
   - session or user stickiness
   - pending state if freshness is ambiguous
4. Operational limits:
   - primary pool pressure
   - lag spikes
   - uneven replica health
5. Observability:
   - lag
   - fallback rate
   - duplicate user actions

## Strong 30-45 Minute Design + Pushback Drill
Prompt:
```text
Scale a hospital DAL from 10 to 500 hospitals. Reads are growing fast, writes still go through one primary, and some patient-facing pages refresh immediately after updates.
```

What you should design:
- endpoint classification:
  - appointment confirmation
  - payment status
  - patient search
  - admin dashboard
- routing rules:
  - which reads can hit replicas by default
  - which reads must stay on primary
  - which reads use bounded post-write routing
- fallback rules:
  - what happens if lag exceeds the safe window
  - whether to serve primary, return pending, or degrade the feature
- metrics and alarms:
  - lag thresholds
  - fallback spikes
  - duplicate action signals
- pushback defense:
  - why not add more replicas only
  - why not cache everything with Redis first
  - what still bottlenecks on the primary

## Practice Questions From This Session

Use these as recall prompts. The goal is not perfect wording, but being able to answer each one cleanly without drifting back into slogans.

## Foundation Round
1. What is replication lag, and why can it cause old data right after a successful write?
   - Key answer shape:
     - write commits on `primary`
     - replica applies later
     - immediate read from replica can still return old state
2. Which is more likely to require a fresh read from primary:
   - appointment confirmation page right after update
   - admin reporting dashboard
   - Key answer shape:
     - confirmation/status pages are freshness-critical
     - dashboard/reporting pages are usually stale-tolerant
3. What do replicas help with, and what do replicas not fix?
   - Key answer shape:
     - replicas help scale reads
     - they do not fix bad query shape, missing indexes, write bottlenecks, or lock contention on the primary
4. What endpoint types can usually tolerate replica reads, and which should usually stay fresh?
   - Examples to remember:
     - stale-tolerant: admin dashboards, reporting, analytics
     - fresh-critical: appointment status, payment or invoice status
5. What would you measure in production to know whether lag is hurting users?
   - Key answer shape:
     - replica lag
     - stale-read incidents on critical flows
     - duplicate user actions
     - fallback-to-primary rate
6. A user updates an appointment, then refreshes immediately. What is the simplest safe routing rule?
   - Key answer shape:
     - immediate follow-up read goes to `primary`

## Core Mid-Level Questions
1. Why is `just add replicas` sometimes a bad first answer?
   - Key answer shape:
     - first determine whether pressure comes from reads, writes, or bad query shape
     - freshness-critical reads may still need `primary`
2. What if replica lag spikes beyond the sticky window?
   - Key answer shape:
     - do not blindly trust replicas again
     - extend the window dynamically, keep reading from `primary`, or return `pending`
3. Why is `pending` sometimes better than stale data?
   - Key answer shape:
     - stale data misleads the user
     - `pending` is honest and avoids duplicate actions based on false old state
4. Why is measuring replica lag alone not enough?
   - Key answer shape:
     - lag shows delay, not product impact
     - also measure stale reads, duplicate actions, and endpoint-specific user harm
5. How do you decide whether to add replicas, fix query/index design first, or change routing for freshness-critical endpoints?
   - Key answer shape:
     - classify the bottleneck first
     - optimize bad queries/indexes before scaling them
     - route read-after-write paths for correctness, not for load balancing

## Redis Vs Replica Pushback
1. Why not just put Redis in front of the database instead of using replicas?
   - Key answer shape:
     - Redis and replicas solve different problems
     - Redis is a cache with invalidation complexity
     - replicas keep reads inside the DB model but can lag
2. Which endpoint types are good Redis candidates, and which are bad ones?
   - Good examples:
     - dashboard summaries
     - metadata or low-change, high-read views
   - Bad examples:
     - payment status
     - appointment status right after write
3. If an endpoint is freshness-critical, can it still use Redis?
   - Key answer shape:
     - yes, but not as a blind source of truth
     - needs invalidation discipline, short TTL, or bypass/fallback to `primary`
4. What is the difference between replica lag and cache invalidation problems?
   - Key answer shape:
     - replica lag: primary is newer than replica for a while
     - cache invalidation: database is newer than cache because update/delete/refresh logic missed or lagged
5. Which is usually harder to reason about safely in the application: replica lag or cache invalidation?
   - Key answer shape:
     - cache invalidation is usually harder
     - app must keep DB and cache aligned correctly
6. If users can tolerate stale data for 5 seconds, does that automatically mean Redis is the best answer?
   - Key answer shape:
     - no
     - stale tolerance alone is not enough
     - also ask whether the data is read frequently enough to justify cache complexity
7. Why not use both Redis and replicas together for appointment status?
   - Key answer shape:
     - appointment status is often freshness-critical
     - stacking cache plus replica lag can make correctness and debugging harder
8. How would you bypass Redis safely right after a write?
   - Key answer shape:
     - add a short-lived post-write bypass marker by user or resource
     - immediate follow-up reads skip Redis and use `primary`
9. Why is TTL alone not enough to guarantee fresh reads after a write?
   - Key answer shape:
     - TTL only limits how long a cached value can stay around
     - it does not prove the cache already contains the latest write
10. If the cache is refilled from a lagging replica, what can go wrong?
    - Key answer shape:
      - old cache entry expires
      - new cache entry is still stale because refill source was stale

## Harder System Design Pushback
1. Traffic grew 10x and primary CPU is high. How do you decide:
   - which reads go to replicas
   - which stay on primary
   - where Redis is appropriate
   - what to measure first
2. If payment must stay on primary, does that mean the primary always becomes the bottleneck?
   - Key answer shape:
     - not automatically
     - minimize the set of truly freshness-critical reads
     - optimize indexes, transaction length, lock scope, and idempotency
3. What can still go wrong even if appointment flow uses sticky read-after-write?
   - Key answer shape:
     - lag can exceed the window
     - another session or device may still hit stale paths
     - sticky routing does not replace write-side invariants
     - too many sticky reads can overload `primary`
4. Why is sticky read-after-write a heuristic, not a correctness guarantee?
   - Key answer shape:
     - window is based on expected lag, not actual proven freshness
5. What would a stronger approach than a fixed sticky window look like?
   - Key answer shape:
     - use real freshness signals like lag metrics or version / commit-position style gating
     - fall back to `primary` when freshness cannot be guaranteed
6. What is the difference between preventing duplicate bookings and preventing stale reads after booking?
   - Key answer shape:
     - duplicate booking prevention is write-side invariant enforcement
     - stale-read prevention is read routing / consistency policy
7. If unique constraints and idempotency already protect correctness, why do stale reads still matter?
   - Key answer shape:
     - stale reads still confuse users, create retries, amplify traffic, and add support noise
8. How would you compare `primary reads`, `sticky read-after-write`, and `pending state`?
   - Key answer shape:
     - `primary`: strongest freshness, highest primary pressure
     - `sticky`: practical middle ground, but heuristic only
     - `pending`: safest when visibility is uncertain, but adds product complexity
9. How are read replicas and Redis not interchangeable?
   - Key answer shape:
     - replicas are DB read scale with lag
     - Redis is cache acceleration with invalidation complexity
10. What is the difference between scaling read traffic and scaling correctness-critical read traffic?
    - Key answer shape:
      - stale-tolerant reads have more scaling freedom
      - freshness-critical reads have fewer safe options and often stay near `primary`

## Debugging Questions
1. If both replicas and Redis can be stale, how do you keep the design understandable?
   - Key answer shape:
     - make endpoint-level consistency policy explicit
     - avoid stacking every layer on every critical path
2. How would you debug whether stale data came from Redis or from replica lag?
   - Key answer shape:
     - log the data source for each request:
       - `primary`
       - `replica`
       - Redis hit
       - cache miss then DB read
     - include bypass flags, replica identity, and cache metadata
3. How would you debug:
   - `I updated my appointment, refreshed, and still saw the old status`
   - Key answer shape:
     - confirm the write actually succeeded
     - inspect the follow-up read path and source
     - verify read-after-write routing
     - check lag during that period
     - if Redis was involved, inspect invalidation and refill source

## Key Corrections From This Session
- Do not say primary reads prevent overbooking by themselves.
  - overbooking prevention is mainly write-side correctness:
    - unique constraint
    - transaction or lock
    - idempotency
- Sticky read-after-write means route immediate post-write reads to `primary`, not to `replica`.
- Redis does not automatically `solve duplicate request`.
  - it can help with dedupe or token storage, but duplicate protection is still an app / write-path design problem.
- TTL is only a time-based heuristic.
  - it does not prove the cache includes the newest write.
- Replica lag and cache invalidation are different failure sources.
  - keep them separate in your explanation and debugging flow.

## Deliverables

By the end of Day 43, you should be able to:

- explain `LC 416` as `0/1` reachability with backward loop direction
- explain `LC 518` as unbounded counting with forward loop direction
- explain why `LC 322` is a different answer shape from `LC 518`
- give a clean `45 sec` comparison of `0/1` vs `unbounded`
- give a `60-90 sec` replication-lag answer tied to one hospital flow
- draw the post-write request path:
  - client
  - app
  - primary write
  - replica apply
  - follow-up read routing
- design one endpoint-classification table:
  - primary-consistent
  - bounded post-write primary routing
  - stale-tolerant
- answer under pushback:
  - what if lag spikes beyond the window
  - what replicas solve
  - what replicas do not solve
  - what you would log and measure

## 收穫

- 先講清楚 state meaning，再寫 recurrence。
- base case、迴圈方向、return value 要在 coding 前確認。
- 如果是 DP 壓縮、graph traversal、或 greedy frontier，要能說出 invariant 為什麼成立。

## 遇到的問題

原始筆記沒有另外紀錄失誤點。
