---
title: "Transactions, Isolation, And MVCC"
summary: "A practical backend view of ACID, anomalies, MVCC, locks, and retry behavior"
description: "Week 7 learning notes: ACID, isolation levels, MVCC, deadlocks, Oracle Read Committed"
date: 2026-05-19
tags: ["database", "transactions", "isolation", "mvcc", "locking", "oracle"]
categories: ["database"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Learning Note Sources

- Day 36: ACID with concrete backend examples
- Day 37: isolation levels and booking / billing correctness
- Day 38: MVCC, optimistic vs pessimistic locking, `SELECT ... FOR UPDATE`
- Day 39: deadlock, write skew, Oracle `READ COMMITTED` and `ORA-08177`
- Day 41-42: Serializable, phantom read, no-notes recall

## Mental Model

Do not start a transaction answer with textbook ACID slogans. Start with the business invariant:

```text
What state must never become invalid, even under retry, crash, and concurrent writes?
```

Examples:

- appointment capacity must not be oversold
- billing row, payment ledger, and appointment status must stay consistent
- patient notes must not be overwritten by stale clients
- duplicate payment retries must not create duplicate side effects

## ACID In Backend Terms

Atomicity means a group of changes succeeds or fails together. A billing flow should not create a payment ledger row without updating the appointment payment status.

Consistency means constraints and business invariants stay valid, but the database does not know every product rule unless schema and transaction logic encode it.

Isolation controls what concurrent transactions can observe or interfere with.

Durability means committed data survives crash and recovery.

## Isolation Levels

The interview-safe answer is not "higher isolation is safer but slower." Say what each level prevents and still allows:

| Level | Prevents | Still Allows |
|---|---|---|
| Read Uncommitted | Very little | dirty reads, non-repeatable reads, phantoms |
| Read Committed | dirty reads | non-repeatable reads, phantoms, lost-update risk |
| Repeatable Read | more stable repeated row reads | engine-specific phantom / range behavior |
| Serializable | non-serial outcomes | contention, blocking, aborts, retries |

Oracle commonly defaults to `READ COMMITTED` with statement-level read consistency. That does not mean one transaction sees a stable snapshot for its whole duration, and it does not automatically protect booking or billing invariants.

## MVCC

Safe phrasing:

```text
MVCC lets transactions read a consistent committed snapshot with better read/write concurrency.
```

Avoid overclaiming that readers and writers never block each other. MVCC does not, by itself, solve:

- stale writes
- duplicate requests
- range-invariant violations
- hot resource serialization

## Optimistic vs Pessimistic Locking

Optimistic locking fits rare conflicts and long user-think-time flows, such as patient-note editing.

Use:

```text
version column or ETag + If-Match
```

On mismatch, return `409 Conflict` or `412 Precondition Failed`; the client should refetch and reconcile, not blindly retry the stale write.

Pessimistic locking fits hot scarce resources and short critical sections. For appointment capacity:

```sql
SELECT *
FROM slot_capacity
WHERE doctor_id = :doctor_id
  AND slot_start = :slot_start
FOR UPDATE;
```

Lock the owner row, re-check inside the transaction, then insert or update.

## Range Invariants And Phantoms

A risky pattern:

```sql
SELECT count(*)
FROM appointments
WHERE doctor_id = :doctor_id
  AND slot_start = :slot_start
  AND status = 'confirmed';

-- if count < capacity, insert booking
```

The invariant lives on a predicate-matching set, not one shared row. Two transactions can both see available capacity and insert, causing overbooking.

Fixes include owner-row locking, a unique constraint when capacity is one, Serializable-style protection, and bounded retry after serialization aborts.

## Deadlocks And Retry

A deadlock is circular wait, not just a slow lock wait.

Prevention:

- consistent lock ordering
- short transactions
- no slow external calls inside transactions
- clear lock granularity

After deadlock or serialization abort, bounded retry is common, but only when the operation is retry-safe or protected by idempotency.

## Idempotency Is Not Isolation

Keep the layers separate:

- optimistic locking prevents stale writes
- uniqueness constraints enforce schema invariants
- idempotency keys preserve request semantics after retries
- isolation levels control transaction visibility and interleaving

## What To Measure

- lock wait time
- deadlock count
- serialization abort count
- retry count and retry success rate
- conflict / precondition failure rate
- transaction duration
- hot row / hot slot contention
- idempotency replay outcome

## 60-90 Second Answer

I start from the business invariant. `READ COMMITTED` prevents dirty reads, but it can still allow non-repeatable reads, phantoms, and stale-write risks. MVCC gives consistent committed snapshots and better concurrency, but it is not stale-write prevention. For long patient-note edits, I would use optimistic versioning or ETags. For hot appointment slots, I would lock a capacity owner row and re-check inside the transaction. Deadlocks or serialization aborts need bounded retry, but retry is safe only if the operation is idempotent or otherwise protected from duplicate side effects.
