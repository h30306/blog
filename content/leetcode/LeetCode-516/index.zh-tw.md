---
title: "LeetCode 516: Longest Palindromic Subsequence"
summary: "LeetCode 解題筆記：Longest Palindromic Subsequence"
description: "2026-07-11 的 LeetCode 學習紀錄"
date: 2026-07-11
tags: ["leetcode", "medium", "dynamic-programming", "string", "palindrome"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-07-11
來源筆記：`notes/day36-week7-day1-lcs-lps-acid-concrete-examples.md`

## 解題思路

這篇整理 Longest Palindromic Subsequence 的解題筆記，重點放在 interval DP on substrings、狀態定義、轉移式與容易犯錯的地方。

## 解法

以下內容整理自當天的 learning note，保留英文關鍵句，方便之後直接拿來做面試口說複習。

- **Pattern:** interval DP on substrings.

## Why This Fits
This is not a two-string prefix table.

The right question is:
```text
what is the longest palindromic subsequence inside s[left:right+1]?
```

That naturally gives an interval DP.

## Core State / Invariant
```text
dp[left][right] = length of the longest palindromic subsequence inside s[left:right+1]
```

## Base Cases
Single character:
```text
dp[i][i] = 1
```

Reason:
```text
one character is already a palindrome of length 1
```

## Transition
If the two ends match:
```text
s[left] == s[right]
=> dp[left][right] = dp[left + 1][right - 1] + 2
```

If they do not match:
```text
dp[left][right] = max(dp[left + 1][right], dp[left][right - 1])
```

## Fill Order
The interval depends on smaller inner intervals, so fill by:
- increasing substring length
or
- `left` decreasing, `right` increasing

## Complexity
```text
Time: O(n^2)
Space: O(n^2)
```

## Common Mistakes
- confusing subsequence with substring
- filling the table in the wrong order
- forgetting `dp[i][i] = 1`
- assuming matching ends always means the whole interval is a palindrome substring

## Strong Spoken Explanation
I define `dp[left][right]` as the length of the longest palindromic subsequence inside that substring interval. A single character is length `1`, so `dp[i][i] = 1`. If the two ends match, I can wrap the best inner answer with those two characters and add `2`. If they do not match, one of the ends is not used in the optimal subsequence, so I take the better answer from dropping the left side or dropping the right side. The key implementation detail is fill order, because each state depends on smaller inner intervals.

## Problem 3 - Review: LC 221 Maximal Square
- **Pattern:** Week 6 square-state maintenance.

## Why This Review Matters
Week 7 changes 2D DP shape completely.

This review checks that Week 6 square-growth reasoning is still stable:
- local geometry
- diagonal matters
- DP stores side length, not area

## Must-Hit Spoken Lines
```text
dp[r][c] = side length of the largest all-1 square ending at (r, c)
```

```text
answer = max_side ** 2
```

```text
min(top, left, diagonal) + 1
```

## Common Failure
- drifting into `count of squares`
- forgetting why diagonal is needed
- returning side length instead of area

## Topic - ACID With Concrete Backend Examples

## First Judgment
If your answer is only:
```text
Atomicity means all or nothing, Consistency means valid state, Isolation means transactions don't interfere, Durability means data is saved
```

that is below Tier A/S mid-level bar.

A stronger answer must say:
- what business invariant is being protected
- what failure or concurrency bug happens without the property
- where the database transaction boundary helps
- what still needs application-level handling outside the DB

## What A Strong Mid-Level Candidate Must Know
- Atomicity:
  - protects multi-step state changes from partial commit
  - example: create billing record + write payment ledger + update appointment status
- Consistency:
  - means committed state respects constraints and invariants
  - example: no negative inventory / no double-booked slot under enforced business rule
- Isolation:
  - controls what concurrent transactions are allowed to observe or interfere with
  - example: same appointment slot being booked by two users
- Durability:
  - committed changes survive crash / restart
  - example: payment marked captured should not disappear after DB restart
- ACID does not solve everything:
  - external side effects
  - retries
  - idempotency
  - cross-service distributed consistency

## Strong Answer Components
- start from one concrete backend flow
- name the invariant
- say what goes wrong if one ACID property is weak or absent
- distinguish database guarantees from application guarantees
- mention one limitation:
  - ACID inside one DB transaction is not the same as end-to-end distributed correctness

## Concrete ASUS / Hospital Examples

### Example 1 - Appointment Booking
Invariant:
```text
one appointment slot should not be confirmed for two patients
```

Use this to explain:
- Isolation:
  - concurrent bookings can race
- Consistency:
  - committed state should not violate uniqueness / capacity rule

### Example 2 - Billing / Payment Recording
Invariant:
```text
appointment payment status, ledger entry, and billing row should not diverge
```

Use this to explain:
- Atomicity:
  - either all DB changes commit or none do
- Durability:
  - once committed, the billing state should survive restart

### Example 3 - Patient Record Update
Invariant:
```text
the committed patient record should not reflect a broken partial update
```

Use this to explain:
- Atomicity:
  - no partial record write
- Isolation:
  - concurrent updates can still conflict even if each one is atomic

## Failure Cases And Edge Cases
- transaction commits DB state but external SMS/email send fails afterward
- DB atomicity does not prevent duplicate external side effects on retry
- Read Committed can still allow anomalies relevant to business correctness
- durability depends on real commit semantics, not just application response sent to client

## Trade-Offs
- stronger isolation:
  - safer correctness
  - lower concurrency / higher contention
- weaker isolation:
  - better throughput
  - more anomaly risk
- large transaction boundaries:
  - simpler invariant protection
  - longer locks / more contention / larger rollback cost

## What Breaks At Scale
- hot rows or hot slots create lock contention
- long transactions reduce concurrency and raise latency
- external side effects mixed into transaction thinking create false confidence about end-to-end correctness
- one-table ACID thinking does not automatically scale to multi-service workflows

## What To Log Or Measure
- transaction latency
- lock wait time / deadlock rate
- retry rate
- conflict rate on hot business entities
- mismatch incidents between DB state and external side effects

## Interviewer Pushback Questions
1. Why is `Atomicity` not enough to prevent duplicate payment capture?
2. How would two users booking the same slot expose an isolation problem?
3. What does `Consistency` mean beyond `the database is valid`?
4. What can still go wrong even if the DB gives full ACID inside one transaction?
5. Where would you keep the DB transaction boundary in a billing or appointment flow?

## Strong 60-90 Second Answer
I would explain ACID through one concrete business flow, not slogans. For appointment booking, the invariant is that one slot should not be confirmed twice, so isolation and consistency matter under concurrency. For billing, atomicity means related DB changes like ledger row, payment status, and appointment state should either all commit or all roll back together, while durability means the committed result survives restart. But I would also say ACID inside one database transaction is not the whole story. It does not automatically solve retries, duplicate external side effects, or cross-service consistency, so application-level idempotency and workflow design still matter.

## Deliverables

By the end of W7D1, you should be able to:

- explain `LC 1143` with exact prefix-based state and mismatch transition
- explain `LC 516` with exact interval-based state and fill order
- re-explain `LC 221` without Week 6 drift
- give one concrete ACID answer using appointment or billing examples
- explain one thing ACID protects and one thing ACID does **not** protect by itself

## 收穫

- 先講清楚 state meaning，再寫 recurrence。
- base case、迴圈方向、return value 要在 coding 前確認。
- 如果是 DP 壓縮、graph traversal、或 greedy frontier，要能說出 invariant 為什麼成立。

## 遇到的問題

原始筆記沒有另外紀錄失誤點。
