---
title: "LeetCode 801: Minimum Swaps To Make Sequences Increasing"
summary: "LeetCode Problem Solving - DP with two prefix states per index"
description: "LeetCode study note from 2026-05-23"
date: 2026-05-23
tags: ["hard", "dynamic-programming"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-05-23
Source Note: `notes/day25-week5-day4-wiggle-min-swaps-index-design.md`

## Intuition

I use two DP states per index: the minimum swaps so far if I keep the current pair asis, and the minimum swaps so far if I swap the current pair. The recurrence depends on whether the current values are strictly increasi

Pattern: DP with two prefix states per index

## Approach

- **Pattern:** DP with two prefix states per index.

## Why This Fits
At each index, the important question is:
```text
is index i swapped or not swapped?
```

That decision changes what values the next index sees, so the state must explicitly track it.

## Core State / Invariant
```text
keep = minimum swaps needed up to index i if index i is not swapped
swap = minimum swaps needed up to index i if index i is swapped
```

Initialize:
```text
keep = 0
swap = 1
```

Because at index `0`:
- not swapping costs `0`
- swapping costs `1`

## Transition Logic
At each `i`, check two kinds of validity.

### Natural Order Works
```text
A[i - 1] < A[i] and B[i - 1] < B[i]
```

Then:
- if previous state was `keep`, current `keep` stays valid
- if previous state was `swap`, current `swap` stays valid with `+1` for the current swap

So:
```text
next_keep = min(next_keep, keep)
next_swap = min(next_swap, swap + 1)
```

### Cross Order Works
```text
A[i - 1] < B[i] and B[i - 1] < A[i]
```

Then:
- a previous `swap` can lead to current `keep`
- a previous `keep` can lead to current `swap`

So:
```text
next_keep = min(next_keep, swap)
next_swap = min(next_swap, keep + 1)
```

## Why This Problem Is Good For Interviews
It forces you to prove:
- what your state means
- why each transition is legal
- why the answer is not greedy on one local pair only

It is a clean test of whether you can reason from invariants instead of pattern-matching syntax.

## Complexity
```text
Time: O(n)
Space: O(1)
```

## Common Mistakes
- forgetting to reset `next_keep` and `next_swap` to infinity each round
- mixing natural-order and cross-order transitions incorrectly
- using one sequence's ordering without checking the other
- not being able to explain why the state must track swap status at index `i`

## Strong Spoken Explanation
I use two DP states per index: the minimum swaps so far if I keep the current pair as-is, and the minimum swaps so far if I swap the current pair. The recurrence depends on whether the current values are strictly increasing in natural order, cross order, or both. Natural order lets me stay in the same swap-status pattern. Cross order lets me switch between previous swap and current keep, or previous keep and current swap. Because the legality depends on whether the previous index was swapped, I have to keep that state explicitly.

## Problem 3 - Timed Re-solve: LC 309 Or LC 714
- **Pattern:** stock-state-machine maintenance.

## Why This Review Still Matters
Today’s two new problems are still state-machine DP, but neither looks like the stock series at first glance.

The timed re-solve checks that:
- you can still define states immediately
- you do not fall back into memorized formulas
- the Week 5 stock thread remains interview-safe

## Timed-Re-solve Script
Before coding, say out loud:
```text
state =
base case =
transition =
answer =
```

For `LC 309`, the must-hit line is:
```text
buy can come from rest, not from sold
```

For `LC 714`, the must-hit line is:
```text
fee changes transaction economics, not the legal state set
```

## Topic - Index Design For One ASUS-Style Query

## First Judgment
If your answer sounds like:
```text
I would add an index on the filtered columns
```

that is below Tier A/S mid-level bar.

A stronger answer must cover:
- what the endpoint is trying to do
- why this query shape wants this access path
- whether the result can stop early
- whether row lookups remain expensive
- why the read win is worth the write cost
- how you would validate the decision

## What A Strong Mid-Level Candidate Must Know
- query shape before index shape
- equality filter, range filter, sort order, and projection width
- page-read / access-path reasoning, not abstract `B+Tree is fast`
- when covering matters
- when low-selectivity predicates should not lead the index story
- why hot write tables need stricter index discipline
- why one read-optimized index may hurt inserts, updates, and reschedules
- how to verify with `EXPLAIN`, actual row counts, and latency metrics

## Canonical ASUS-Style Query

Use this as today’s main drill:

```sql
SELECT appointment_id, patient_id, status, scheduled_at
FROM appointments
WHERE hospital_id = :hospital_id
  AND doctor_id = :doctor_id
  AND scheduled_at >= :from_ts
  AND scheduled_at < :to_ts
ORDER BY scheduled_at DESC
FETCH FIRST 50 ROWS ONLY;
```

This is realistic because a hospital system often needs:
- one tenant / hospital slice
- one doctor's schedule
- one time window
- newest or nearest appointments first
- only a small first page

## First Workload Judgment
Before naming an index, decide:
- is this endpoint read-hot?
- how often are new appointments inserted?
- how often are appointments rescheduled?
- does this screen need only 50 rows or large exports too?
- is the projection narrow enough to benefit from index-only or near-index-only access?

Without workload context, your index answer is incomplete.

## Candidate Index

The default strong candidate is:

```text
B-Tree index on (hospital_id, doctor_id, scheduled_at DESC)
```

## Why This Index Fits
- `hospital_id` and `doctor_id` are equality filters:
  - they sharply narrow the search slice first
- `scheduled_at` is the range and ordering column:
  - it lets the engine walk the relevant leaf region in the desired order
- the query only wants the first `50` rows:
  - ordered access means the engine may stop early instead of scanning the full range

Interview-safe summary:
```text
This index matches the query's seek keys, the time-range predicate, and the requested sort,
so it gives me a seek plus an ordered leaf scan with early-stop potential.
```

## Expected Access Path
Conceptually:
```text
root/internal pages
-> seek to hospital_id + doctor_id slice
-> walk leaf entries in scheduled_at order
-> fetch base rows if needed
-> stop after 50 qualifying rows
```

That is a much stronger answer than:
```text
I added a composite index because there are three WHERE conditions
```

## Covering Vs Base-Table Lookup

This query projects:
- `appointment_id`
- `patient_id`
- `status`
- `scheduled_at`

If the engine can satisfy all needed columns from the index, access gets much cheaper.

If not, the likely path becomes:
```text
index seek + ordered leaf scan + repeated base-row lookup
```

That can still be good because:
- result size is only `50`
- equality filters are likely selective
- the engine can stop early

But it is still not free.

Strong answer:
```text
I would first use the narrow composite index that aligns with the filter and ordering. If row lookups still dominate and this endpoint is hot enough, I would evaluate a covering strategy supported by the engine or narrow the response shape before blindly widening the index.
```

## Why I Would Not Lead With `status`

If someone proposes:
```text
(status, hospital_id, doctor_id, scheduled_at)
```

push back first.

Reason:
- `status` is often low-selectivity
- many appointments may share the same status
- leading with a weak discriminator can make the index much less useful

This is exactly the kind of answer that separates:
- `I know indexes exist`
- from `I can reason about workload and selectivity`

## When This Index Can Still Lose

Even a reasonable index can lose if:
- the time window is very wide and the query returns a large fraction of the table slice
- the endpoint changes to `SELECT *`
- the hospital filter is weak or missing
- stale statistics make the optimizer estimate badly
- the real workload is write-heavy and read traffic is too low to justify maintenance cost

Strong interview move:
```text
name the index you want, then immediately say when you would reject your own idea
```

## Read Benefit Vs Write Tax

This table is likely write-active:
- new appointment creation
- appointment reschedule
- cancellation or status updates

Every extra index means those writes now update:
- the base row
- plus another B-Tree path

The cost is not only storage.

It can show up as:
- higher insert/update latency
- more page splits
- more buffer pressure
- more redo / write amplification
- more maintenance cost during heavy schedule changes

If `scheduled_at` changes during reschedule flows, this index is especially not free because the key itself changes.

## Strong Mid-Level Position
```text
I add this index only if the schedule-read endpoint is important enough and frequent enough
to justify the permanent write tax on appointment create/reschedule traffic.
```

## What To Check In `EXPLAIN` And Production

You should be able to say exactly what proof you want.

Check in `EXPLAIN` / plan inspection:
- is the desired index actually chosen?
- do I see range-scan or ordered index access rather than full scan?
- is the estimated row count reasonable?

Check in runtime metrics:
- rows examined vs rows returned
- logical reads / buffer gets if available
- p95 and p99 latency on this endpoint
- insert/update latency before and after the index
- index usage frequency over real workload

If plan and metrics do not improve enough, the index does not deserve to live.

## Interviewer Pushback Questions

1. Why not add `status` into the leading part of the index?
2. What if this screen later needs pagination through thousands of rows?
3. What if inserts and reschedules get slower after adding the index?
4. What if the optimizer still chooses a full scan?
5. Would you change the query shape, the endpoint response, or the index first?

## Strong Pushback Answers

### 1. Why not lead with `status`?
Because it is often much less selective than tenant and doctor. I want the index to narrow quickly into one doctor's schedule slice first, then use time order effectively.

### 2. What if pagination gets deep?
The same index can still help, but deep pagination may make offset-style access expensive. I would then revisit API/query shape, not only the index.

### 3. What if writes slow down?
I would compare the read latency gain against the write regression. If this is not a hot user-facing endpoint, I may reject the index or redesign the read path instead.

### 4. What if the optimizer still scans?
I would inspect actual selectivity, projection width, and stats freshness. The problem may be data distribution or query shape, not just missing index structure.

### 5. Query, endpoint, or index first?
Usually query/endpoint shape first, because narrowing projection or result size can reduce cost without adding permanent write overhead.

## Topic Session For Today

## Session Goal
By the end of today, you should be able to answer:
```text
For this hospital scheduling query, what index would you add, why does the access path help,
what does it cost on writes, and how would you prove it was the right decision?
```

## Block 1 - 10 Minute Recall
Say out loud without notes:
- why `SELECT *` can hurt an otherwise-good index plan
- why low-selectivity columns are dangerous as leading columns
- why ordered access plus `FETCH FIRST 50 ROWS ONLY` can be valuable
- why a good index still needs post-change validation

## Block 2 - 20 Minute Query Drill
For the canonical query, answer:
- what is the likely access path?
- where can early stop happen?
- which columns are filter vs order vs projection?
- what would make this plan degrade?

## Block 3 - 15 Minute Pushback Drill
Answer without notes:
- why not full scan?
- why not lead with `status`?
- why not add every projected column to the index?
- when would you reject the index entirely?

## Block 4 - 15 Minute Production Drill
Pretend you added the index yesterday. Answer:
- what metric improved?
- what metric might regress?
- what plan detail would make you confident?
- what signal would make you roll back the change?

## Block 5 - 10 Minute Delivery Round
Record one `90 sec` answer:
```text
I would start with a B-Tree index on hospital_id, doctor_id, and scheduled_at because the query filters by hospital and doctor, scans a time range, orders by scheduled_at, and only needs the first 50 rows. That lets the engine seek into one doctor's schedule slice and walk ordered entries instead of reading a broad part of the table. I would still watch whether projection forces extra base-row lookups, because the read benefit must justify the write tax on appointment creates and reschedules. After adding it, I would verify the chosen plan, row counts, logical reads, and both read and write latency before deciding the index is worth keeping.
```

## Deliverables

By the end of W5D4, you should be able to:
- explain `LC 376` as alternating-direction state tracking, not vague greedy intuition
- explain `LC 801` with `keep/swap` state meaning and legal transition cases
- timed re-solve `LC 309` or `LC 714` from state meaning without freezing
- propose one realistic index for one ASUS-style query and defend why it fits the access path
- explain one reason the optimizer may still choose a scan
- explain one concrete write cost of the index
- name the exact `EXPLAIN` or runtime signals you would inspect after rollout

## Short No-Notes Answer Target
If the interviewer asks:
```text
Take one real backend query and explain what index you would add and why.
```

Your answer should sound like:
```text
I would start from the query shape, not from a generic rule like indexing every filtered column. For a hospital scheduling query filtered by hospital and doctor, ordered by scheduled time, and limited to the first 50 rows, I would likely use a B-Tree index on hospital_id, doctor_id, and scheduled_at. That gives a seek into one narrow slice plus an ordered scan with early-stop potential. I would still check whether projection causes expensive row lookups and whether the endpoint is hot enough to justify the write tax on appointment inserts and reschedules. After adding it, I would verify the chosen plan, rows examined, logical reads, and both read and write latency before keeping the index.
```

## Today's Consolidated Recall

## Algorithm Recall

### `LC 376 Wiggle Subsequence`
- Problem:
  - find the maximum-length subsequence whose consecutive differences strictly alternate in sign
- Exact states:
  - `up = best wiggle length ending here with last difference positive`
  - `down = best wiggle length ending here with last difference negative`
- Transitions:
  - if `nums[i] > nums[i - 1]`, `up = down + 1`
  - if `nums[i] < nums[i - 1]`, `down = up + 1`
  - if equal, neither state changes
- Why `O(1)` space is enough:
  - for future extension, only the best length under each ending direction matters
  - any shorter subsequence with the same ending direction is dominated
- Common wording trap:
  - `up/down` are lengths under an ending direction, not the numeric difference itself

### `LC 801 Minimum Swaps To Make Sequences Increasing`
- Exact states:
  - `keep = minimum swaps needed for prefix 0..i if index i is not swapped`
  - `swap = minimum swaps needed for prefix 0..i if index i is swapped`
- Base case:
  - `keep = 0`
  - `swap = 1`
- Legality checks:
  - natural order: `A[i] > A[i - 1] and B[i] > B[i - 1]`
  - cross order: `A[i] > B[i - 1] and B[i] > A[i - 1]`
- Transitions:
  - natural:
    - `next_keep = min(next_keep, keep)`
    - `next_swap = min(next_swap, swap + 1)`
  - cross:
    - `next_keep = min(next_keep, swap)`
    - `next_swap = min(next_swap, keep + 1)`
- Why this is not greedy:
  - the choice at index `i` changes the values seen by index `i + 1`
  - a locally valid swap can block a cheaper future path
  - so the DP must remember whether the previous index was swapped

### Timed Re-solve - `LC 309 Best Time to Buy and Sell Stock with Cooldown`
- Exact states:
  - `hold = best profit ending day i while holding a stock`
  - `sold = best profit ending day i having sold today`
  - `rest = best profit ending day i with no stock and not selling today`
- Pre-day-0 base:
  - `hold = -inf`
  - `sold = -inf`
  - `rest = 0`
- Transitions:
  - `hold = max(prev_hold, prev_rest - price)`
  - `sold = prev_hold + price`
  - `rest = max(prev_rest, prev_sold)`
- Must-hit line:
  - buy can come from `rest`, not from `sold`, because the day after selling is cooldown
- Final answer:
  - `max(sold, rest)`

### Timed Re-solve - `LC 714 Best Time to Buy and Sell Stock with Transaction Fee`
- Exact states:
  - `hold = best profit ending the day while holding a stock`
  - `cash = best profit ending the day with no stock`
- Pre-day-0 base:
  - `hold = -inf`
  - `cash = 0`
- Transitions:
  - `hold = max(prev_hold, prev_cash - price)`
  - `cash = max(prev_cash, prev_hold + price - fee)`
- Must-hit line:
  - the fee changes transaction economics, not the legal state set
- Final answer:
  - `cash`

## Topic Recall
- Canonical query shape:
  - equality filters: `hospital_id`, `doctor_id`
  - range filter: `scheduled_at >= :from_ts and scheduled_at < :to_ts`
  - sort: `ORDER BY scheduled_at DESC`
  - projection: `appointment_id, patient_id, status, scheduled_at`
  - result size: first `50` rows only
- Candidate index:
  - `(hospital_id, doctor_id, scheduled_at DESC)`
- Why it fits:
  - equality filters narrow into one doctor's schedule slice first
  - `scheduled_at` handles both range filtering and ordering
  - `FETCH FIRST 50` creates early-stop value
- Expected path:
  - seek into the `(hospital_id, doctor_id)` prefix
  - scan leaf entries in `scheduled_at DESC` order
  - do base-row lookups if projection is not covered
  - stop after `50` qualifying rows
- Why it can still lose:
  - result set becomes large or pagination gets deep
  - projection becomes wide such as `SELECT *`
  - predicates are not selective enough
  - stale statistics make the optimizer estimate badly
- Concrete write tax:
  - every insert must update another B-Tree path
  - reschedules are especially expensive because `scheduled_at` is part of the key
  - page splits, buffer pressure, and redo/write amplification can rise
- What to verify after rollout:
  - optimizer actually chooses the index
  - plan shows range / ordered index access instead of a full scan
  - rows examined or logical reads go down
  - p95/p99 read latency improves
  - insert/update latency does not regress too much

## End-Of-Day Output
W5D4 answer in one line:
```text
`LC 376` tracks best wiggle length by last-difference direction, `LC 801` tracks minimum swaps by current swap status, `LC 309` adds a cooldown-specific no-stock state, `LC 714` stays at two states because fee only changes profit, and the backend topic answer starts from query shape before defending one concrete composite index plus its write tax and proof plan.
```

## Findings

- Keep the state meaning explicit before writing the transition.
- Check base cases and return value before trusting the recurrence.
- Explain why the iteration order or traversal order preserves the intended invariant.

## Encountered Problems

Captured from the learning note; no separate failure note was recorded.
