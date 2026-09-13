---
title: "LeetCode 576: Out of Boundary Paths"
summary: "LeetCode Problem Solving - DP / memoization on position plus remaining moves"
description: "LeetCode study note from 2026-07-05"
date: 2026-07-05
tags: ["leetcode", "medium", "dynamic-programming", "grid-dp"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-07-05
Source Note: `notes/day34-week6-weekend-day1-min-falling-path-sum-ii-out-of-boundary-paths-query-triage.md`

## Intuition

I model the state as (moves_left, row, col) because the number of valid ways depends on both the current position and how many moves I still have. If I step out of bounds, that contributes one successful path. If I run o

Pattern: DP / memoization on position plus remaining moves

## Approach

- **Pattern:** DP / memoization on position plus remaining moves.

## Why This Fits
The target is not a destination cell.

The real question is:
```text
how many ways can I leave the grid if I start here with k moves remaining?
```

That makes the stable state:
- current position
- moves remaining

## Core State / Invariant
For memo DFS:
```text
dp(moves_left, r, c) = number of ways to move out of the grid
starting from (r, c) with moves_left remaining
```

## Base Cases
If already out of bounds:
```text
return 1
```

Reason:
```text
this path has successfully left the grid
```

If no moves remain and still in bounds:
```text
return 0
```

## Transition
Try all four directions:
```text
up, down, left, right
```

So:
```text
dp(moves_left, r, c) =
    dp(moves_left - 1, r - 1, c) +
    dp(moves_left - 1, r + 1, c) +
    dp(moves_left - 1, r, c - 1) +
    dp(moves_left - 1, r, c + 1)
```

Take modulo at each step.

## Complexity
With memo:
```text
Time: O(maxMove * m * n)
Space: O(maxMove * m * n)
```

## Common Mistakes
- using a destination-style grid DP state
- forgetting that leaving the grid is a success state
- not memoizing and blowing up exponentially
- forgetting modulo

## Strong Spoken Explanation
I model the state as `(moves_left, row, col)` because the number of valid ways depends on both the current position and how many moves I still have. If I step out of bounds, that contributes one successful path. If I run out of moves while still inside the grid, that contributes zero. From each in-bounds state, I try the four directions and sum the number of ways from the smaller subproblems. With memoization, each `(moves_left, row, col)` state is solved once, so the complexity becomes `O(maxMove * m * n)`.

## Problem 3 - Timed 2-Problem Grid DP Set
- **Pattern:** pattern discrimination under time pressure.

## Why This Matters
By Weekend Day 1, Week 6 should no longer feel like:
```text
everything is just 2D DP somehow
```

You should be able to tell immediately:
- local square-growth DP
- fixed-predecessor path DP
- row-summary optimized DP
- position-plus-move-budget counting DP

## Timed Set Options
Use any two of:
- `LC 64`
- `LC 221`
- `LC 931`
- `LC 1277`

## Pass Standard
Before coding each problem, say:
```text
state =
base case =
transition =
answer =
```

## Topic - Query Triage Across 3 ASUS-Style Queries

## First Judgment
If your answer for all three queries is:
```text
add a composite index
```

that is below Tier A/S mid-level bar.

The real test is whether you can classify each slow query by the **type of fix** it actually needs.

## What A Strong Mid-Level Candidate Must Know
- query rewrite comes before index change when the current query is not SARGable or the projection is obviously wasteful
- index change comes before schema change when the query shape is already reasonable but the access path is poor
- schema change is justified only when the workload pattern repeatedly exceeds what query rewrite plus sane indexing can handle
- stats / cardinality quality affects whether the optimizer even trusts a good index
- write-heavy systems need stricter evidence before adding new or wider indexes

## Strong Answer Components
- state what the query is trying to achieve
- say whether the current query shape is healthy or flawed
- classify the first move:
  - query rewrite
  - index change
  - schema change
  - no change
- say what evidence would make you escalate to the next heavier fix
- mention read/write trade-off and operational cost

## Query 1 - Query Shape Problem
```sql
SELECT *
FROM appointments
WHERE TRUNC(scheduled_at) = :day
  AND hospital_id = :hid
ORDER BY created_at DESC
FETCH FIRST 100 ROWS ONLY;
```

### First Move
```text
query rewrite first
```

### Why
- `TRUNC(scheduled_at)` is a SARGability problem
- `SELECT *` may be wider than the client actually needs
- a cheaper fix may make the existing or a simpler index usable

### Better Query Shape
```sql
SELECT appointment_id, scheduled_at, status, created_at
FROM appointments
WHERE hospital_id = :hid
  AND scheduled_at >= :day_start
  AND scheduled_at < :next_day_start
ORDER BY created_at DESC
FETCH FIRST 100 ROWS ONLY;
```

### What To Measure
- latency before and after rewrite
- rows examined vs rows returned
- logical reads / buffer gets
- whether the plan shape improves before adding any index

## Query 2 - Index Shape Problem
```sql
SELECT appointment_id, scheduled_at, status
FROM appointments
WHERE hospital_id = :hid
  AND doctor_id = :did
  AND scheduled_at >= :start
  AND scheduled_at < :end
ORDER BY scheduled_at
FETCH FIRST 50 ROWS ONLY;
```

Assume:
- query is already SARGable
- projection is already narrow
- table is large
- current index is only `(hospital_id, scheduled_at)`

### First Move
```text
index change first
```

### Why
- query shape is already healthy
- access path is probably missing the `doctor_id` narrowing
- schema change would be overkill before fixing the obvious index-shape mismatch

### Candidate Index
```text
(hospital_id, doctor_id, scheduled_at)
```

Covering can be considered later only if row fetch is the proven remaining bottleneck.

### What To Measure
- plan shape before and after the new index
- rows examined vs rows returned
- latency improvement
- write overhead after adding the index

## Query 3 - Schema / Workload Mismatch
```sql
SELECT hospital_id, doctor_id, COUNT(*) AS appointment_count
FROM appointments
WHERE scheduled_at >= :month_start
  AND scheduled_at < :next_month_start
  AND status = 'COMPLETED'
GROUP BY hospital_id, doctor_id
ORDER BY appointment_count DESC;
```

Assume:
- this powers a dashboard hit frequently during the day
- the base table is large and hot for writes
- query rewrite and a reasonable index still miss latency targets

### First Move
```text
schema / workload change becomes reasonable
```

### Why
- this is trending analytical / aggregation-heavy, not point-read transactional access
- repeatedly aggregating a hot large OLTP table can remain expensive even with decent indexes
- a summary table, materialized aggregation, or reporting replica may fit the workload better

### Possible Schema-Level Fixes
- pre-aggregated summary table by day / month
- materialized view if the platform and refresh model fit
- reporting path separated from OLTP path

### What To Measure
- dashboard frequency and freshness requirement
- base-table read pressure caused by the aggregation
- write-path cost of keeping the summary structure updated
- whether latency and concurrency targets improve enough to justify the added complexity

## Failure Cases And Edge Cases
- stale stats make Query 2 look like an index failure when the real problem is plan quality
- Query 1 may still need an index after rewrite; rewrite first does not mean rewrite only
- Query 3 may not justify schema change if freshness is lax and traffic is low
- broad `OR`, low selectivity, or wide projection can make all index discussions weaker

## Trade-Offs
- query rewrite:
  - cheapest and safest first move when it restores SARGability or reduces waste
- index change:
  - good middle-layer fix when query shape is already healthy
  - permanently taxes writes
- schema change:
  - highest leverage when the workload shape truly changed
  - highest migration and operational burden

## What Breaks At Scale
- too many query-specific indexes hurt hot writes and complicate tuning
- stale stats create plan instability and bad conclusions
- summary-table or denormalized solutions add correctness and freshness maintenance cost
- teams optimize one dashboard and accidentally worsen the broader transactional system

## What To Log Or Measure
- p50 / p95 / p99 query latency
- rows examined vs rows returned
- logical reads / buffer gets
- plan shape changes after each intervention
- write latency and throughput after adding indexes or summary maintenance
- endpoint traffic frequency and freshness requirements

## Interviewer Pushback Questions
1. Why is Query 1 a query-shape problem before it is an index problem?
2. Why is Query 2 not a schema problem first?
3. When does Query 3 justify a summary table instead of one more index?
4. How do stale stats make you choose the wrong fix?
5. What evidence would make you stop after query rewrite and not add an index?

## Strong 60-90 Second Answer
I would not apply one universal fix to all three queries. Query 1 is a query-shape problem first because the predicate is not SARGable and the projection may be too wide, so I would rewrite that before adding an index. Query 2 is an index-shape problem because the query is already healthy, but the current index is missing important filtering structure, so I would try a better composite index before touching schema. Query 3 looks like a workload or schema-fit problem because it is repeated aggregation on a large hot transactional table, so after query rewrite and sane indexing fail, a summary path becomes reasonable. For each step, I would prove the fix with plan shape, rows examined versus returned, latency, and write-side impact.

## Deliverables

By the end of W6 Weekend Day 1, you should be able to:

- explain `LC 1289` with the exact state and why the min/second-min optimization is needed
- explain `LC 576` with the exact `(moves_left, row, col)` state and why leaving the grid returns `1`
- complete one timed 2-problem grid DP set without mixing pattern families
- classify three realistic backend queries into:
  - query rewrite first
  - index change first
  - schema change first
- defend each first move with concrete measurements and trade-offs

## Findings

- Keep the state meaning explicit before writing the transition.
- Check base cases and return value before trusting the recurrence.
- Explain why the iteration order or traversal order preserves the intended invariant.

## Encountered Problems

Captured from the learning note; no separate failure note was recorded.
