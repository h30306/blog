---
title: "LeetCode 1277: Count Square Submatrices With All Ones"
summary: "LeetCode Problem Solving - 2D DP on square geometry with count aggregation"
description: "LeetCode study note from 2026-07-04"
date: 2026-07-04
tags: ["medium", "dynamic-programming", "grid-dp"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-07-04
Source Note: `notes/day32-week6-day4-min-falling-path-sum-count-squares-query-vs-index-vs-schema.md`

## Intuition

I reuse the same DP state as LC 221: dp[r][c] is the side length of the largest all1 square ending at (r, c). The recurrence stays the same because square growth still depends on top, left, and diagonal. The difference i

Pattern: 2D DP on square geometry with count aggregation

## Approach

- **Pattern:** 2D DP on square geometry with count aggregation.

## Why This Fits
This is the same local square-growth logic as `LC 221`, but the question changed from:
```text
what is the largest square?
```

to:
```text
how many all-1 squares exist in total?
```

So the state can stay almost the same, but the final aggregation changes.

## Core State / Invariant
```text
dp[r][c] = side length of the largest all-1 square whose bottom-right corner is (r, c)
```

## Transition
If `matrix[r][c] == 0`:
```text
dp[r][c] = 0
```

If `matrix[r][c] == 1` and not on the first row or first column:
```text
dp[r][c] = 1 + min(dp[r - 1][c], dp[r][c - 1], dp[r - 1][c - 1])
```

Boundary `1` cells contribute:
```text
dp[r][c] = 1
```

## Why Summing DP Works
If `dp[r][c] = k`, then that cell is the bottom-right corner of:
- one `1 x 1` square
- one `2 x 2` square
- ...
- one `k x k` square

So each `dp[r][c]` contributes exactly `k` valid squares to the final count.

## Final Answer
```text
answer = sum(dp[r][c] for all cells)
```

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
- reusing the `LC 221` state but still returning only the max
- forgetting that each side length contributes multiple squares
- using `max(...)` instead of `min(...)`
- not being able to explain why summing side lengths is valid

## Strong Spoken Explanation
I reuse the same DP state as `LC 221`: `dp[r][c]` is the side length of the largest all-1 square ending at `(r, c)`. The recurrence stays the same because square growth still depends on top, left, and diagonal. The difference is the output: if a cell has largest side length `k`, it contributes `k` different valid squares ending there, so I sum all DP values instead of tracking only the maximum.

## Problem 3 - Timed Re-solve: One Stock Problem
- **Pattern:** state-machine DP maintenance.

## Why This Review Matters
Week 6 is heavy on 2D DP, but Week 5 state-machine reasoning should stay interview-safe.

Use one of:
- `LC 309`
- `LC 714`
- `LC 122`

## Pass Standard
Before coding, say:
```text
state =
base case =
transition =
final answer =
```

## Must-Hit Spoken Lines
For `LC 309`:
```text
buy can come from rest, not sold
```

For `LC 714`:
```text
the fee changes transaction economics, not the legal state set
```

For `LC 122`:
```text
each state is the best profit under an exact holding condition
```

## Topic - Query Vs Index Vs Schema - What Should Change First?

## First Judgment
If your answer starts with:
```text
I would add an index on the WHERE columns
```

that is below Tier A/S mid-level bar.

A stronger answer must first ask:
- is the query shape already index-friendly?
- is the projection wider than the endpoint really needs?
- is the current index shape actually wrong, or is the data distribution the issue?
- are stats stale or cardinality assumptions wrong?
- would a schema change solve a repeated query-pattern problem more cleanly than one more index?

## What A Strong Mid-Level Candidate Must Know
- query shape vs index shape vs schema shape is a trade-off, not a one-step rule
- SARGability comes before index design:
  - if the predicate blocks efficient index usage, adding a new index may not fix the real problem
- stale stats or bad cardinality estimates can cause rational indexes to be ignored
- endpoint contract and projection width matter:
  - returning fewer columns can be cheaper than widening an index
- schema changes are heavier:
  - denormalization, derived columns, summary tables, or partitioning can help, but only when query/index tuning is not enough
- write-heavy tables require stronger proof before adding or widening indexes

## Strong Answer Components
- start with one concrete query and endpoint goal
- classify the problem:
  - bad query shape
  - bad index shape
  - bad stats / wrong plan choice
  - bad schema fit for workload
- say the cheapest safe fix you would try first
- say what evidence would make you escalate from query rewrite to index change or from index change to schema change
- include read/write trade-off and operational cost

## Concrete ASUS / Hospital Example
Suppose the current query is:
```sql
SELECT *
FROM appointments
WHERE TRUNC(scheduled_at) = :day
  AND hospital_id = :hid
ORDER BY created_at DESC
FETCH FIRST 100 ROWS ONLY;
```

## Step 1 - First Judgment
This is **not** a good first candidate for:
```text
just add an index and move on
```

Why:
- `SELECT *` makes covering much less attractive
- `TRUNC(scheduled_at)` may block clean index usage on the raw timestamp column
- filter column and ordering column are not obviously aligned yet

## Step 2 - What Should Change First?
First move:
```text
rewrite the query shape if possible
```

For example:
```sql
WHERE scheduled_at >= :day_start
  AND scheduled_at < :next_day
  AND hospital_id = :hid
```

Why this should come first:
- it restores SARGable range filtering on `scheduled_at`
- it may let an existing or simpler composite index work
- it is cheaper and safer than adding a new wide index immediately

## Step 3 - If Query Rewrite Is Not Enough
Then consider an index like:
```text
(hospital_id, scheduled_at, created_at)
```

Reasoning:
- equality first on `hospital_id`
- range on `scheduled_at`
- `created_at` may help if the access path and ordering requirements align well enough

But do **not** claim it is automatically perfect:
- the range on `scheduled_at` can limit later ordering usefulness
- if the endpoint still returns wide rows, base-row fetch may dominate anyway

## Step 4 - When Schema Change Becomes Reasonable
Schema change is a later move, not the default first move.

It becomes more reasonable when:
- the same access pattern is mission-critical and repeatedly expensive
- query rewrite plus a reasonable index still miss the latency goal
- the workload naturally wants a derived day bucket, summary table, or partition pruning strategy
- the operational cost of one more index or repeated row fetch is still too high

Examples:
- derived `scheduled_date` column if day-based filtering is extremely common
- summary / reporting table if the endpoint is analytical rather than transactional
- partitioning by date / tenant only if the workload and maintenance model truly justify it

## Failure Cases And Edge Cases
- query uses a function on the indexed column, so index design discussion starts from the wrong layer
- broad `OR` or low-selectivity predicates make index usage weak no matter what
- stale stats make the optimizer pick a scan even though the index shape is reasonable
- endpoint asks for far more columns than the client really needs
- one team adds endpoint-specific indexes without considering total write tax

## Trade-Offs
- query rewrite:
  - lowest-risk first move if it restores SARGability or reduces projection width
  - may require application changes and contract clarity
- index change:
  - cheaper than schema redesign
  - helps only if the query shape and workload justify it
- schema change:
  - highest leverage when the data model is the real mismatch
  - highest migration, correctness, and operational cost

## What Breaks At Scale
- piling on many special-purpose indexes makes hot writes slower and more fragile
- stale stats create plan instability and misleading root-cause analysis
- denormalized or derived schema fixes add consistency-maintenance burden
- teams optimize one query locally while hurting the broader workload

## What To Log Or Measure
- query p50 / p95 / p99 latency
- rows examined vs rows returned
- logical reads / buffer gets
- plan shape before and after query rewrite
- write latency impact after adding an index
- frequency of the endpoint and traffic mix relative to writes
- cardinality estimate quality if visible in your tooling

## Interviewer Pushback Questions
1. Why would you change the query before changing the index?
2. When does `SELECT *` change your indexing strategy?
3. How do stale stats make a good index look useless?
4. When is schema change justified instead of just one more index?
5. How would you prove the first fix was enough before escalating?

## Strong 60-90 Second Answer
I would not jump straight to adding an index. First I would check whether the query shape is even index-friendly, especially whether the predicate is SARGable and whether the endpoint is returning more columns than it really needs. If the query uses something like `TRUNC(column)` or `SELECT *`, I would usually try a query rewrite or projection reduction first because that is cheaper and may let a simpler existing index work. If the query shape is already reasonable but the access path is still weak, then I would consider an index change and weigh it against write cost. I would only move to schema change when the same workload pattern is important enough that query and index tuning are still not enough. I would prove each step with plan shape, rows examined versus returned, logical reads, latency, and write impact.

## Deliverables

By the end of W6D4, you should be able to:

- explain `LC 931` with the exact state, legal predecessor set, and why the answer is the min of the last row
- explain `LC 1277` using the same local square state as `LC 221`, but with `sum(dp)` as the final aggregation
- timed re-solve one stock problem with exact state wording
- take one ASUS-style query and say whether query, index, schema, or nothing should change first
- defend one case where query rewrite is better than index addition
- defend one case where schema change is justified only after cheaper fixes fail

## Findings

- Keep the state meaning explicit before writing the transition.
- Check base cases and return value before trusting the recurrence.
- Explain why the iteration order or traversal order preserves the intended invariant.

## Encountered Problems

Captured from the learning note; no separate failure note was recorded.
