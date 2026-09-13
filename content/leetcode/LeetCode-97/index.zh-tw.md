---
title: "LeetCode 97: Interleaving String"
summary: "LeetCode 解題筆記：Interleaving String"
description: "2026-07-16 的 LeetCode 學習紀錄"
date: 2026-07-16
tags: ["medium", "dynamic-programming", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-07-16
來源筆記：`notes/day37-week7-day2-edit-distance-interleaving-isolation-levels.md`

## 解題思路

這篇整理 Interleaving String 的解題筆記，重點放在 2D DP on two prefixes with a derived third-string index、狀態定義、轉移式與容易犯錯的地方。

## 解法

以下內容整理自當天的 learning note，保留英文關鍵句，方便之後直接拿來做面試口說複習。

- **Pattern:** 2D DP on two prefixes with a derived third-string index.

## Why This Fits
The real question is:
```text
can the prefix s3[:i + j] be formed by interleaving s1[:i] and s2[:j]?
```

That gives a 2D boolean table because:
- once `i` and `j` are known
- the third prefix length is already determined

## Core State / Invariant
```text
dp[i][j] = whether s3[:i + j] can be formed by interleaving s1[:i] and s2[:j]
```

## Required Guard
Before any DP:
```text
if len(s1) + len(s2) != len(s3):
    return False
```

Reason:
```text
an interleaving must consume every character exactly once
```

## Base Case
```text
dp[0][0] = True
```

Reason:
```text
two empty prefixes can form the empty prefix of s3
```

## Transition
Let:
```text
k = i + j - 1
```

Then:
```text
dp[i][j] is true if either:
1. dp[i - 1][j] is true and s1[i - 1] == s3[k]
2. dp[i][j - 1] is true and s2[j - 1] == s3[k]
```

## Why This Works
At the last consumed position of `s3`, the character must have come from exactly one of:
- the end of the used prefix of `s1`
- the end of the used prefix of `s2`

If either smaller state is valid and the matching character fits, the current state is valid.

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
- forgetting the length guard
- using `i + j` instead of `i + j - 1` for the current character index
- treating interleaving like substring alternation instead of order-preserving merge
- failing to explain why both transitions can be true at once
- losing track of what `dp[i][j]` means when speaking

## Strong Spoken Explanation
I define `dp[i][j]` as whether the first `i + j` characters of `s3` can be formed by interleaving the first `i` characters of `s1` and the first `j` characters of `s2`. I first reject if the total lengths do not add up. The empty-empty state is true. For each cell, the last consumed character of `s3` must come either from `s1[i - 1]` or from `s2[j - 1]`, so I check whether either smaller state was already valid and that chosen source character matches the current character in `s3`. The final answer is `dp[len(s1)][len(s2)]`.

## Problem 3 - Graph Maintenance: LC 269 Or LC 787
- **Pattern:** maintenance only, not new acquisition.

## Why This Review Matters
Week 7 should improve string DP without losing graph recall from earlier weeks.

Pick one:
- `LC 269 Alien Dictionary` if topo ordering / invalid-prefix edge case is drifting
- `LC 787 Cheapest Flights Within K Stops` if layered shortest-path reasoning is drifting

## Must-Hit Spoken Lines
If `LC 269`:
```text
build edges from the first differing character between adjacent words
```

```text
if a longer word comes before its own prefix, the input is invalid
```

If `LC 787`:
```text
this is not plain Dijkstra on cost alone because the stop budget is part of the state
```

```text
the state must encode node plus remaining stops or edges used
```

## Common Failure
- treating the maintenance slot like a new deep-learning block
- losing exact wording on the one graph pattern that should already be stable

## Topic - Isolation Levels From Read Uncommitted To Serializable

## First Judgment
If your answer is only:
```text
Read Uncommitted is weakest, Read Committed is normal, Repeatable Read is stronger, Serializable is safest
```

that is below Tier A/S mid-level bar.

A stronger answer must say:
- what each level prevents
- what anomaly still survives
- one concrete business scenario where that matters
- why isolation level does **not** automatically solve:
  - duplicate API requests
  - uniqueness-rule enforcement by itself
  - stale-write protection in every engine / flow

## What A Strong Mid-Level Candidate Must Know
- isolation level controls what concurrent transactions can observe and how much they can interfere
- the classic anomaly ladder:
  - dirty read
  - non-repeatable read
  - phantom read
- lost update / stale-write races matter in interviews, but they do not map as cleanly to ANSI labels as the first three anomalies
- `Read Committed` usually prevents dirty reads, but it can still allow:
  - a row to look different on a second read
  - a query result set to change during the same transaction
  - read-check-write races unless you add locking or version checks
- `Repeatable Read` means different things across engines:
  - use the conceptual ANSI ladder in interviews
  - then mention vendor nuance if asked
- `Serializable` is the closest to `as if transactions ran one at a time`, but it can increase:
  - contention
  - abort / retry rate
  - latency under hot rows or hot ranges
- isolation level is only one tool:
  - uniqueness constraints protect invariants
  - `SELECT ... FOR UPDATE` can serialize hot-row decisions
  - optimistic version checks protect against stale writes
  - idempotency keys protect request semantics under retries

## A Practical Interview Table

| Isolation level | Dirty read | Non-repeatable read | Phantom read | Interview-safe interpretation |
| --- | --- | --- | --- | --- |
| Read Uncommitted | Allowed | Allowed | Allowed | Almost no isolation; rarely used for correctness-sensitive flows |
| Read Committed | Prevented | Can still happen | Can still happen | Common default-style answer; each read sees committed data, but repeated reads may differ |
| Repeatable Read | Prevented | Prevented conceptually | Vendor-dependent / conceptually still possible in ANSI ladder | Stable row rereads, but do not overclaim phantom behavior without engine context |
| Serializable | Prevented | Prevented | Prevented | Behavior equivalent to some serial execution order, usually with more cost |

Use this carefully:
- the table is a good interview baseline
- if pushed, mention that real engines implement isolation differently through locks or MVCC snapshots

## Concrete Hospital / Billing Scenarios

### Scenario 1 - Dirty Read
Flow:
- transaction A starts refund reversal work and temporarily writes a new balance
- transaction B reads that uncommitted value and makes a downstream decision
- transaction A then rolls back

Why it matters:
```text
transaction B made a decision from state that never truly existed
```

Interview use:
- dirty read is the easiest anomaly to explain
- do not pretend it is the main production problem in most modern OLTP systems

### Scenario 2 - Non-Repeatable Read
Flow:
- transaction A loads a patient billing row
- transaction B commits a correction to that same row
- transaction A reads the row again and sees different committed data

Why it matters:
```text
the same transaction no longer has a stable view of a row it already read
```

Interview use:
- strong example for `Read Committed` not being enough when multi-step decisions depend on stable rereads

### Scenario 3 - Phantom Read
Flow:
- transaction A queries:
  - `SELECT count(*) FROM appointments WHERE doctor_id = ? AND slot_start BETWEEN ? AND ? AND status = 'CONFIRMED'`
- it sees `0` confirmed appointments in that slot range
- transaction B inserts a newly confirmed appointment that matches the same predicate
- transaction A reruns the range query and now sees `1`

Why it matters:
```text
the transaction did not just see one existing row change;
it saw the membership of the result set change
```

Interview use:
- best example for range predicates, booking windows, and capacity checks

### Scenario 4 - Lost Update / Stale Write
Flow:
- two doctors load the same patient-note row
- each edits based on the old version
- the second commit overwrites the first without detecting staleness

Why it matters:
```text
both transactions read committed data, but the final state silently discards one user's work
```

Interview use:
- explain this separately from the classic ANSI anomaly ladder
- the repair is often:
  - version check
  - `If-Match`
  - optimistic locking
  - or explicit row locking for hot records

## Strong Answer Components
- start from one flow:
  - appointment booking
  - patient record edit
  - billing status update
- name the invariant
- map the concurrency bug to the lowest isolation level that still allows it
- explain why a stronger level helps
- then explain why you still may need:
  - unique constraint
  - version column
  - explicit locking
  - retry logic

## Failure Cases And Edge Cases
- a database may not even expose true `Read Uncommitted` in the same way as the ANSI ladder
- `Repeatable Read` is where vendor nuance matters most:
  - snapshot semantics
  - gap locks / next-key locks
  - write skew under snapshot isolation
- `Serializable` can fail by aborting one transaction, which means the app still needs:
  - retry policy
  - idempotent mutation handling
- isolation level does not prevent:
  - duplicate external charges after timeout ambiguity
  - two logically identical requests without an idempotency key
  - invariant gaps if the schema lacks the constraint

## Trade-Offs
- weaker isolation:
  - higher concurrency
  - fewer waits / aborts
  - more anomaly risk
- stronger isolation:
  - simpler reasoning about correctness
  - more blocking or more serialization failures
  - more throughput risk on hot rows or hot ranges
- explicit row locks:
  - good for scarce hot resources
  - can increase wait time and deadlock risk
- optimistic concurrency:
  - good when conflicts are rare
  - can create retry churn on hot records

## What Breaks At Scale
- appointment or inventory hotspots make contention visible fast
- range checks under heavy concurrency can trigger:
  - lock amplification
  - more serialization failures
  - tail-latency spikes
- long-running transactions increase the chance of:
  - reread drift
  - user-facing retries
  - blocked writers
- if the app treats `Serializable` as magic without retry handling, correctness logic still fails in production

## What To Log Or Measure
- lock wait time
- transaction latency by endpoint / workflow
- serialization failure count
- deadlock / timeout count
- optimistic-conflict retry rate
- duplicate-request rate vs idempotency-key hit rate
- business invariant violations:
  - double booking attempts
  - stale update conflicts
  - balance mismatch incidents

## Interviewer Pushback Questions
1. Why is `Read Committed` often not enough for appointment booking or billing flows?
2. If `Serializable` is safest, why not use it everywhere?
3. Does a stronger isolation level prevent duplicate payment API requests?
4. How is `lost update` different from dirty read or phantom read?
5. When would you choose optimistic versioning instead of `SELECT ... FOR UPDATE`?
6. How would you explain phantom read with a range query instead of a single row?

## Strong 60-90 Second Answer
I would explain isolation levels through what concurrent transactions are still allowed to observe. `Read Uncommitted` can expose uncommitted data, so it is almost never appropriate for correctness-sensitive flows. `Read Committed` prevents dirty reads, but repeated reads can still change and range queries can still see new committed rows, so multi-step booking or billing logic can still break. `Repeatable Read` gives a more stable transaction view, but exact phantom behavior depends on the engine, so I would mention vendor nuance if pushed. `Serializable` is the strongest because it makes the outcome equivalent to some serial order, but that extra safety often costs throughput and increases retries. I would also explicitly say isolation level alone is not enough: uniqueness constraints, row locks, or version checks may still be needed for correctness, and idempotency keys are still needed for duplicate API requests.

## Deliverables

By the end of W7D2, you should be able to:

- explain `LC 72` with exact source-to-target operation meaning for insert, delete, and replace
- explain `LC 97` with exact `dp[i][j]` meaning and the `i + j - 1` index
- keep one graph pattern alive without turning the maintenance slot into a new learning block
- compare `Read Uncommitted`, `Read Committed`, `Repeatable Read`, and `Serializable` in `60-90 sec`
- give one dirty-read example, one non-repeatable-read example, and one phantom-read example using realistic backend flows
- explain why `lost update` often needs versioning or explicit locking instead of isolation-level slogans
- answer one pushback on why `Serializable` is not a universal default

## 收穫

- 先講清楚 state meaning，再寫 recurrence。
- base case、迴圈方向、return value 要在 coding 前確認。
- 如果是 DP 壓縮、graph traversal、或 greedy frontier，要能說出 invariant 為什麼成立。

## 遇到的問題

原始筆記沒有另外紀錄失誤點。
