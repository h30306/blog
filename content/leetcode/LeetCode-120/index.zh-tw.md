---
title: "LeetCode 120: Triangle"
summary: "LeetCode 解題筆記：Triangle"
description: "2026-06-27 的 LeetCode 學習紀錄"
date: 2026-06-27
tags: ["medium", "dynamic-programming"]
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
來源筆記：`notes/day30-week6-day2-min-path-sum-triangle-oracle-plan-reading.md`

## 解題思路

這篇整理 Triangle 的解題筆記，重點放在 DP on jagged rows / in-place bottom-up accumulation、狀態定義、轉移式與容易犯錯的地方。

## 解法

以下內容整理自當天的 learning note，保留英文關鍵句，方便之後直接拿來做面試口說複習。

- **Pattern:** DP on jagged rows / in-place bottom-up accumulation.

## Why This Fits
Each position in row `r` depends only on legal parents from row `r - 1`.

The row shape is not rectangular, but the dependency is still local and acyclic, so DP fits cleanly.

## Core State / Invariant
For the in-place version:
```text
triangle[r][c] = minimum path sum to reach position (r, c) after update
```

## Edge Rules
Left edge:
```text
c == 0
```

Can only come from:
```text
triangle[r - 1][0]
```

Right edge:
```text
c == r
```

Can only come from:
```text
triangle[r - 1][c - 1]
```

Middle cells:
```text
triangle[r][c] += min(triangle[r - 1][c - 1], triangle[r - 1][c])
```

## Final Answer
After all updates:
```text
answer = min(triangle[last_row])
```

Because any position in the last row can be the endpoint of a valid top-to-bottom path.

## Complexity
```text
Time: O(total cells)
Space: O(1) extra
```

For `n` rows:
```text
Time: O(n^2)
```

## Common Mistakes
- thinking in-place update means it is not DP
- forgetting the left and right edges each have only one legal parent
- saying every cell has two parents
- giving vague complexity like `O(n * m)` when the structure is a triangle, not a rectangle

## Strong Spoken Explanation
I update the triangle in place so that each entry becomes the minimum path sum to reach that position. The left edge has only one parent directly above, the right edge has only one parent above-left, and middle cells can come from either of the two parents in the previous row. After processing all rows, the minimum answer is the minimum value in the last row.

## Problem 3 - Graph Maintenance: LC 787 Cheapest Flights Within K Stops
- **Pattern:** Dijkstra-style search with stop-budget state.

## Why This Maintenance Matters
The common failure on this problem is not code syntax.

It is incorrect pruning.

If you reduce the state to:
```text
best cost per city only
```

you can accidentally discard a path that arrives with fewer edges used and therefore preserves more remaining stop budget.

## Core State / Invariant
Heap state:
```text
(total_price, edges_used, city)
```

Important conversion:
```text
at most k stops = at most k + 1 edges
```

## Prune Logic
Skip when:
1. `edges_used > k + 1`
2. the same `city` was already popped with `<= edges_used`

## Why The Dominance Prune Is Valid
If a state for the same city was popped earlier with:
- no higher price
- and no more edges used

then the current state is dominated:
- same city
- worse or equal cost
- worse or equal remaining edge budget

So it cannot lead to a better answer later.

## Why Revisit Can Still Be Necessary
Reaching the same city later with fewer edges used may preserve enough budget to make the destination reachable within the stop limit.

## Why First Popped Valid `dst` Is Safe
The heap is ordered by total price.

So once `dst` is popped within the allowed edge limit, it is the cheapest valid reachable state to `dst`.

## Complexity
Interview-safe statement:
```text
roughly O(E log E) or O(E log V) depending on implementation details and how many states survive pruning
```

## Common Mistakes
- defining `stops` ambiguously
- forgetting that the constraint is on edges after conversion
- pruning only by city without considering edge budget
- saying `seen before` instead of proving dominance

## Strong Spoken Explanation
I use a min-heap of `(total_price, edges_used, city)`. The stop constraint translates to at most `k + 1` edges. I cannot use classic Dijkstra visited-by-city logic, because reaching the same city with fewer edges used can still be valuable even if the intermediate price is not lower. I prune a state only if it exceeds the edge limit or if the same city was already popped with fewer or equal edges used, because that earlier state dominates the current one.

## Topic - Oracle-Style Plan Reading And Spotting Full Scans

## First Judgment
If your answer is only:
```text
full scan bad, index scan good
```

that is below the bar.

A stronger mid-level answer can name the plan operators, say what each one is actually doing, and explain when the full scan is the cheaper plan.

## What A Strong Mid-Level Candidate Must Know
- `TABLE ACCESS FULL` means scan table blocks directly and filter rows
- `INDEX RANGE SCAN` means scan a contiguous key range in a B-tree index
- `TABLE ACCESS BY INDEX ROWID` means fetch actual table rows by row location after index matches are found
- an index plan is often:
  - index scan first
  - then row fetches
- the expensive part can be the row fetch fan-out, not the tree traversal itself
- full scan can win on low selectivity, small tables, or wide-result queries

## Core Operator Meanings

### TABLE ACCESS FULL
Oracle reads the table directly and checks rows against the predicate.

This is often fine when:
- a large fraction of rows is needed
- the table is small
- the query returns many columns
- index-driven row fetches would be too scattered

