---
title: "LeetCode 1312: Minimum Insertion Steps to Make a String Palindrome"
summary: "LeetCode Problem Solving - interval DP on substrings with minimum repair cost"
description: "LeetCode study note from 2026-07-21"
date: 2026-07-21
tags: ["leetcode", "hard", "dynamic-programming", "string", "palindrome"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-07-21
Source Note: `notes/day39-week7-day4-ascii-delete-palindrome-deadlock-write-skew-oracle.md`

## Intuition

I define dp[left][right] as the minimum insertions needed to make s[left:right+1] a palindrome. A single character needs zero insertions. If the two ends already match, I do not need a new insertion at the boundary and I

Pattern: interval DP on substrings with minimum repair cost

## Approach

- **Pattern:** interval DP on substrings with minimum repair cost.

## Why This Fits
The real question is:
```text
what is the minimum number of insertions needed
to make s[left:right+1] a palindrome?
```

That is an interval question because:
- the problem is about both ends of one substring
- each decision shrinks the interval

## Core State / Invariant
```text
dp[left][right] = minimum insertions needed to make s[left:right+1] a palindrome
```

## Base Cases
Single character:
```text
dp[i][i] = 0
```

Reason:
```text
a single character is already a palindrome
```

Empty interval can be treated as:
```text
0
```

## Transition
If the ends already match:
```text
s[left] == s[right]
=> dp[left][right] = dp[left + 1][right - 1]
```

If they do not match:
```text
dp[left][right] = 1 + min(
    dp[left + 1][right],
    dp[left][right - 1]
)
```

## Why This Works
If the ends match:
- no new insertion is needed at the boundary
- just repair the inner interval

If the ends do not match:
- one insertion is needed now
- either insert a copy of `s[left]` near the right side
- or insert a copy of `s[right]` near the left side

Then solve the remaining smaller interval.

## Fill Order
Solve shorter intervals first, usually by:
- increasing interval length
- or moving `left` backward while `right` moves forward

## Alternative View Through LPS
You can also say:
```text
answer = len(s) - LPS(s)
```

Reason:
```text
the longest palindromic subsequence is what you keep;
all missing mirrored characters must be inserted
```

Interview-safe rule:
- direct interval DP is the stronger Day 4 answer
- `n - LPS` is a good pattern-transfer remark if asked

## Complexity
```text
Time: O(n^2)
Space: O(n^2)
```

## Common Mistakes
- using substring-removal wording instead of insertion wording
- saying mismatch is `1 + dp[left + 1][right - 1]`
- forgetting that matching ends need no extra insertion
- using prefix DP when the real dependency is on an interval
- being unable to explain what the insertion is actually mirroring

## Strong Spoken Explanation
I define `dp[left][right]` as the minimum insertions needed to make `s[left:right+1]` a palindrome. A single character needs zero insertions. If the two ends already match, I do not need a new insertion at the boundary and I just solve the inner interval. If they do not match, I must insert one mirrored character, so I choose the cheaper of repairing `s[left+1:right+1]` or `s[left:right]` and add one. I fill shorter intervals first and the final answer is `dp[0][n - 1]`.

## Problem 3 - Timed Re-solve: LC 72 Or LC 97
- **Pattern:** timed recall only, not new acquisition.

## Why This Review Matters
Week 7 Day 4 should end with at least one earlier table stable under mild time pressure.

Pick one:
- `LC 72` if source-to-target operation wording is still shaky
- `LC 97` if third-string index drift is still happening

## Pass Standard
Before coding, say:
```text
state =
base case =
transition =
why this recurrence matches the problem =
final answer =
```

## Must-Hit Lines
If `LC 72`:
```text
dp[i][j] = minimum edits to convert word1[:i] into word2[:j]
```

```text
delete = dp[i - 1][j]
insert = dp[i][j - 1]
replace = dp[i - 1][j - 1]
```

If `LC 97`:
```text
dp[i][j] = whether s3[:i + j] can be formed by interleaving s1[:i] and s2[:j]
```

```text
current s3 index = i + j - 1
```

## Common Failure
- getting the recurrence right but the English meaning wrong
- solving too slowly because the table meaning was not stated first
- mixing `LC 72` and `LC 583`
- forgetting the length guard in `LC 97`

## Time Bar
- `LC 72`: table setup and recurrence defense in about `8-10` minutes
- `LC 97`: table setup and correctness defense in about `8-10` minutes

## Topic - Deadlocks, Retry Behavior, Write Skew, And Oracle Isolation Wording

## First Judgment
If your answer is only:
```text
deadlock is circular wait,
write skew is some serializable problem,
Oracle default is Read Committed,
and I would retry if the DB fails
```

that is below Tier A/S mid-level bar.

A stronger answer must say:
- what exact invariant is at risk
- whether the failure is:
  - lock wait
  - deadlock
  - serialization abort
  - optimistic conflict
  - uniqueness violation
- whether a retry is:
  - safe automatically
  - safe only before external side effects
  - unsafe and should return conflict instead
- how Oracle's wording changes the answer compared with generic ANSI-ladder talk

## What A Strong Mid-Level Candidate Must Know
- deadlock:
  - a wait cycle between transactions
  - not just a slow lock wait
  - local code can look reasonable while the combined lock order is inconsistent
- deadlock prevention:
  - consistent lock order across code paths
  - short transactions
  - narrow lock scope
  - selective predicates backed by the right indexes
- retry behavior:
  - database deadlock aborts and serialization aborts are often transient
  - full transaction retry can be safe if:
    - the operation is idempotent
    - no irreversible external side effect already escaped
    - retry budget is bounded
    - jitter / backoff is applied when contention is high
  - do **not** blindly retry:
    - stale-write conflicts that should surface to the user
    - unique-constraint violations that indicate a real business conflict
    - flows where payment, email, or external partner side effects may already have happened
- write skew:
  - the invariant is over a set of rows
  - each transaction reads a shared predicate or shared set state
  - each then writes different rows
  - no single row conflict is guaranteed
  - both commits can succeed and still violate the business rule
- range-invariant / predicate bugs:
  - `count(*) then INSERT` is still unsafe under weaker isolation or snapshot-style reads
  - the fix is often:
    - lock an owning capacity row
    - redesign the model around a single owned record
    - or use `SERIALIZABLE` with retry handling
- Oracle interview-safe wording:
  - default transaction behavior is `READ COMMITTED`
  - each query sees committed data as of that query's start time
  - this gives statement-level read consistency
  - `SERIALIZABLE` is closer to transaction-level consistency from the transaction start snapshot
  - Oracle may abort a serializable transaction with `ORA-08177`
  - that abort is a correctness-preserving signal, not a bug in the database
  - Oracle discussion usually centers on:
    - `READ COMMITTED`
    - `SERIALIZABLE`
    - `READ ONLY`
  - do not casually claim Oracle exposes a normal `REPEATABLE READ` default knob like every engine does

## Deadlock Vs Other Failure Modes

| Failure mode | What happened | Typical app response | Should you auto-retry? |
| --- | --- | --- | --- |
| Lock wait | transaction is blocked, but no cycle yet | wait, timeout, maybe surface latency | not by itself |
| Deadlock victim | DB aborts one transaction to break wait cycle | restart full transaction if safe | yes, if idempotent and side effects not escaped |
| Serialization abort | DB rejects the schedule as not serializable | restart full transaction if safe | yes, bounded retry |
| Optimistic version conflict | stale client tried to overwrite newer state | return conflict / latest version | usually no blind auto-retry |
| Unique-constraint violation | schema-backed invariant was violated | return duplicate / conflict semantic | usually no blind auto-retry |

## Concrete Scenarios

### Scenario 1 - Deadlock In Appointment And Billing Flow
Flow:
- transaction A locks appointment row first
- then it updates billing row
- transaction B locks billing row first
- then it updates appointment row

Now:
- A waits on billing
- B waits on appointment

That is a deadlock because:
```text
each transaction is waiting for a lock held by the other,
so neither can make progress
```

Best answer:
- standardize lock order everywhere
- keep the transaction short
- make sure lookup predicates are indexed so the engine does not touch extra rows
- if the DB aborts one transaction, retry the full unit of work only if it is safe

### Scenario 2 - Write Skew On On-Call Doctor Coverage
Invariant:
```text
at least one doctor must remain on call for the ICU night shift
```

Flow:
- doctor A's transaction reads that doctors A and B are both on call
- doctor B's transaction reads the same thing
- transaction A updates row A to `off_call`
- transaction B updates row B to `off_call`
- each transaction modified a different row

Why this is dangerous:
```text
there may be no direct row-write conflict,
but the set-level invariant is now broken:
zero doctors remain on call
```

Why this matters in interviews:
- it is the cleanest example of:
  - invariant lives on a set
  - disjoint writes can still break correctness
  - snapshot-style reading is not enough

Safer fixes:
- lock one owning shift row before changing membership
- keep a remaining-on-call counter on that owner row and update it transactionally
- or use `SERIALIZABLE` and retry if the DB aborts one transaction

### Scenario 3 - Capacity Check With Insert
Flow:
- transaction A runs:
  - `SELECT count(*) ... WHERE slot = X AND status = 'CONFIRMED'`
- transaction B runs the same check
- both see room
- both insert

Why this is not just `phantom read vocabulary`:
```text
the core issue is that the business invariant is not protected
by one shared row that all transactions must serialize on
```

Safer fixes:
- lock an owning capacity row
- enforce one-slot uniqueness if that is the real rule
- or use `SERIALIZABLE` with retry handling

### Scenario 4 - Oracle Serializable Abort
Flow:
- transaction starts in Oracle `SERIALIZABLE`
- it reads a consistent transaction snapshot
- concurrent committed work changes rows that make the transaction's writes no longer serializable
- Oracle aborts with `ORA-08177`

Interview-safe meaning:
```text
the database rejected the transaction to preserve serializable semantics
```

Good app behavior:
- rollback the whole transaction
- retry the whole transaction only if safe
- use bounded retries with backoff
- surface a recoverable error if the retry budget is exhausted

## Safe Retry Decision Rule
A good short rule is:
```text
retry the full transaction for transient database-abort classes
only when the operation is idempotent and no irreversible side effect escaped the transaction boundary
```

That means:
- safe retry candidates:
  - deadlock victim
  - serialization abort
  - short transient lock-timeout style failure in an internal DB-only workflow
- unsafe or not-default retry candidates:
  - user-edit stale version conflict
  - schema uniqueness conflict that represents a real business rule violation
  - external payment call already succeeded but local commit result is ambiguous

## Strong Answer Components
- start from the invariant
- name the exact failure class
- say whether the DB:
  - blocked
  - aborted
  - allowed both commits
- say the first prevention tool:
  - consistent lock order
  - owner-row lock
  - optimistic versioning
  - unique constraint
  - Serializable
- then say the app behavior:
  - bounded retry
  - return conflict
  - reconcile with latest state
  - rely on idempotency key

## Failure Cases And Edge Cases
- retrying only the last SQL statement instead of the full transaction can corrupt business logic
- retrying after an external side effect can duplicate work outside the DB
- a missing index on the locking predicate can widen lock scope and make deadlocks more likely
- write skew may happen even when no deadlock and no obvious duplicate row exist
- `READ COMMITTED` plus row locks may still be enough if you redesign around an owner row
- `SERIALIZABLE` can preserve correctness but increase abort churn under hotspots
- deadlock frequency is often a code-path consistency problem, not just a database-tuning problem

## Trade-Offs
- consistent lock ordering:
  - low conceptual complexity
  - strong deadlock reduction
  - requires discipline across services / repositories / code paths
- owner-row locking:
  - good for set-level invariants
  - can create hotspots
  - often clearer than open-ended range checks
- optimistic versioning:
  - good for long-lived edits
  - poor fit for hot scarce resources
- `SERIALIZABLE`:
  - strongest generic correctness story
  - simpler to defend conceptually
  - can increase abort rate and tail latency
- bounded retry:
  - recovers many transient conflicts
  - can amplify load if used blindly without backoff and budgets

## What Breaks At Scale
- hot rows or hot owner records turn lock waits into `p95` / `p99` latency quickly
- deadlock storms appear when two high-volume code paths lock the same resources in different orders
- serialization retries under contention can magnify load and make throughput collapse nonlinear
- blind client retries can stack on top of server retries and create retry amplification
- if external side effects are not idempotent, transient DB abort recovery can still produce duplicate emails, payments, or downstream mutations

## What To Log Or Measure
- lock wait time
- deadlock count
- serialization failure count such as Oracle `ORA-08177`
- optimistic conflict count such as `409` / `412`
- unique-constraint violation count on booking / idempotency / external-reference keys
- retry count and retry success rate
- retry exhaustion count
- transaction latency by endpoint
- `p95` / `p99` for hot write paths
- owner-row hotspot frequency by tenant / hospital / slot

## Interviewer Pushback Questions
1. Why is deadlock not the same as a slow lock wait?
2. Why is retrying only the failed SQL statement usually wrong?
3. When would you auto-retry a deadlock victim, and when would you return conflict instead?
4. What is write skew, and why can it happen even if the two transactions update different rows?
5. How would you redesign a range-capacity invariant so weaker isolation is still safe?
6. What exact Oracle wording would you use for the default isolation level?
7. If `SERIALIZABLE` aborts transactions, why is that still considered correct behavior?
8. Why can missing indexes make concurrency behavior look worse?
9. If Oracle default is `READ COMMITTED`, what does one query actually see?
10. Why does idempotency still matter even if the database retries are correct?

## Strong 60-90 Second Answer
I would separate deadlock, serialization abort, stale-write conflict, and uniqueness conflict instead of calling them all transaction failures. A deadlock is a wait cycle, usually caused by inconsistent lock order, and the database breaks it by aborting one transaction. That class of failure is often safe to retry, but only by replaying the full transaction, only with a bounded budget, and only if no irreversible external side effect has already escaped. Write skew is different: two transactions can read the same set-level invariant and update different rows, so both commits can succeed while the business rule fails. In those cases I usually prefer an owner-row lock, a data-model change, or `SERIALIZABLE` plus retry. For Oracle-specific wording, I would say the default is `READ COMMITTED`, where each statement sees committed data as of the statement start, while `SERIALIZABLE` gives stronger transaction-level consistency but can abort with `ORA-08177`, which the app must handle as a bounded retry or recoverable error.

## Deliverables

By the end of W7D4, you should be able to:

- explain `LC 712` with exact weighted delete-cost state, ASCII-sum base cases, and mismatch branches
- explain `LC 1312` with exact interval state and why mismatch is `1 + min(...)`
- timed re-solve `LC 72` or `LC 97` from a clean state / base / transition explanation
- explain one deadlock wait cycle and one concrete prevention strategy
- explain one write-skew scenario where disjoint row updates still break a set-level invariant
- say when full-transaction retry is safe and when it is not
- give Oracle interview-safe wording for:
  - default `READ COMMITTED`
  - statement-level read consistency
  - `SERIALIZABLE` abort with `ORA-08177`
- name the metrics you would watch when contention starts hurting production

## Current Status
- `W7D4 topic baseline`: good enough after repair.
- `Deadlock vs lock wait vs serialization abort`: understood, but first-pass wording still drifts.
- `Write skew / predicate-capacity invariant`: good enough after repair.
- `Oracle-specific wording`: improved, but still needs memorized exact phrasing on first pass.
- `External-side-effect retry handling`: below bar until reconciliation / idempotency wording becomes automatic.
- `LC 712`: good enough.
- `LC 1312`: good enough.
- `Timed Week 7 recall under pressure`: still not verified because `LC 72` / `LC 97` timed re-solve was skipped.
- Main weakness remains spoken precision under follow-up, not recurrence design or topic selection.

## Next Review Items
1. Do one `30-45 sec` answer: `lock wait vs deadlock vs serialization abort vs business conflict`.
2. Re-answer `when is full-transaction retry safe?` with explicit idempotency and external-side-effect boundaries.
3. Re-answer Oracle wording cleanly:
   - default `READ COMMITTED`
   - statement-level read consistency
   - `ORA-08177`
4. Do one payment-flow answer where provider side effect may already have happened and explain reconciliation instead of blind retry.
5. Do one timed `LC 72` or `LC 97` re-solve to finish the planned Week 7 Day 4 recall slot.

## Findings

- Keep the state meaning explicit before writing the transition.
- Check base cases and return value before trusting the recurrence.
- Explain why the iteration order or traversal order preserves the intended invariant.

## Encountered Problems

Captured from the learning note; no separate failure note was recorded.
