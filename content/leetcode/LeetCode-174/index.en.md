---
title: "LeetCode 174: Dungeon Game"
summary: "LeetCode Problem Solving - reverse 2D DP with minimum required resource"
description: "LeetCode study note from 2026-06-30"
date: 2026-06-30
tags: ["leetcode", "hard", "dynamic-programming", "grid-dp"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-06-30
Source Note: `notes/day31-week6-day3-maximal-square-dungeon-game-covering-index-full-scan.md`

## Intuition

I solve this backward because the meaningful state is the minimum health required when entering a cell so that I can still reach the princess alive. From each cell, I only care about the cheaper of the two required next

Pattern: reverse 2D DP with minimum required resource

## Approach

- **Pattern:** reverse 2D DP with minimum required resource.

## Why This Fits
Forward DP feels tempting but usually creates the wrong state question.

The real requirement is not:
```text
what is the best health after arriving here?
```

It is:
```text
what minimum health must I have when entering this cell so that I can still survive to the goal?
```

That naturally points backward from the destination.

## Core State / Invariant
```text
dp[r][c] = minimum health required upon entering cell (r, c) to guarantee survival through the destination
```

This is the interview-safe state because it encodes the safety guarantee directly.

## Transition
Let the cheaper required next state be:
```text
need_next = min(dp[r + 1][c], dp[r][c + 1])
```

Then:
```text
dp[r][c] = max(1, need_next - dungeon[r][c])
```

Why:
- if the current cell gives health, required entry health can drop
- if the current cell deals damage, required entry health rises
- health can never be below `1`

## Base Case
At the destination:
```text
dp[last_row][last_col] = max(1, 1 - dungeon[last_row][last_col])
```

Reason:
- after processing the last cell, the knight must still have at least `1` health

## Complexity
```text
Time: O(m * n)
Space: O(m * n)
```

Can be compressed to:
```text
Space: O(n)
```

## Common Mistakes
- trying to maximize remaining health instead of minimizing required entry health
- doing forward DP with an unstable state
- forgetting the clamp to `1`
- using `max(down, right)` instead of `min(down, right)` for the required next state
- getting the destination base case wrong

## Strong Spoken Explanation
I solve this backward because the meaningful state is the minimum health required when entering a cell so that I can still reach the princess alive. From each cell, I only care about the cheaper of the two required next states, right or down. Then I subtract the current cell value because healing reduces the needed entry health and damage increases it. Finally I clamp the result to at least `1`, because the knight can never be dead or at zero health.

## Problem 3 - Timed Re-solve: LC 63 Or LC 64
- **Pattern:** Week 6 table-discipline maintenance.

## Why This Review Matters
`LC 221` and `LC 174` are both 2D DP, but they are not the same recurrence family as the earlier grid problems.

The timed review checks that you still:
- define state before recurrence
- handle boundaries deliberately
- separate counting DP from optimization DP
- do not mix illegal directions into the transition

## Must-Hit Spoken Lines
For `LC 63`:
```text
once an obstacle blocks the first row or first column, the rest of that boundary is unreachable from that direction
```

For `LC 64`:
```text
the state is minimum path sum to reach this cell, so the boundary is accumulated cost, not all ones
```

## Pass Standard
Before coding, say:
```text
state =
base case =
transition =
return value =
```

## Topic - Covering Index, Index-Only Access, And When Full Scan Is Still Acceptable

## First Judgment
If your answer is only:
```text
covering index means the query reads from the index only, so it is faster
```

that is still below Tier A/S mid-level bar.

A stronger answer must explain:
- which columns are used for filtering
- which columns are used for ordering
- which columns are returned
- whether the plan can avoid base-row fetches
- how many rows will likely match
- whether the extra index width is worth the permanent write cost

## What A Strong Mid-Level Candidate Must Know
- a plan is only truly index-only if all needed columns can be satisfied from the index path
- avoiding `TABLE ACCESS BY INDEX ROWID` matters most when many matched rows would otherwise trigger scattered row fetches
- covering is most valuable for:
  - hot narrow endpoints
  - read-heavy workloads
  - ordered top-N queries
- covering is much less attractive when:
  - the query returns wide rows or `SELECT *`
  - the table is write-heavy
  - selectivity is weak and a large fraction of the table is needed anyway
- a full scan is not automatically bad when:
  - the table is small
  - the predicate is low-selectivity
  - most rows are needed
  - the covering index would be too wide or still not solve the true bottleneck
- Oracle-style reasoning should connect:
  - `INDEX RANGE SCAN`
  - `INDEX FAST FULL SCAN` when relevant
  - `TABLE ACCESS BY INDEX ROWID`
  - `TABLE ACCESS FULL`

## Strong Answer Components
- start with one concrete endpoint and query shape
- say whether the current index already narrows well
- say whether the expensive step is the index scan itself or the subsequent row fetches
- say whether adding returned columns to the index would remove that expensive step
- say what write penalty and storage growth you are accepting
- say what proof you want from `EXPLAIN` and from production metrics

## Concrete ASUS / Hospital Example
Suppose the endpoint is:
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

Start with the narrow candidate:
```text
(hospital_id, doctor_id, scheduled_at)
```

Why start here:
- it matches the equality filters first
- it supports the time-range scan and ordered read
- it is cheaper on writes and storage than jumping straight to a wider covering index

If this endpoint is genuinely hot and the real remaining bottleneck is base-row fetch after the index match, then a wider covering candidate is:
```text
(hospital_id, doctor_id, scheduled_at, status, appointment_id)
```

Reasoning:
- `hospital_id` and `doctor_id` are equality filters
- `scheduled_at` supports the range and ordered scan
- `status` and `appointment_id` may allow the endpoint to be satisfied from the index alone
- for a hot read path returning only `50` narrow rows, avoiding base-row fetches can be a real win

But the same index may be a bad idea if:
- appointments are updated very frequently
- the endpoint later becomes `SELECT *`
- another existing index already serves the hot path well enough

## Failure Cases And Edge Cases
- query returns one extra non-indexed column, so row fetches still happen
- low-selectivity filter causes the index plan to touch a large fraction of rows anyway
- `ORDER BY` does not align with the usable index order, so sort cost reappears
- a function or expression on the indexed column makes the access path non-SARGable
- pagination endpoint evolves and now needs wider projection than the original index covers

## Trade-Offs
- wider covering index:
  - better narrow read latency
  - worse insert/update/delete cost
  - more storage and cache pressure
- narrower non-covering index:
  - cheaper writes
  - may still require many scattered row fetches
- full scan:
  - can be cheaper when the query needs many rows or most pages anyway
  - can be the right plan for analytics-style or low-selectivity access

## What Breaks At Scale
- too many overlapping covering indexes turn every write into index-maintenance work
- index bloat reduces cache effectiveness
- write p95 rises because hot tables now update multiple wide indexes
- teams start adding endpoint-specific indexes without workload discipline

## What To Log Or Measure
- query p50 / p95 / p99 latency
- rows examined vs rows returned
- logical reads / buffer gets
- percent of executions using `TABLE ACCESS BY INDEX ROWID`
- insert/update/delete latency after adding the index
- index size growth and usage frequency

## Interviewer Pushback Questions
1. When does a covering index help materially, and when is it mostly noise?
2. Why might the optimizer still choose a full scan even though the index covers the query?
3. Would you widen the index, narrow the query projection, or change the endpoint contract first?
4. What if the endpoint is hot for reads but the table is also hot for writes?
5. How would you prove that row-fetch elimination, not something else, was the real win?

## Strong 60-90 Second Answer
A covering index matters when the expensive part of the current plan is not finding matching index entries but fetching many base rows afterward. I would usually start with the narrow composite index that matches the equality filters and ordered range scan, then widen it only if the endpoint is hot and row-fetch elimination is the real win. If the filter, order, and returned columns can all be satisfied from one composite index, the engine may avoid `TABLE ACCESS BY INDEX ROWID`, which is especially useful for narrow, read-heavy, top-N endpoints. But I would not widen indexes blindly. If the query is low-selectivity, returns wide rows, or the table is write-heavy, a full scan or a narrower index can still be the better overall choice. I would confirm with plan shape, rows examined vs returned, logical reads, and write-latency impact after the change.

## Deliverables

By the end of W6D3, you should be able to:

- explain `LC 221` with the exact state, why the diagonal matters, and why the recurrence uses `min`
- explain `LC 174` with reverse DP and the `minimum required health on entry` state
- timed re-solve `LC 63` or `LC 64` without boundary mistakes
- explain one ASUS-style query where covering index is worth it
- explain one case where a full scan is still rational even if an index exists
- answer whether you would change the index, the query projection, or neither, and defend the trade-off

## Findings

- Keep the state meaning explicit before writing the transition.
- Check base cases and return value before trusting the recurrence.
- Explain why the iteration order or traversal order preserves the intended invariant.

## Encountered Problems

Captured from the learning note; no separate failure note was recorded.