### INDEX RANGE SCAN
Oracle walks a contiguous range of keys inside a B-tree index.

This is not only:
```text
timestamp BETWEEN ...
```

It also covers many prefix-compatible index lookups where the usable access path maps to a continuous key range.

### TABLE ACCESS BY INDEX ROWID
After the index finds candidate entries, Oracle uses the stored `ROWID`s to fetch the actual table rows.

This is not:
```text
a second full-table search
```

It is direct row fetch by row location.

But it can still become expensive if many row fetches are scattered across the table.

## How A Typical Indexed Plan Works

Example query:
```sql
SELECT appointment_id, scheduled_at, status
FROM appointments
WHERE hospital_id = :hospital_id
  AND scheduled_at >= :start_time
  AND scheduled_at < :end_time;
```

Possible plan shape:
```text
INDEX RANGE SCAN idx_appointments_hospital_time
TABLE ACCESS BY INDEX ROWID appointments
```

What this usually means:
1. use the index to find matching key range
2. collect row locations for those matches
3. fetch the actual rows from the table blocks

The interview-safe insight is:
```text
the index narrowed the search, but the final read cost may still be dominated by table-row fetches
```

## When TABLE ACCESS FULL Can Be Cheaper

### Low Selectivity
If the predicate matches a large fraction of rows, the index does not narrow much.

Example:
```sql
scheduled_at >= '1970-01-01'
AND scheduled_at < '2026-01-01'
```

for a table that mostly lives in that range.

Then the engine may still need to fetch a huge number of rows from the table.

### Scattered ROWID Fetches
If matching rows live across many table blocks, the `TABLE ACCESS BY INDEX ROWID` step can become expensive due to many scattered reads.

A sequential full scan may be cheaper than many scattered fetches.

### Small Table
If the table is small, the planning overhead and row-fetch indirection of the index path may not be worth it.

### Many Rows Or Many Columns Needed
If the query needs many rows or a wide row shape, going through the index first may add indirection without enough selectivity benefit.

## Good Interview Explanation

If I see:
```text
INDEX RANGE SCAN
TABLE ACCESS BY INDEX ROWID
```

I read that as: Oracle is using the index to narrow candidate row locations, then fetching the real table rows by `ROWID`. That is good when the predicate is selective enough that the follow-up row fetch count stays small. If the predicate is broad, the table is small, or the row fetches are too scattered, `TABLE ACCESS FULL` can be cheaper because one sequential pass beats many random row reads.

## Failure Cases And Edge Cases

### Misreading TABLE ACCESS BY INDEX ROWID
Do not describe it as a full table scan after the index.

That is wrong.

It is targeted row fetch by row location.

### Oversimplifying INDEX RANGE SCAN
Do not define it only by timestamp or `BETWEEN`.

The real idea is contiguous key-range traversal in B-tree order.

### Treating Full Scan As Failure
Do not assume `TABLE ACCESS FULL` means the optimizer is broken.

Sometimes it is the right plan.

### Ignoring Projection Width
Even with a decent predicate, index plan benefits may disappear if the query needs a lot of columns and every match still triggers expensive table fetches.

## What To Log Or Measure

For production-aware discussion, mention:
- rows examined vs rows returned
- query latency by percentile
- whether the plan is stable across small and large tenants
- how many rows the predicate actually matches
- whether the index path causes many row fetches with poor locality

Strong spoken line:
```text
I would not stop at seeing an index range scan in EXPLAIN; I would verify whether the follow-up row fetch cost is still low enough that the index plan beats a full scan on real data
```

## Interviewer Pushback Questions

1. What does `TABLE ACCESS BY INDEX ROWID` actually do?
2. Why can `TABLE ACCESS FULL` still be the cheapest plan?
3. What is the practical difference between `INDEX RANGE SCAN` and `TABLE ACCESS BY INDEX ROWID`?
4. Why can an index plan be slow even if the index predicate looks reasonable?
5. Why is `INDEX RANGE SCAN` not limited to timestamp-range queries?

## Deliverables

By the end of `W6D2`, you should be able to do all of these without notes:

## Explain
- give a `60-90 sec` explanation for `LC 64` with correct boundary initialization
- explain `LC 120` as in-place DP with exact state meaning after overwrite
- explain `LC 787` using heap state plus dominance pruning
- explain `TABLE ACCESS FULL`, `INDEX RANGE SCAN`, and `TABLE ACCESS BY INDEX ROWID` in practical terms

## Draw Or Design
- draw the `LC 64` DP table for a small `3 x 3` weighted grid
- walk the edge cases for `LC 120` left edge, right edge, and middle cells
- trace one `LC 787` heap progression and show why one revisit is necessary
- take one Oracle-style two-step index plan and explain the table-row fetch stage

## Handle Pushback
- answer why `LC 64` is not just "same as Unique Paths"
- answer why in-place update in `LC 120` is still DP
- answer why city-only visited pruning is wrong in `LC 787`
- answer when `TABLE ACCESS FULL` is better than `INDEX RANGE SCAN` plus `TABLE ACCESS BY INDEX ROWID`

## 收穫

- 先講清楚 state meaning，再寫 recurrence。
- base case、迴圈方向、return value 要在 coding 前確認。
- 如果是 DP 壓縮、graph traversal、或 greedy frontier，要能說出 invariant 為什麼成立。

## 遇到的問題

原始筆記沒有另外紀錄失誤點。
