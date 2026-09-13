---
title: "LeetCode 1092: Shortest Common Supersequence"
summary: "LeetCode Problem Solving - 2D DP with reconstruction over two prefixes"
description: "LeetCode study note from 2026-07-25"
date: 2026-07-25
tags: ["leetcode", "hard", "dynamic-programming", "string"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-07-25
Source Note: `notes/day41-week7-weekend-day1-shortest-common-supersequence-serializable-phantom-read.md`

## Intuition

I first compute the standard LCS table, where lcs[i][j] is the LCS length of str1[:i] and str2[:j]. That table tells me which characters can be shared. Then I reconstruct from the bottomright. If the current characters m

Pattern: 2D DP with reconstruction over two prefixes

## Approach

- **Pattern:** 2D DP with reconstruction over two prefixes.

## Why This Fits
The question is:
```text
what is the shortest string that contains str1 and str2 as subsequences?
```

The cleanest interview route is:
- first compute the `LCS` table
- then walk backward to build one shortest supersequence

Why this is strong:
- it reuses the Week 7 anchor table you already know
- it makes the overlap explicit:
  - matched characters should appear once
  - non-overlapping characters must still be preserved in order

## Core State / Invariant
```text
lcs[i][j] = length of the longest common subsequence between str1[:i] and str2[:j]
```

## Base Cases
If either prefix is empty:
```text
lcs[i][0] = 0
lcs[0][j] = 0
```

Reason:
```text
an empty string contributes no shared subsequence
```

## Transition
If the current characters match:
```text
str1[i - 1] == str2[j - 1]
=> lcs[i][j] = lcs[i - 1][j - 1] + 1
```

If they do not match:
```text
lcs[i][j] = max(lcs[i - 1][j], lcs[i][j - 1])
```

## Reconstruction Rule
Start from `(m, n)` and walk backward:

If the current characters match:
```text
append that character once
move diagonally
```

If they do not match:
- if `lcs[i - 1][j] >= lcs[i][j - 1]`
  - append `str1[i - 1]`
  - move up
- else
  - append `str2[j - 1]`
  - move left

After one string is exhausted:
- append the remaining tail of the other string
- reverse the built result at the end

## Why This Works
The `LCS` table tells you where the overlap is.

So during reconstruction:
- a matched character belongs once in the final answer
- on mismatch, moving toward the larger `LCS` value preserves more shared overlap
- the character from the side you move off must still appear in the supersequence, so you append it

The result keeps:
- all characters from `str1` in order
- all characters from `str2` in order
- shared characters only once when possible

## Complexity
```text
Time: O(m * n)
Space: O(m * n)
```

Reconstruction adds:
```text
O(m + n)
```

## Common Mistakes
- returning only the length instead of reconstructing the string
- appending a matched character twice
- forgetting to reverse the built answer
- forgetting to append the remaining tail when one string finishes first
- using `LC 72` edit-cost wording instead of subsequence / overlap wording
- assuming the output is unique when multiple shortest supersequences can exist

## Strong Spoken Explanation
I first compute the standard `LCS` table, where `lcs[i][j]` is the LCS length of `str1[:i]` and `str2[:j]`. That table tells me which characters can be shared. Then I reconstruct from the bottom-right. If the current characters match, I append the character once and move diagonally because that overlap should appear only once in the shortest supersequence. If they do not match, I move toward the neighbor with the larger `LCS` value and append the character from the side I moved off, because that character still has to be preserved in order. After the walk, I append any remaining tail and reverse the result. The table takes `O(m * n)` time and space, and reconstruction is linear.

## Alternative Direct DP
There is also a direct length DP:
```text
scs[i][j] = length of the shortest common supersequence of str1[:i] and str2[:j]
```

with:
```text
match    -> 1 + scs[i - 1][j - 1]
mismatch -> 1 + min(scs[i - 1][j], scs[i][j - 1])
```

Interview-safe rule:
- mention it if asked
- but the `LCS + reconstruction` route is easier to derive from Week 7 anchors in real time

## Problem 2 - Timed LCS / Edit Distance Set
- **Pattern:** same 2D table size, different semantics and different branches.

## Why This Review Matters
Weekend Day 1 is where Week 7 should stop feeling like:
```text
all string tables are kind of the same
```

The timed set should prove you can separate:
- shared-subsequence maximization
- source-to-target operation cost

## Timed Set
1. `LC 1143 Longest Common Subsequence`
2. `LC 72 Edit Distance`

## Must-Hit Lines
If `LC 1143`:
```text
dp[i][j] = LCS length between text1[:i] and text2[:j]
```

```text
match -> diagonal + 1
mismatch -> max(up, left)
```

If `LC 72`:
```text
dp[i][j] = minimum edits needed to convert word1[:i] into word2[:j]
```

```text
delete = dp[i - 1][j]
insert = dp[i][j - 1]
replace = dp[i - 1][j - 1]
```

## Pass Standard
Before coding each one, say:
```text
state =
base case =
transition =
why this matches the problem =
final answer =
```

## Common Failure
- using `max(...)` language when the problem is edit cost
- using `min(...)` language when the problem is shared-subsequence length
- saying the recurrence correctly but describing the English meaning incorrectly
- solving the table but being unable to defend why the mismatch branches are different

## Time Bar
- `LC 1143`: clean setup and correctness defense in about `7-8` minutes
- `LC 72`: clean setup and correctness defense in about `8-10` minutes

## Topic - Hospital-Billing Phantom Read And Serializable Reasoning

## First Judgment
If your answer is only:
```text
phantom read is when you run the same range query twice and see extra rows,
so I would use Serializable
```

that is below Tier A/S mid-level bar.

A stronger answer must say:
- what exact business invariant is at risk
- what predicate or range the invariant lives on
- why `READ COMMITTED` does not force those transactions to serialize
- how `SERIALIZABLE` preserves a valid serial order
- when owner-row locking or model redesign is the cheaper fix
- what the retry and side-effect boundary is

## What A Strong Mid-Level Candidate Must Know
- phantom-read scenarios are usually really:
  - predicate-invariant bugs
  - open-ended set-membership bugs
  - not just repeated-query trivia
- `READ COMMITTED` prevents dirty reads but does **not** guarantee that:
  - a set of rows matching a predicate stays stable for the whole transaction
  - no concurrent insert will newly satisfy the predicate
- `SERIALIZABLE` means:
  - the final outcome must be equivalent to some serial execution order
  - not that the database literally runs one transaction at a time
- depending on the engine, serializable behavior may be enforced by:
  - predicate / key-range locking
  - serialization-conflict detection and abort
  - or some combination
- full-transaction retry is only safe when:
  - the operation is idempotent
  - no irreversible external side effect already escaped
  - the retry budget is bounded
- a data-model redesign is often cheaper than blanket `SERIALIZABLE` if the hotspot is well understood

## Strong Answer Components
- start with the billing invariant
- name the exact predicate
- show the failing `READ COMMITTED` schedule
- explain what the database must do under `SERIALIZABLE`
- compare `SERIALIZABLE` with:
  - owner-row lock
  - unique constraint backstop
  - idempotency key
- finish with retry policy and observability

## Concrete Scenario - Finalize Encounter Invoice
Invariant:
```text
when an encounter is marked INVOICED for a billing cycle,
all billable charge lines for that encounter and cycle must be included exactly once,
and no unbilled charge line may still remain in that same cycle
```

Relevant predicate:
```sql
WHERE encounter_id = :encounter_id
  AND billing_cycle_id = :cycle_id
  AND invoice_id IS NULL
```

Transaction A:
- reads all currently unbilled charge lines for encounter `E`
- computes total amount
- inserts invoice summary row
- marks those charge lines with the new `invoice_id`
- updates encounter / cycle status to `INVOICED`

Transaction B:
- posts a late medication or admin-fee charge line
- inserts a new row that also matches:
  - `encounter_id = E`
  - `billing_cycle_id = C`
  - `invoice_id IS NULL`

## How `READ COMMITTED` Can Fail
Possible schedule:
1. transaction A reads the unbilled charge-line set
2. transaction B inserts a new unbilled charge line for the same encounter / cycle and commits
3. transaction A finalizes the invoice based on the earlier read set

Why this is a real correctness bug:
- if A re-runs the predicate, it can now see an extra matching row:
  - a phantom
- even if A never re-runs the query, the final state can still violate the invariant:
  - invoice is closed
  - but an unbilled line remains in the same cycle

This is why strong interview answers should say:
```text
phantom read is not just a query-repeat phenomenon;
it is often a predicate-level business-invariant failure
```

## How `SERIALIZABLE` Preserves Correctness
Step by step:
1. transaction A begins in `SERIALIZABLE`
2. A reads the predicate set of unbilled charge lines
3. B tries to insert a new row that would satisfy A's predicate
4. the database must prevent both transactions from committing in a way that cannot be explained by any serial order
5. depending on engine behavior, the database may:
   - block B until A finishes
   - abort B
   - or allow progress and abort A or B at commit as a serialization failure
6. the application rolls back the whole failed transaction and either retries safely or returns a recoverable conflict

Interview-safe phrasing:
```text
Serializable helps because the database will not let both transactions commit
if the combined outcome would be impossible under any serial execution order.
```

## Why This Is Not Just A Stale-Write Conflict
- no single row is necessarily being overwritten
- the bug lives on a predicate-defined set
- the dangerous concurrent action may be:
  - an insert of a new matching row
  - not an update to an already-read row
- a plain version check on one invoice row does not automatically protect an open-ended `invoice_id IS NULL` predicate

## When Owner-Row Locking Or Redesign Is Better
Serializable is a strong answer, but not always the cheapest answer.

Often a better design is:
- create or reuse one owner record such as:
  - `encounter_billing`
  - `billing_cycle`
  - `encounter_cycle_summary`
- lock that owner row with `SELECT ... FOR UPDATE`
- re-check the charge-line set inside the same transaction
- finalize the invoice while all related writers must serialize through the same owner row

Why this can be better:
- narrower concurrency contract
- easier to reason about operationally
- less abort churn than broad serializable conflicts on a hot billing window

Important caveat:
- the redesign only works if every write path that affects the invariant also touches the same owner row or contract

## Failure Cases And Edge Cases
- retrying only the failed invoice insert instead of the full transaction can break correctness
- if external insurance submission or payment capture already happened, blind retry can duplicate the side effect
- if the finalize query lacks a good index on the predicate, the engine may scan too broadly and amplify contention
- long-running invoice finalization increases the serialization footprint and conflict probability
- uniqueness constraints can backstop some invariants, but they do not replace idempotency for duplicate API retries
- optimistic versioning on the encounter header alone is not enough unless all charge-line inserts also update the protected owner version

## Trade-Offs
- `SERIALIZABLE`:
  - strongest generic correctness story
  - simplest to defend conceptually
  - can increase abort rate, lock waits, and tail latency under hotspots
- owner-row locking:
  - explicit and often operationally simpler
  - good for one encounter / one cycle / one scarce counter
  - can create hotspot rows
- uniqueness constraints:
  - excellent backstop when the invariant is schema-expressible
  - weak for open-ended aggregate or range invariants
- idempotency keys:
  - solve duplicate logical request replay
  - do **not** solve predicate-level serialization alone
- optimistic version checks:
  - good for stale overwrite on known rows
  - weak for new-row phantom / predicate membership changes

## What Breaks At Scale
- end-of-day or end-of-cycle billing spikes turn serializable conflicts into retry churn quickly
- hot hospitals or enterprise tenants can create owner-row hotspots
- long charge-line scans raise `p95` / `p99` on finalize-invoice endpoints
- server retries plus client retries can create retry amplification
- weak side-effect boundaries create duplicate downstream submissions even when the database itself stays correct

## What To Log Or Measure
- serialization-failure count by endpoint and tenant
- lock wait time and deadlock count if using owner-row locking
- retry count, retry success rate, and retry exhaustion count
- finalize-invoice latency:
  - `p50`
  - `p95`
  - `p99`
- rows scanned vs rows returned for the charge-line predicate
- invariant-violation alert:
  - `encounter marked INVOICED while unbilled charge line still exists`
- idempotency-key replay count on finalize / submit endpoints

## Interviewer Pushback Questions
1. Why is this not just a lost-update or stale-write problem?
2. Why is phantom-read vocabulary alone not enough for a strong answer?
3. If `SERIALIZABLE` may abort transactions, why is that still correct behavior?
4. When would you prefer owner-row locking over blanket `SERIALIZABLE`?
5. What exact retry boundary would you use if an external insurer or payment provider may already have been called?
6. What index would you want on `charge_lines`, and why does index shape affect concurrency behavior?
7. Why does a version column on one header row not fully solve open-ended predicate inserts by itself?
8. If you use owner-row locking, what ensures all code paths actually honor that contract?

## Strong 60-90 Second Answer
For a phantom-read question, I would anchor on the business invariant, not on ANSI vocabulary. In hospital billing, a good example is invoice finalization: when an encounter is marked invoiced for a cycle, there must be no remaining unbilled charge lines in that same cycle. Under `READ COMMITTED`, one transaction can read the current unbilled set and start finalizing while another transaction inserts a new matching charge line, so the first transaction can commit an invoice that is already incomplete. That is a predicate-level correctness bug, not just a repeated-query curiosity. `SERIALIZABLE` fixes it because the database will not allow both transactions to commit if the combined outcome cannot be explained by any serial order, though one side may block or abort. In practice I would also compare that with locking an owner billing row, because that is sometimes cheaper operationally than broad serializable conflicts. Then I would close with retry boundaries, idempotency, and the lock / abort metrics I would watch in production.

## 30-45 Minute Design Extension
If the interviewer pushes into design depth, be ready to draw:
- tables:
  - `encounter`
  - `charge_lines`
  - `invoice`
  - optional `encounter_billing` owner row
  - `idempotency_keys`
- two designs:
  - `SERIALIZABLE` finalization
  - owner-row lock plus re-check
- the external side-effect boundary:
  - when claim submission or payment capture is allowed
  - when outbox / reconciliation is safer than inline side effects
- the observability plan:
  - retry metrics
  - invariant alarms
  - slow predicate scan alarms

## Deliverables

By the end of W7 Weekend Day 1, you should be able to:

- explain `LC 1092` using an `LCS` table plus reconstruction, including why matches are appended once
- rebuild one valid shortest common supersequence without index drift or tail-handling bugs
- timed re-solve `LC 1143` and `LC 72` from clean state / base / transition explanations
- explain a hospital-billing phantom / predicate-invariant bug with a concrete schedule
- explain why `READ COMMITTED` can still allow that bug
- explain how `SERIALIZABLE` preserves correctness without describing it as `no concurrency`
- compare `SERIALIZABLE` with owner-row locking and say when each is cheaper
- define when full-transaction retry is safe and when external side effects make blind retry unsafe
- name the key production metrics for contention and invariant protection

## Current Status
- `W7 weekend topic block`: good enough after repair
- hospital-billing phantom read now reaches the intended interview bar:
  - predicate-defined invariant
  - concrete concurrent schedule
  - `READ COMMITTED` failure
  - `SERIALIZABLE` as equivalent-serial-order guarantee
  - owner-row alternative
  - retry and metric boundaries
- `LC 1092`: good enough
- `LC 1143`: good enough
- `LC 72`: good enough
- carry-forward debt from `W7D4` is still only partially cleared:
  - spoken anchor explanations were practiced
  - but the planned timed `LC 1143` / `LC 72` recall bar was not actually verified in-session
- main weakness remains:
  - spoken precision on first pass
  - not concept selection or recurrence design
- strongest remaining risk for this day is:
  - drifting back into approximate wording under follow-up even when the core idea is right

## Next Review Items
1. Do one truly timed `LC 1143` re-solve and defend why mismatch is `max(up, left)` and not diagonal.
2. Do one truly timed `LC 72` re-solve and defend delete / insert / replace from source -> target without wording drift.
3. Re-give the full `60-90 sec` hospital-billing answer in one shot with no wording repairs.
4. Do one `30-45 sec` compare drill:
   - `LC 1092` vs `LC 1143`
   - `LC 72` vs `LC 1143` mismatch reasoning
5. Draw one whiteboard version of the invoice-finalization flow and mark:
   - predicate read
   - concurrent insert
   - owner-row alternative
   - retry boundary
   - external side-effect boundary

## Interview Mode

Use this section to run `W7WkndD1` as a strict mock interview.

Interviewer rule:
- ask only the clean prompt first
- do **not** give templates, hints, or reminder bullets before the candidate answers
- after the first answer, push on precision, invariants, transitions, retry boundaries, and failure cases

## Session Run Order
1. `LC 1092` full interview question: `20-25 min`
2. timed `LC 1143`: `7-8 min`
3. timed `LC 72`: `8-10 min`
4. backend short answer on phantom read: `60-90 sec`
5. backend deep dive with pushback: `10-15 min`
6. grading and repair summary: `5-10 min`

## Round 1 - LC 1092

Ask only:
```text
Implement Shortest Common Supersequence for two strings.
Explain your approach before you code.
```

After the candidate answers, push with:
1. What exact state are you computing in the table?
2. Why are you using an `LCS` table instead of a direct SCS-length table?
3. On mismatch during reconstruction, why is moving toward the larger neighbor correct?
4. Why do you append the character from the side you moved off?
5. Why is the matched character appended only once?
6. What goes wrong if you forget to append the remaining tail after one pointer hits zero?
7. Is the output unique?
8. Give time and space complexity for both table build and reconstruction.

Must-hear points:
- `lcs[i][j]` means LCS length of the two prefixes
- match -> diagonal + 1
- mismatch -> `max(up, left)` in the `LCS` table
- reconstruction walks backward from `(m, n)`
- on match, append once and move diagonal
- on mismatch, move toward the larger `LCS` neighbor and append the character from the side moved off
- reverse at the end
- multiple valid shortest supersequences may exist

Immediate fail signals:
- only returns length
- cannot explain why reconstruction is correct
- mixes edit-distance operations into subsequence reconstruction
- appends both mismatched characters at every step without using the table
- cannot defend complexity

## Round 2 - Timed LC 1143

Ask only:
```text
Implement Longest Common Subsequence.
You have about 7 to 8 minutes. Explain briefly, then code.
```

After the candidate answers, push with:
1. What exact prefixes does `dp[i][j]` represent?
2. Why is mismatch `max(up, left)` instead of `min(...)`?
3. Why do you not need an explicit mismatch use of `dp[i - 1][j - 1]`?
4. What are the base row and base column modeling?

Must-hear points:
- two-prefix DP
- empty-prefix row / column are zero
- mismatch means one current character is excluded
- answer is `dp[m][n]`

## Round 3 - Timed LC 72

Ask only:
```text
Implement Edit Distance.
You have about 8 to 10 minutes. Explain the state and recurrence, then code.
```

After the candidate answers, push with:
1. Convert from which string to which string?
2. What exactly do delete, insert, and replace mean in your recurrence?
3. Why does mismatch have three branches here but not in `LC 583`?
4. What do `dp[i][0]` and `dp[0][j]` mean in words?

Must-hear points:
- `dp[i][j]` = minimum edits to convert `word1[:i]` into `word2[:j]`
- base cases are prefix lengths
- mismatch branches are delete / insert / replace
- answer is bottom-right

Immediate fail signals:
- operation wording is directionally wrong
- recurrence is right but English meaning is wrong
- mixes delete-only and full-edit tables

## Round 4 - Backend Short Answer

Ask only:
```text
Give me a 60 to 90 second answer for a hospital-billing phantom read scenario
and explain why Serializable helps.
```

After the candidate answers, push with:
1. What exact invariant is being protected?
2. What is the predicate or range?
3. Why is this not just a stale-write conflict?
4. What can happen under `READ COMMITTED`?
5. What exactly does `SERIALIZABLE` guarantee here?

Must-hear points:
- business invariant over `unbilled charge lines` in a billing cycle
- concurrent insert can create a new matching row
- this is a predicate-level correctness bug, not just repeated-query vocabulary
- `SERIALIZABLE` preserves equivalence to some serial order
- one transaction may block or abort

Immediate fail signals:
- only defines phantom read abstractly
- says `Serializable means no concurrency`
- cannot state the invariant

## Round 5 - Backend Deep Dive And Pushback

Ask only:
```text
Design the invoice-finalization workflow so the invariant is preserved.
Compare Read Committed, Serializable, and an owner-row locking design.
```

After the candidate answers, push with:
1. Why is a version column on the invoice header alone not enough?
2. When is owner-row locking cheaper than blanket `SERIALIZABLE`?
3. What index would you want on the charge-line predicate, and why does it matter for contention?
4. What is your retry boundary if an external insurer submission or payment capture may already have happened?
5. What metrics would tell you this design is failing in production?
6. What ensures every write path honors the owner-row contract?

Must-hear points:
- invariant first, then mechanism
- `READ COMMITTED` can miss concurrent inserts satisfying the predicate
- `SERIALIZABLE` may block or abort to preserve correctness
- owner-row lock can narrow the concurrency contract
- full-transaction retry only when safe and idempotent
- external side effects require reconciliation or outbox-style handling
- observability includes serialization failures, lock waits, retries, latency, and invariant alarms

## Grading Bar

Mark each block as one of:
- `good enough`
- `needs repair`
- `below bar`

Day-level pass standard:
- `LC 1092` must be at least `good enough`
- at least one of `LC 1143` or `LC 72` must be clearly `good enough`, and the other cannot be `below bar`
- backend short answer must be `good enough`
- backend deep dive can be `needs repair`, but not on invariant definition or retry boundary

If the candidate misses any of these, treat the day as not yet interview-pass:
- cannot reconstruct `LC 1092`
- cannot keep `LC 1143` and `LC 72` semantics separate
- cannot explain the billing invariant concretely
- says `Serializable` without explaining block / abort / serial-order meaning
- gives unsafe blind-retry advice around external side effects

## Post-Session Output Format

After running the session, replace `Session Outcome` with:
- problem-by-problem pass / repair notes
- short-answer backend result
- deep-dive backend result
- main wording drifts
- exact next repair items

## Findings

- Keep the state meaning explicit before writing the transition.
- Check base cases and return value before trusting the recurrence.
- Explain why the iteration order or traversal order preserves the intended invariant.

## Encountered Problems

Captured from the learning note; no separate failure note was recorded.
