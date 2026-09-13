---
title: "Composite Index And Query Triage"
summary: "Reason about composite indexes through predicates, ordering, projection, and write cost"
description: "Week 6 learning notes: leftmost prefix, SARGability, covering index, Oracle-style plan reading"
date: 2026-05-12
tags: ["database", "composite-index", "query-plan", "oracle", "sargability"]
categories: ["database"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Learning Note Sources

- Day 29: composite index order and leftmost prefix
- Day 30: Oracle-style plan reading and full scan reasoning
- Day 31: covering index and index-only access
- Day 32-35: query vs index vs schema triage, ASUS-style query review

## Mental Model

A composite index should be designed from workload shape:

```text
predicate -> order -> projection -> write cost
```

Ask what the query filters on, whether it needs range or ordering behavior, how wide the returned columns are, and how expensive the index will be to maintain on writes.

## Leftmost Prefix

For an index:

```sql
(hospital_id, status, scheduled_at)
```

Good fits include:

```sql
WHERE hospital_id = ?
```

and:

```sql
WHERE hospital_id = ?
  AND status = ?
  AND scheduled_at >= ?
```

A weaker fit is:

```sql
WHERE status = ?
  AND scheduled_at >= ?
```

The precise phrasing is not always "the index cannot be used." It is that the query cannot form a strong contiguous leading-prefix seek.

## Equality Before Range

A practical index-order intuition is:

```text
equality filters first -> range / ordering column -> optional covering columns
```

Equality predicates narrow the search space. Once a range predicate starts, later columns usually cannot contribute the same kind of seek narrowing.

## SARGability

A predicate is SARGable when it can map cleanly to an index lookup or range scan.

Common index blockers:

- functions on indexed columns
- leading wildcard `LIKE '%abc'`
- broad `OR`
- `!=` or low-selectivity filters
- implicit type conversion on the column side

Instead of:

```sql
TRUNC(scheduled_at) = DATE '2026-05-12'
```

prefer a range:

```sql
scheduled_at >= DATE '2026-05-12'
AND scheduled_at < DATE '2026-05-13'
```

## Oracle-Style Plan Reading

Know these operators:

- `TABLE ACCESS FULL`: table scan
- `INDEX RANGE SCAN`: contiguous B-tree range scan
- `TABLE ACCESS BY INDEX ROWID`: fetch table rows by row location after index match

The key correction from the notes: `TABLE ACCESS BY INDEX ROWID` is not a second table scan. It is row fetching by location. It becomes expensive when many rowid fetches are scattered.

## Query / Index / Schema Triage

Do not start with "add an index." First ask:

1. Is the predicate SARGable?
2. Does the current index order match the predicate and order?
3. Is projection width causing heavy row fetches?
4. Are statistics or cardinality estimates stale?
5. Is a full scan already rational because the table is small or selectivity is weak?
6. Is the schema shape fighting the access pattern?
7. Can the write path afford another index?

## Example

For:

```sql
SELECT appointment_id, scheduled_at, status
FROM appointments
WHERE hospital_id = :hospital_id
  AND doctor_id = :doctor_id
  AND scheduled_at >= :from_time
  AND scheduled_at < :to_time
ORDER BY scheduled_at
FETCH FIRST 50 ROWS ONLY;
```

a narrow first candidate is:

```sql
(hospital_id, doctor_id, scheduled_at)
```

because the equality columns come first, then the range and ordering column. If row fetch remains the bottleneck and the endpoint is hot enough, a covering candidate could add projected columns:

```sql
(hospital_id, doctor_id, scheduled_at, status, appointment_id)
```

That must be justified against write cost.

## What To Measure

- execution plan operators
- estimated rows vs actual rows
- logical reads / buffer gets
- rows examined vs rows returned
- sort operations
- rowid lookup count
- p95 and p99 latency
- write latency and index maintenance cost

## 60-90 Second Answer

I design composite indexes from query shape. Equality predicates usually come first, then the range or ordering column, and only then optional covering columns. The leftmost-prefix rule means the query needs a contiguous usable leading prefix for a strong seek. If the plan shows an index range scan followed by many table accesses by rowid, row fetch may be the real bottleneck. A covering index can help, but only if the read path is hot and narrow enough to justify the write cost. If the predicate is not SARGable, I would rewrite the query before adding another index.
