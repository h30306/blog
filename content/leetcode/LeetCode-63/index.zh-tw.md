---
title: "LeetCode 63: Unique Paths II"
summary: "LeetCode 解題筆記：Unique Paths II"
description: "2026-06-27 的 LeetCode 學習紀錄"
date: 2026-06-27
tags: ["medium", "dynamic-programming", "grid-dp"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-06-27
來源筆記：`notes/day29-week6-day1-unique-paths-composite-index-order.md`

## 解題思路

這篇整理 Unique Paths II 的解題筆記，重點放在 2D counting DP with blocked cells、狀態定義、轉移式與容易犯錯的地方。

## 解法

以下內容整理自當天的 learning note，保留英文關鍵句，方便之後直接拿來做面試口說複習。

- **Pattern:** 2D counting DP with blocked cells.

## Why This Fits
This is the same table as `LC 62`, with one upgrade:
```text
some cells are unreachable because they are obstacles
```

So the real test is not a new pattern.

It is whether you can preserve the old state meaning under a new legality rule.

## Core State / Invariant
```text
dp[r][c] = number of valid paths from the start to cell (r, c) without stepping on obstacles
```

## Base Cases
If the start cell is blocked:
```text
answer = 0
```

Otherwise:
```text
dp[0][0] = 1
```

Boundary nuance:
- first row cells stay reachable only until the first obstacle appears
- first column cells stay reachable only until the first obstacle appears

Because after an obstacle on the boundary:
```text
there is no alternative route from above or left on that boundary
```

## Transition
If the current cell is an obstacle:
```text
dp[r][c] = 0
```

Otherwise:
```text
dp[r][c] = dp[r - 1][c] + dp[r][c - 1]
```

## Complexity
```text
Time: O(m * n)
Space: O(m * n)
```

Can also be compressed to:
```text
Space: O(n)
```

## Common Mistakes
- forgetting that blocked start cell means immediate `0`
- filling the first row / first column with `1` even after an obstacle already appeared
- using the `LC 62` recurrence blindly without zeroing obstacle cells
- saying the obstacle cell is `-inf` or `None` instead of `0` ways

## Strong Spoken Explanation
I keep the same state as `LC 62`: `dp[r][c]` is the number of valid paths to cell `(r, c)`. The difference is that obstacle cells contribute zero paths because I am not allowed to stand on them. If the start is blocked, the answer is immediately zero. For non-obstacle cells, the recurrence is still `up + left`, but the boundary initialization must stop once an obstacle appears because cells later on that boundary are no longer reachable from only one direction.

## Problem 3 - Stock Review: LC 309 Best Time To Buy And Sell Stock With Cooldown
- **Pattern:** state-machine recall under pressure.

## Why This Review Stays
Week 6 introduces a new DP surface area.

The stock review makes sure Week 5 does not decay into:
```text
I used to know it last week
```

## Must-Hit State Meaning
```text
hold = best profit ending today while holding one stock
sold = best profit if I sold today
rest = best profit ending today while not holding and not selling today
```

## Must-Hit Transition Logic
```text
hold = max(prev_hold, prev_rest - price)
sold = prev_hold + price
rest = max(prev_rest, prev_sold)
```

## Must-Hit Spoken Line
```text
the cooldown means I cannot buy from yesterday's sold state, so buy can come only from rest
```

## Pass Standard
You pass the review only if you can do all 3:
1. define the exact state meaning before coding
2. explain why buying from `sold` is illegal
3. name the final answer as a non-holding state

## Topic - Composite Index Order And Leftmost Prefix

## First Judgment
The original day topic:
```text
leftmost prefix rule and why composite index order matters
```

is directionally correct but still too shallow for Tier A/S unless you can answer:
- which exact queries can use the prefix
- where the usable prefix stops
- what ordering benefit survives
- why one column order helps one endpoint but hurts another

If the answer is only:
```text
put the most selective column first
```

that is below the bar.

That slogan is incomplete because column order depends on:
- equality vs range predicates
- whether ordering must be satisfied
- tenant scoping
- workload mix
- whether one index must serve several similar queries

## What A Strong Mid-Level Candidate Must Know
- composite index means one sorted order over tuples, not several independent single-column indexes
- leftmost prefix requires a contiguous usable prefix from the leading columns
- a missing leading column prevents efficient narrow seek on later columns
- equality predicates usually preserve the ability to keep using later columns
- the first range predicate usually stops further seek narrowing
- `ORDER BY` can be satisfied cheaply only when it is compatible with the index order after earlier predicates are applied
- a good column order for one query can be bad for another nearby query
- wider composite indexes may help covering but increase write cost, index size, and cache pressure

## Core Mental Model

Suppose the index is:
```text
(hospital_id, status, scheduled_at)
```

Think of the leaf order as:
```text
first grouped by hospital_id,
then within that by status,
then within that by scheduled_at
```

This means the engine can seek efficiently only when the query gives it a usable path into that sorted order.

The question is not:
```text
does the query mention these columns somewhere?
```

The question is:
```text
can the query constrain a contiguous left-to-right prefix of that tuple order?
```

## What Leftmost Prefix Really Means

For index:
```text
(hospital_id, status, scheduled_at)
```

These are strong prefix-usable query shapes:

1. Leading equality only
```sql
WHERE hospital_id = :hospital_id
```

2. Leading equality plus next equality
```sql
WHERE hospital_id = :hospital_id
  AND status = :status
```

3. Leading equalities plus range on the next column
```sql
WHERE hospital_id = :hospital_id
  AND status = :status
  AND scheduled_at >= :start_time
  AND scheduled_at < :end_time
```

These are weaker or broken shapes:

1. Missing the leading column
```sql
WHERE status = :status
```

2. Gap in the prefix
```sql
WHERE hospital_id = :hospital_id
  AND scheduled_at >= :start_time
  AND scheduled_at < :end_time
```

3. Query on only the trailing column
```sql
WHERE scheduled_at >= :start_time
```

Why case 2 is weaker:
- the engine can use the `hospital_id` prefix
- but without `status`, it cannot narrow directly into the `scheduled_at` segment inside each status group
- so it may scan all statuses for that hospital and then filter the time range

That is the key leftmost-prefix interview point:
```text
usable prefix means contiguous leading constraints with no gap
```

## Equality Before Range Intuition

Suppose the query is:
```sql
SELECT appointment_id, scheduled_at, status
FROM appointments
WHERE hospital_id = :hospital_id
  AND status = :status
  AND scheduled_at >= :start_time
  AND scheduled_at < :end_time
ORDER BY scheduled_at
FETCH FIRST 50 ROWS ONLY;
```

Best candidate index:
```text
(hospital_id, status, scheduled_at)
```

Why this order is strong:
- `hospital_id` is tenant scoping equality
- `status` is another equality that narrows the subset further
- `scheduled_at` is the range and ordering column

Expected path:
```text
seek to the first tuple matching (hospital_id, status, start_time)
-> ordered scan by scheduled_at
-> stop at end_time or 50 rows
```

This is why equality-before-range is a strong mental model:
- equality columns carve out a narrow prefix
- then the range column defines the scan window inside that prefix

Important nuance:
```text
it is an interview heuristic, not a universal law
```

You still need workload reasoning.

## Why One Nearby Query Can Break The Same Index

Now change the endpoint to:
```sql
SELECT appointment_id, scheduled_at, status
FROM appointments
WHERE hospital_id = :hospital_id
  AND scheduled_at >= :start_time
  AND scheduled_at < :end_time
ORDER BY scheduled_at
FETCH FIRST 50 ROWS ONLY;
```

This query is better matched by:
```text
(hospital_id, scheduled_at)
```

Why `(hospital_id, status, scheduled_at)` is weaker here:
- the query does not constrain `status`
- but `status` sits between `hospital_id` and `scheduled_at` in the index order
- that breaks the clean ordered scan by time within one tenant

So the subtle but important point is:
```text
one composite index does not mean "all queries involving these columns are solved"
```

The exact order decides:
- which subset can be sought directly
- which order can be scanned naturally
- which queries end up filtering after a broader scan

## Good And Bad Column-Order Reasoning

### Strong Reasoning
```text
This endpoint is always tenant-scoped.
Within a tenant, the common query is status equality plus time range ordered by time.
So I want hospital_id first, then status, then scheduled_at so I can seek through both equalities
and scan in time order inside that narrowed subset.
```

### Weak Reasoning
```text
I put status first because it is selective.
```

Why the weak answer fails:
- `status` is often low-cardinality
- many endpoints are tenant-scoped first
- leading with `status` may mix many hospitals together before tenant narrowing
- it may destroy the strongest access path for the real workload

## Failure Cases And Edge Cases

### Missing Leading Column
If the index is:
```text
(hospital_id, status, scheduled_at)
```

then this query:
```sql
WHERE status = 'CONFIRMED'
```

usually cannot use the index as a narrow seek on `status` alone.

The leading `hospital_id` grouping comes first.

### Gap In The Prefix
This query:
```sql
WHERE hospital_id = :hospital_id
  AND scheduled_at >= :start_time
```

does not fully exploit `(hospital_id, status, scheduled_at)` because `status` is missing in the middle.

### First Range Stops Further Seek Narrowing
If the index is:
```text
(hospital_id, scheduled_at, doctor_id)
```

and the query is:
```sql
WHERE hospital_id = :hospital_id
  AND scheduled_at >= :start_time
  AND scheduled_at < :end_time
  AND doctor_id = :doctor_id
```

then `doctor_id` may still be checked as a filter, but it usually cannot participate in the narrow seek after the time range already opened the scan window.

### Wrong Middle Column For ORDER BY
If the query needs:
```sql
WHERE hospital_id = :hospital_id
ORDER BY scheduled_at
```

then index:
```text
(hospital_id, status, scheduled_at)
```

is worse than:
```text
(hospital_id, scheduled_at)
```

because `status` interrupts the desired ordering path.

### Too Many "Helpful" Composite Indexes
You can end up with:
- one index for status + time
- one index for doctor + time
- one index for patient + time
- one wider covering variant for a hot endpoint

Then writes, memory pressure, and plan complexity rise quickly.

The Week 5 write-tax lesson still applies.

## What Breaks At Scale

When the hospital system grows, common failure modes are:
- too many similar composite indexes trying to satisfy every endpoint shape
- tenant skew causing one column order to be good for small tenants but poor for the largest tenant
- range scans that look fine in test data but explode for large date windows
- plan instability when the optimizer misestimates one tenant or status distribution

Strong candidate move:
```text
first classify the hot query shapes, then choose a small number of indexes that cover the real workload,
instead of adding one more composite index per endpoint request
```

## What To Log Or Measure

For this day, the production-aware answer should include:
- query p50 / p95 latency by endpoint
- rows examined vs rows returned
- whether the query is performing a narrow seek plus short scan or a broad scan plus filter
- plan stability across small and large tenants
- write latency after adding the new composite index
- index size growth if you widen the index for covering later

Strong spoken line:
```text
I would confirm that the index order produces the intended narrow seek path for the real tenant and date distributions,
not just that an index with the same columns exists on paper
```

## Interviewer Pushback Questions

1. Why does `(hospital_id, status, scheduled_at)` help one endpoint but not `WHERE hospital_id = ? AND scheduled_at BETWEEN ...` as much?
2. What exactly does leftmost prefix mean beyond the slogan?
3. Why does the first range predicate usually stop further seek narrowing?
4. When would you choose `(hospital_id, scheduled_at)` over `(hospital_id, status, scheduled_at)`?
5. Why is `put the most selective column first` an incomplete rule?
6. When would you widen the index for covering behavior, and what permanent cost would that add?

## Deliverables

By the end of `W6D1`, you should be able to do all of these without notes:

## Explain
- give a `60-90 sec` explanation for `LC 62` using `dp[r][c] = ways to reach this cell`
- give a `60-90 sec` explanation for `LC 63` including obstacle zeroing and boundary initialization nuance
- explain `LC 309` from exact state meaning, not memorized formulas
- explain leftmost prefix as contiguous usable leading constraints, not a vague slogan

## Draw Or Design
- draw the `LC 62` and `LC 63` DP tables for a small `3 x 4` example
- mark where the first-row / first-column initialization changes after an obstacle
- take one composite index and mark which query predicates form the usable prefix
- compare two candidate column orders for one ASUS-style endpoint and defend the better one

## Handle Pushback
- answer why `(hospital_id, status, scheduled_at)` and `(hospital_id, scheduled_at)` are not interchangeable
- answer why a missing middle column breaks full prefix usage
- answer why the first range predicate changes what later columns can do
- answer what metrics would prove the chosen column order is actually helping

## 收穫

- 先講清楚 state meaning，再寫 recurrence。
- base case、迴圈方向、return value 要在 coding 前確認。
- 如果是 DP 壓縮、graph traversal、或 greedy frontier，要能說出 invariant 為什麼成立。

## 遇到的問題

原始筆記沒有另外紀錄失誤點。
