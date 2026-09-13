---
title: "Transactions, Isolation, And MVCC"
summary: "A practical backend view of ACID, anomalies, MVCC, locks, and retry behavior"
description: "Database review notes for ACID, isolation levels, MVCC, deadlocks, write skew, and Oracle Read Committed"
date: 2026-05-19
tags: ["database", "transactions", "isolation", "mvcc", "locking", "oracle"]
categories: ["database"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Review Points

This topic is not about memorizing:

```text
ACID = Atomicity, Consistency, Isolation, Durability
```

At a Tier A/S interview bar, a transaction answer has to explain:

- the business invariant
- how concurrent transactions can break that invariant
- what the current isolation level still allows
- whether the right tool is optimistic versioning, row locking, a constraint, owner-row locking, or `SERIALIZABLE`
- how the application handles DB aborts, deadlocks, timeouts, and client retries
- what production signals show rising contention or retry storms

The core sentence:

```text
Transaction correctness is not about knowing the names.
It is about protecting a business invariant under concurrency, retry, crash, and partial failure.
```

## Tier A/S Readiness

If the answer is only:

```text
Read Uncommitted is weakest, Serializable is strongest.
MVCC lets reads not block writes.
If there is a deadlock, retry.
```

that is not enough.

A strong answer must add:

- `READ COMMITTED` prevents dirty reads but can still allow non-repeatable reads, phantoms, and read-check-write races
- MVCC improves snapshot visibility, but it does not automatically prevent stale writes or predicate-invariant bugs
- optimistic locking prevents stale writes, not every concurrency bug
- an idempotency key protects duplicate logical requests, not transaction interleavings
- `SERIALIZABLE` may preserve correctness by blocking or aborting, so the application needs bounded retry
- retry must replay the whole transaction and must not duplicate irreversible external side effects

## Start From The Invariant

In interviews, do not start with the isolation-level ladder. Start with:

```text
What state must never become invalid if two requests run at the same time?
```

Common invariants:

- an appointment slot must not be oversold
- a patient note must not be silently overwritten by a stale client
- after billing finalization, the same billing cycle must not still contain unbilled charge lines
- a payment retry must not create a second real charge
- one external reference or idempotency key must map to one logical result

The invariant shape decides the tool:

| Invariant shape | Common bug | First protection to consider |
|---|---|---|
| Single-row update | stale write / lost update | version column, `ETag`, `If-Match` |
| Hot scarce resource | double booking / oversell | short transaction + `SELECT ... FOR UPDATE` |
| Predicate or range rule | phantom / write skew | owner-row lock, redesign, `SERIALIZABLE` |
| Exact uniqueness | duplicate row | unique constraint |
| Same request repeated | duplicate side effect | idempotency key |

## ACID In Backend Terms

### Atomicity

Atomicity means all database changes inside the transaction boundary commit or roll back together.

Example:

- create an invoice row
- mark charge lines as billed
- update encounter billing status

If only the invoice row succeeds, but the charge lines are not updated, the system is left half-finished. Atomicity prevents that group of database mutations from being partially applied.

Important caveat:

```text
HTTP request boundary is not automatically the same as transaction boundary.
```

If the request also calls a payment provider, sends email, or publishes to a queue, the database transaction does not automatically roll back those external side effects.

### Consistency

Consistency does not mean "the data magically becomes correct."

A stronger phrasing:

```text
The transaction preserves declared database constraints and the business invariants that the system actually encodes.
```

The database can enforce:

- primary keys
- foreign keys
- unique constraints
- check constraints
- not-null constraints

The database does not automatically know:

- whether new charge lines are allowed after billing finalization
- whether appointment rescheduling must preserve audit history
- whether stale patient-note edits should be merged or rejected

Those rules require schema design, transaction logic, locking contracts, idempotency, and sometimes reconciliation.

### Isolation

Isolation controls what concurrent transactions can observe and how much they can interfere.

Do not stop at:

```text
transactions are isolated from each other
```

Say:

```text
The isolation level decides which interleavings are allowed and which anomalies the database prevents.
```

### Durability

Durability means that once commit succeeds, the database should preserve the result through crash and recovery.

Interview-safe caveat:

```text
Durability protects committed database state, not necessarily an external provider call unless the system has an outbox, reconciliation, or idempotent integration design.
```

## Isolation Levels

Do not only say "higher isolation is safer but slower." Say what each level prevents and what risk remains.

| Isolation level | Dirty read | Non-repeatable read | Phantom read | Interview-safe interpretation |
|---|---:|---:|---:|---|
| Read Uncommitted | possible | possible | possible | Almost never appropriate for correctness-sensitive OLTP flows |
| Read Committed | prevented | possible | possible | Each statement sees committed data, but later reads in the same transaction may see newer commits |
| Repeatable Read | prevented | usually prevented | engine-specific | More stable row rereads, but do not overclaim range behavior without engine context |
| Serializable | prevented | prevented | prevented | Equivalent to some serial order, but may increase blocking, aborts, and retry cost |

Common `READ COMMITTED` trap:

```text
It prevents dirty reads, but it does not mean a multi-step business decision is safe.
```

Example booking race:

1. transaction A reads that a slot has one remaining seat
2. transaction B reads that the same slot has one remaining seat
3. A inserts a booking
4. B inserts a booking
5. final capacity is exceeded

Each statement may have read only committed data, but the read-check-write decision still broke the invariant.

## Oracle Wording

Be precise when Oracle comes up:

- a common default transaction isolation level is `READ COMMITTED`
- each query sees a consistent snapshot of committed data as of that query's start time
- this is statement-level read consistency
- it does not mean the whole transaction sees one stable snapshot
- `SERIALIZABLE` is closer to transaction-level snapshot consistency
- Oracle may fail a transaction when it cannot maintain a serializable outcome, for example with `ORA-08177`

Interview-safe phrasing:

```text
In Oracle READ COMMITTED, each statement sees a consistent committed snapshot as of the statement start.
That is useful, but it is not the same as full transaction-level serializability.
```

## Four Anomalies

### Dirty Read

A dirty read means reading another transaction's uncommitted data, which may later roll back.

Scenario:

1. transaction A temporarily writes a new refund balance
2. transaction B reads that uncommitted value and makes a downstream decision
3. transaction A rolls back

Problem:

```text
B used a state that never truly existed.
```

`READ COMMITTED` generally prevents dirty reads.

### Non-Repeatable Read

A non-repeatable read means reading the same row twice inside one transaction and seeing a different committed value the second time.

Scenario:

1. transaction A reads a patient billing row with status = `PENDING`
2. transaction B commits a correction and changes status to `ADJUSTED`
3. transaction A reads the same row again and sees the new status

Problem:

```text
The transaction cannot assume a stable view of a row it already read.
```

`READ COMMITTED` can still allow this.

### Phantom Read

A phantom read means rerunning the same predicate or range query and seeing changed result-set membership.

Scenario:

```sql
SELECT count(*)
FROM appointments
WHERE doctor_id = :doctor_id
  AND slot_start = :slot_start
  AND status = 'CONFIRMED';
```

1. transaction A first sees count = 0
2. transaction B inserts a matching confirmed appointment and commits
3. transaction A reruns the same predicate and sees count = 1

The key point is not merely "one more row appeared":

```text
The business invariant lives on a predicate-defined set, not one row.
```

### Lost Update / Stale Write

A lost update happens when two users read an old version, the later writer overwrites the earlier writer, and the system never detects the conflict.

Scenario:

1. doctor A reads patient note version `12`
2. doctor B also reads version `12`
3. A saves first and moves the row to version `13`
4. B submits an edit still based on version `12`
5. without a version check, B may silently overwrite A's change

This usually needs:

- a version column
- `ETag`
- `If-Match`
- an optimistic-lock exception
- or an explicit lock inside a short transaction

Do not only say "use a higher isolation level" because long user-edit flows should not hold database locks across user think time.

## MVCC

Interview-safe definition:

```text
MVCC lets transactions read a consistent committed snapshot with better read/write concurrency.
```

Practical model:

- the database keeps multiple committed row versions or undo information
- a reader decides which version is visible in its snapshot
- many reads do not need the same blocking lock that a writer uses
- read-heavy workloads can become smoother

But do not overclaim:

```text
MVCC improves visibility and concurrency.
It does not automatically prove the business invariant is safe.
```

MVCC by itself is not:

- stale-write prevention
- duplicate-request prevention
- range-invariant protection
- hot-resource serialization
- external-side-effect safety

## Statement Snapshot Vs Transaction Snapshot

This is a common follow-up.

In some `READ COMMITTED` implementations, each statement sees a consistent committed snapshot as of statement start.

So:

```text
SELECT #1 can see snapshot S1.
SELECT #2 in the same transaction can see snapshot S2.
```

That means:

- one query can be internally consistent
- the whole transaction may still not see one stable world
- multi-step read-check-write logic can still be affected by concurrent commits

In transaction-level snapshot or stronger isolation, the transaction's visible world is more stable, but writer conflicts, write skew, aborts, and retries still matter.

## Optimistic Concurrency

Optimistic concurrency fits:

- rare expected conflicts
- long user think time
- avoiding a database lock while a user edits
- stale overwrite as the main risk

Typical design:

```http
GET /patient-notes/123
ETag: "v12"

PATCH /patient-notes/123
If-Match: "v12"
```

Database update:

```sql
UPDATE patient_notes
SET body = :body,
    version = version + 1
WHERE id = :id
  AND version = :expected_version;
```

If affected rows = 0:

- return `409 Conflict` or `412 Precondition Failed`
- return the latest version or a way to fetch it
- let the client or user reconcile

Do not blindly auto-retry a stale write, because the retry may just reapply old content over newer data.

## Pessimistic Locking

Pessimistic locking fits:

- hot scarce resources
- short critical sections
- high expected conflict
- cases where early serialization is cheaper than many late retries

Appointment capacity example:

```sql
BEGIN;

SELECT capacity, used_count
FROM slot_capacity
WHERE doctor_id = :doctor_id
  AND slot_start = :slot_start
FOR UPDATE;

-- re-check used_count < capacity inside the same transaction
-- then insert appointment and increment used_count

COMMIT;
```

The important parts:

- lock the shared owner row
- re-check the invariant inside the same transaction
- update the owner row or insert the booking
- keep the transaction short
- do not call external APIs while holding the lock

## Constraints Are Not Optional

Application checks race easily.

If an invariant can be expressed in schema, a database constraint should usually be the final backstop.

Example:

```sql
CREATE UNIQUE INDEX uniq_doctor_slot
ON appointments (doctor_id, slot_start)
WHERE status = 'CONFIRMED';
```

That fits a capacity = 1 rule.

If capacity > 1, a unique constraint alone may not be enough. Consider:

- an owner capacity row
- a counter update
- a checked constraint plus transaction logic
- `SERIALIZABLE`
- remodeling capacity as finite slot units

## Range Invariants And Phantoms

The risky pattern:

```sql
SELECT count(*)
FROM appointments
WHERE doctor_id = :doctor_id
  AND slot_start = :slot_start
  AND status = 'CONFIRMED';

-- if count < capacity, insert booking
```

This can fail because:

- the invariant lives on a set of rows matching a predicate
- there may be no single row that all transactions are forced to lock
- two transactions can each see a valid snapshot
- both can insert and create an invalid combined state

A stronger design:

```text
Serialize all writers through an owner record.
```

Example:

```sql
SELECT *
FROM slot_capacity
WHERE doctor_id = :doctor_id
  AND slot_start = :slot_start
FOR UPDATE;
```

Then every writer that can affect that slot's capacity must honor the same contract.

## Write Skew

Write skew is a classic set-level invariant bug.

Invariant:

```text
At least one doctor must remain on call for the ICU night shift.
```

Schedule:

1. transaction A sees that doctor A and doctor B are both on call
2. transaction B also sees that doctor A and doctor B are both on call
3. transaction A marks doctor A as off call
4. transaction B marks doctor B as off call
5. both transactions commit

Each transaction updated a different row, so there may be no direct writer/writer conflict.

But the final state is invalid:

```text
Zero doctors remain on call.
```

Interview points:

- this is not dirty read
- this is not a single-row stale write
- it is an unprotected set-level invariant
- snapshot-style reads can let each transaction believe it saw a valid state

Common fixes:

- lock one shift owner row
- keep a remaining-on-call counter on the owner row and update it transactionally
- use `SERIALIZABLE` and handle abort / retry
- use constraints or triggers only when the maintainability and race behavior are clear

## Billing Phantom Deep Dive

Invariant:

```text
When an encounter is finalized for a billing cycle,
there must be no unbilled charge lines left for that encounter and cycle.
```

Possible `READ COMMITTED` schedule:

1. transaction A runs:

```sql
SELECT *
FROM charge_lines
WHERE encounter_id = :encounter_id
  AND billing_cycle_id = :cycle_id
  AND invoice_id IS NULL;
```

2. A creates the invoice based on the current charge-line set
3. transaction B inserts a new matching charge line and commits
4. A commits invoice finalization

Bad final state:

- the encounter / cycle is marked invoiced
- but a charge line with `invoice_id IS NULL` still exists

Why this is not stale write:

- no one overwrote the same row
- the concurrent danger was a new row entering the predicate set
- a version column on the invoice row may not see that

`SERIALIZABLE` explanation:

```text
The database must reject, block, or otherwise prevent a combined committed outcome
that cannot be explained by any serial order.
```

Different engines do this differently. Some block, some abort one transaction at commit time.

Owner-row redesign:

```sql
SELECT *
FROM encounter_billing_cycle
WHERE encounter_id = :encounter_id
  AND billing_cycle_id = :cycle_id
FOR UPDATE;
```

Then, inside the same transaction:

- re-check unbilled charge lines
- create the invoice
- mark charge lines as billed
- update owner-row status

Required contract:

```text
All writers that can create or modify charge lines for this invariant must also respect the owner-row lock contract.
```

## Deadlocks

A deadlock is a circular wait, not simply a long lock wait.

Example:

1. transaction A locks appointment row first, then billing row
2. transaction B locks billing row first, then appointment row
3. A waits for B's billing lock
4. B waits for A's appointment lock

Result:

```text
Neither transaction can make progress.
```

The database usually chooses one transaction as the victim and aborts it.

Prevention:

- use consistent lock ordering across code paths
- keep transactions short
- keep lock scope narrow
- make locking predicates selective and indexed
- do not make slow external calls inside transactions
- do not hold database locks across user think time

## Retry Decision

Do not retry every error.

| Failure mode | What happened | Common handling | Auto retry? |
|---|---|---|---|
| Lock wait | blocked by another transaction, but no cycle yet | wait, timeout, report latency | not necessarily |
| Deadlock victim | DB aborts one side to break a cycle | roll back and replay the full transaction | yes, if bounded and retry-safe |
| Serialization abort | DB rejects a non-serializable schedule | roll back and replay the full transaction | yes, if bounded and retry-safe |
| Optimistic conflict | stale version tried to overwrite newer state | return `409` / `412` and reconcile | usually no blind retry |
| Unique violation | schema invariant was hit | return duplicate / conflict semantics | usually no blind retry |
| Duplicate request | same logical request was resent | idempotency replay of original result | not a re-execution |

Safe retry rule:

```text
Retry the full transaction only for transient concurrency failures,
only with a bounded budget,
and only if the workflow is idempotent and no irreversible external side effect has escaped.
```

If the transaction already called a payment provider, sent email, or made an irreversible partner call, rolling back the database is not the same as rolling back the world.

You may need:

- idempotency keys
- outbox pattern
- reconciliation jobs
- external-reference uniqueness
- a clear "unknown result" recovery path

## Idempotency Is Not Isolation

These layers are often mixed together.

| Mechanism | Protects | Does not protect |
|---|---|---|
| Isolation level | transaction visibility / interleaving | duplicate logical requests |
| Optimistic versioning | stale write / lost update | predicate insert / phantom |
| Row lock | known row or owner-row decision | writers that skip the same contract |
| Unique constraint | schema-expressible uniqueness | timeout response replay semantics |
| Idempotency key | request retry semantics | arbitrary concurrent invariants |

Strong answer:

```text
I use isolation or locking to control concurrent state transitions,
and idempotency to make the same logical request safe to repeat.
They solve different failure modes.
```

## What Breaks At Scale

- hot appointment slots push lock wait into `p95` / `p99` latency
- hot owner rows concentrate the correctness bottleneck on a small set of rows
- serializable aborts under contention can become retry storms
- optimistic conflicts on hot resources make many requests do work before failing
- missing indexes make locking queries scan more rows and widen contention
- long transactions increase snapshot pressure, undo retention, lock waits, and deadlock risk
- client retries stacked on top of server retries amplify load
- external side effects without idempotency can turn DB retry into duplicate payment or duplicate notification

## What To Log Or Measure

At minimum, be able to name:

- transaction latency by endpoint
- lock wait duration
- deadlock count
- serialization abort count, such as Oracle `ORA-08177`
- retry count, retry success rate, and retry exhaustion count
- optimistic conflict count, such as `409` / `412`
- unique violation count by constraint name
- idempotency-key hit / replay / payload mismatch count
- rows scanned vs rows returned for predicate checks
- hot row / hot slot / hot tenant distribution
- business invariant violation alerts

For billing finalization:

- finalized encounter with remaining unbilled charge lines
- duplicate external charge reference
- invoice finalization retry exhaustion
- slow predicate scan on `charge_lines`

## Interview Pushback

1. Why is `READ COMMITTED` often not enough for appointment capacity?
2. Why does MVCC not automatically prevent stale writes?
3. When would you use optimistic versioning instead of `SELECT ... FOR UPDATE`?
4. When is `SERIALIZABLE` better than owner-row locking?
5. When is owner-row locking better than blanket `SERIALIZABLE`?
6. Why is a phantom-read bug really a predicate-invariant bug?
7. Why should deadlock retry replay the full transaction instead of only the failed SQL?
8. What happens if a payment call succeeds but the DB transaction later aborts?
9. Why can a missing index make locking behavior worse?
10. What exact Oracle wording would you use for `READ COMMITTED`?

## 60-90 Second Answer

I would start from the business invariant instead of listing isolation names. `READ COMMITTED` usually prevents dirty reads, but it can still allow repeated reads to change inside a transaction, and it can allow phantoms on range queries, so booking or billing finalization cannot rely on it alone. MVCC lets transactions read a consistent committed snapshot and improves read/write concurrency, but it is not stale-write prevention and does not automatically protect predicate invariants. For a long patient-note edit, I would use a version column or `ETag` / `If-Match`, returning `409` or `412` when the client is stale. For a hot appointment slot or capacity row, I would use a short transaction with `SELECT ... FOR UPDATE`, lock the owner row, and re-check the invariant. For deadlocks or serialization aborts, I can use bounded full-transaction retry, but only if the operation is idempotent and no irreversible external side effect has already escaped.

## 10-15 Minute Deep Dive Path

If the interviewer asks for depth, use this sequence:

1. Draw one flow:

```text
client -> API -> service transaction -> DB rows -> optional external side effect
```

2. Mark the invariant:

```text
slot used_count <= capacity
or
invoice finalized implies no unbilled charge line remains
```

3. Give one `READ COMMITTED` schedule that breaks it.

4. Explain that the anomaly name is only the symptom:

```text
The real bug is the invalid final state.
```

5. Compare three fixes:

| Fix | Good fit | Cost |
|---|---|---|
| Optimistic versioning | single-row stale write | conflict is found late, bad fit for hot scarce resources |
| Owner-row `FOR UPDATE` | clear owner / capacity / cycle | owner row can become hot, every writer must honor the contract |
| `SERIALIZABLE` | hard-to-model predicate invariant | higher abort, retry, and tail-latency cost |

6. Add retry boundaries:

```text
DB-only transient aborts can retry the full transaction.
External side effects need idempotency, outbox, or reconciliation.
```

7. Close with production metrics:

```text
lock wait, deadlock, serialization abort, retry exhaustion, p95/p99, invariant alert.
```

## Common Mistakes

- reciting ACID as four English words only
- saying `READ COMMITTED` is enough for booking correctness
- saying MVCC means reads and writes never block each other
- mixing lost update, phantom, and write skew into one bug
- using a version column to solve an open-ended predicate insert
- holding a database lock across user think time
- retrying only the final SQL statement after a deadlock
- blindly retrying unique-constraint violations
- forgetting that external side effects are not part of DB rollback
- describing `SERIALIZABLE` as "all transactions simply line up"

## Final Deliverables

After reviewing this note, you should be able to:

- explain ACID in 60-90 seconds with each property tied to a backend failure mode
- give concrete scenarios for dirty read, non-repeatable read, phantom read, and lost update
- explain why `READ COMMITTED` is often not enough
- use accurate Oracle wording for `READ COMMITTED` and statement-level consistency
- say what MVCC helps with and what it does not solve
- choose optimistic versioning for patient notes and short row locks for hot slots
- compare owner-row locking, schema redesign, and `SERIALIZABLE` for predicate invariants
- distinguish deadlock, serialization abort, optimistic conflict, and unique violation handling
- state when retry is safe and when blind retry is dangerous
- name production metrics for contention and invariant protection
