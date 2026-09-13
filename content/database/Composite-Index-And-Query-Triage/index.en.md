---
title: "Composite Index And Query Triage"
summary: "Reason about composite indexes through predicates, ordering, projection, plan shape, and write cost"
description: "Database review notes for leftmost prefix, SARGability, covering indexes, Oracle-style plan reading, and query/index/schema triage"
date: 2026-05-12
tags: ["database", "composite-index", "query-plan", "oracle", "sargability", "query-optimization"]
categories: ["database"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Review Points

- A composite index is not a bag of common columns; it must match query shape
- Leftmost prefix is about a contiguous usable leading prefix
- Equality predicates, range predicates, and ordering columns decide where seek narrowing stops
- SARGability should be fixed before adding indexes
- Oracle-style plans: `TABLE ACCESS FULL`, `INDEX RANGE SCAN`, `TABLE ACCESS BY INDEX ROWID`
- Covering indexes reduce row fetches but increase index width and write tax
- Full scan can be a rational plan
- Slow-query triage means choosing among query rewrite, index change, schema/read-model change, stats fix, or no change

## Tier A/S Readiness

If your answer is only:

```text
Put equality columns first, then range columns.
```

that is not enough. A Tier A/S interview keeps pushing:

- Why can this query use the index leading prefix while another one cannot?
- After the first range predicate, what can later columns still do?
- Can `ORDER BY` be satisfied by the index order?
- Is `INDEX RANGE SCAN` followed by `TABLE ACCESS BY INDEX ROWID` good or bad?
- Why should a non-SARGable predicate be rewritten before adding another index?
- When is a covering index worth it, and when does it only make writes heavier?
- When should you change the schema or read model instead of adding another index?

A strong answer thinks through:

```text
query intent
-> predicate shape
-> ordering need
-> projected columns
-> current plan shape
-> rows / logical reads / row fetch
-> write impact
-> choose query, index, schema, stats, or no change
```

## Mental Model

Composite index design starts with:

```text
predicate -> order -> projection -> write cost
```

Ask:

- Which columns does the query filter on?
- Which predicates are equality?
- Which predicates are range?
- Is there an `ORDER BY` or top-N?
- How wide is the projection?
- How frequent is the query?
- Is the table read-heavy or write-heavy?

Do not model a composite index as:

```text
(all columns that appear somewhere in the query)
```

Better:

```text
an ordered access path whose left-to-right key order must match how the query narrows, scans, sorts, and returns rows
```

## Leftmost Prefix

Assume the index is:

```sql
(hospital_id, status, scheduled_at)
```

Strong fit:

```sql
WHERE hospital_id = ?
```

Stronger:

```sql
WHERE hospital_id = ?
  AND status = ?
```

Full leading prefix plus range:

```sql
WHERE hospital_id = ?
  AND status = ?
  AND scheduled_at >= ?
  AND scheduled_at < ?
```

Much weaker:

```sql
WHERE status = ?
  AND scheduled_at >= ?
```

because the leading column `hospital_id` is missing.

Do not phrase it too absolutely as:

```text
the database cannot use the index at all
```

More precise:

```text
the query cannot form a strong contiguous leading-prefix seek on this index
```

Some optimizers may still scan the index, use skip scan, or use the index for another purpose, but that is not the clean seek path we wanted.

## Where Seek Narrowing Stops

Composite indexes usually narrow efficiently through:

```text
leading equality columns + first range column
```

Example:

```sql
WHERE hospital_id = ?
  AND status = ?
  AND scheduled_at >= ?
  AND scheduled_at < ?
  AND doctor_id = ?
```

For index:

```sql
(hospital_id, status, scheduled_at, doctor_id)
```

the engine can usually use:

```text
hospital_id equality
status equality
scheduled_at range
```

But `doctor_id` appears after the range column, so it usually cannot provide the same level of seek narrowing. It may still filter index entries, but it is not the same clean left-to-right seek.

## Equality Before Range

Practical intuition:

```text
equality filters first -> range / ordering column -> optional covering columns
```

Why:

- equality predicates shrink the search space first
- the range column defines the leaf scan start and end
- columns after a range usually cannot keep narrowing the search path in the same way
- if `ORDER BY` aligns with index order, the query may avoid a sort

Example query:

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

Natural candidate:

```sql
(hospital_id, doctor_id, scheduled_at)
```

because:

- `hospital_id` equality
- `doctor_id` equality
- `scheduled_at` range + order
- top-N can stop early inside the ordered range

If the index is:

```sql
(hospital_id, status, scheduled_at)
```

but the query does not fix `status`, then `status` sits in the middle and breaks the clean time-ordered access path.

## Ordering Behavior

Whether an `ORDER BY` can be satisfied by an index is not only about whether the column exists in the index.

Check:

- whether leading columns are fixed by equality
- whether the ordering column follows the usable prefix
- whether scan direction can handle the sort direction
- whether the range predicate is compatible with the order
- whether there is a missing middle column

Example:

```sql
WHERE hospital_id = ?
  AND doctor_id = ?
ORDER BY scheduled_at
```

Index:

```sql
(hospital_id, doctor_id, scheduled_at)
```

is usually a strong fit.

But:

```sql
(hospital_id, scheduled_at, doctor_id)
```

may still have some use, but if the query needs to narrow to one doctor first, placing `doctor_id` after `scheduled_at` can expand the scan range. The point is to explain the access path, not recite a slogan.

## SARGability

SARGable means:

```text
the predicate can be mapped cleanly to an index lookup or index range scan
```

Common index blockers:

- function on indexed column: `TRUNC(scheduled_at) = :day`
- leading wildcard: `LIKE '%abc'`
- broad `OR`
- `!=`
- low-selectivity predicate
- implicit type conversion on the column side

Bad shape:

```sql
WHERE TRUNC(scheduled_at) = DATE '2026-05-12'
```

Better shape:

```sql
WHERE scheduled_at >= TIMESTAMP '2026-05-12 00:00:00'
  AND scheduled_at <  TIMESTAMP '2026-05-13 00:00:00'
```

Reason:

```text
range predicate preserves the raw indexed column order
```

## Oracle-Style Plan Reading

Know at least:

```text
TABLE ACCESS FULL
INDEX RANGE SCAN
TABLE ACCESS BY INDEX ROWID
INDEX FULL SCAN
INDEX FAST FULL SCAN
```

### TABLE ACCESS FULL

Scan table blocks directly and apply filters.

It is not automatically bad. If the table is small, selectivity is weak, or many rows are needed, full scan may be the cheapest plan.

### INDEX RANGE SCAN

Scan a contiguous key range in a B-tree index.

This often means the index can locate a useful key range, but it does not mean the entire query is finished.

### TABLE ACCESS BY INDEX ROWID

After the index finds row locations, fetch table rows by location.

Important correction:

```text
TABLE ACCESS BY INDEX ROWID is not a second full-table search.
```

It is location-based fetch. The problem is that many scattered rowid fetches can become very expensive.

### INDEX FULL SCAN vs INDEX FAST FULL SCAN

Simplified:

- `INDEX FULL SCAN`: scans the whole index in index order, often preserving ordering
- `INDEX FAST FULL SCAN`: scans the index more like a narrower segment, often not preserving order

You do not need to overfit the details in every interview. The important point is:

```text
index scan does not always mean selective seek
```

## Covering / Index-Only Access

A covering index is query-dependent:

```text
filter columns + order columns + returned columns are all available from the index path
```

Its main value is removing:

```text
TABLE ACCESS BY INDEX ROWID
```

Good fit:

- hot endpoint
- narrow projection
- selective predicate
- top-N ordered query
- read-heavy path

Be careful with:

- `SELECT *`
- wide projection
- write-heavy table
- cold endpoint
- weak selectivity that reads many rows anyway

Safe answer:

```text
I would make the index covering only if row fetch is the proven bottleneck and the read win is worth the wider index.
```

## Full Scan Can Still Be Correct

A full scan can be correct when:

- the table is small
- the query needs a large fraction of rows
- the predicate has weak selectivity
- secondary index would cause many scattered row fetches
- statistics show scanning is cheaper
- the index does not support the filter/order shape
- the index is narrower than the table but still must scan a large range

Interview-safe sentence:

```text
Full scan is not automatically bad; it is bad only if it is unexpectedly reading much more than necessary for a hot query.
```

## Stats And Cardinality Risk

The optimizer uses statistics to estimate:

- how many rows a predicate will match
- whether index path is cheaper than scan
- join order
- sort/hash cost

If stats are stale or data skew is large:

- a reasonable index may be ignored
- estimated rows may be far lower than actual rows
- the plan may become unstable as data distribution changes

Check:

- estimated rows vs actual rows
- whether histogram / skew matters
- when stats were last gathered
- whether bind variables cause plan instability

## Query / Index / Schema Triage

Do not start every slow query with adding an index. Classify the problem first.

### 1. Query Rewrite First

Use when:

- predicate is not SARGable
- `SELECT *` is obviously too wide
- function on indexed column
- implicit conversion
- broad `OR` can be split

Example:

```sql
SELECT *
FROM appointments
WHERE TRUNC(scheduled_at) = :day
  AND hospital_id = :hid
ORDER BY created_at DESC
FETCH FIRST 100 ROWS ONLY;
```

First move:

```text
rewrite query shape first
```

Rewrite:

```sql
SELECT appointment_id, scheduled_at, status, created_at
FROM appointments
WHERE hospital_id = :hid
  AND scheduled_at >= :day_start
  AND scheduled_at < :next_day_start
ORDER BY created_at DESC
FETCH FIRST 100 ROWS ONLY;
```

Why:

- range predicate is more index-friendly than `TRUNC(column)`
- narrow projection reduces row-fetch and covering pressure
- an existing index or a narrower new index may become enough

### 2. Index Change First

Use when:

- query is already SARGable
- projection is already narrow
- endpoint is hot
- current index shape clearly misses predicate/order needs

Example:

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

If the current index is only:

```text
(hospital_id, scheduled_at)
```

candidate adjustment:

```text
(hospital_id, doctor_id, scheduled_at)
```

because the query is already healthy, but the access path misses the `doctor_id` narrowing.

### 3. Schema / Read Model Change

Use when:

- query rewrite plus sane indexing still misses the target
- repeated aggregation is frequent
- a dashboard/reporting query pressures a hot OLTP table
- freshness requirements can be defined

Example:

```sql
SELECT hospital_id, doctor_id, COUNT(*) AS appointment_count
FROM appointments
WHERE scheduled_at >= :month_start
  AND scheduled_at < :next_month_start
  AND status = 'COMPLETED'
GROUP BY hospital_id, doctor_id
ORDER BY appointment_count DESC;
```

If this frequently powers a dashboard while the base table is large and write-hot, consider:

- summary table
- materialized view
- reporting replica/path
- pre-aggregation by day/month

But schema/read-model change is a heavy tool. Prove query/index tuning is not enough first.

### 4. Stats Fix / No Change

Sometimes the index is not wrong. Instead:

- stats are stale
- optimizer does not capture skew
- the table is small and full scan is rational
- the query is cold and not worth extra write tax

Then the right move may be updating stats, adding histogram, or accepting the plan.

## Three-Query Classification

| Case | Main Problem | First Move | Why |
|---|---|---|---|
| `TRUNC(scheduled_at)` + `SELECT *` | query shape | rewrite query / narrow projection | restore SARGability and reduce wasted row fetch |
| SARGable appointment list but missing `doctor_id` in index | index shape | adjust composite index | query is healthy, but access path is not narrow enough |
| frequent monthly aggregation dashboard | workload/schema fit | summary/read model after cheaper fixes | repeated aggregation on a hot OLTP table may not be solved cleanly by one more index |

## What To Measure

Measure before and after:

- execution plan operators
- estimated rows vs actual rows
- rows examined vs rows returned
- logical reads / buffer gets
- physical reads
- whether sort operation disappears
- number of `TABLE ACCESS BY INDEX ROWID` fetches
- endpoint p50 / p95 / p99 latency
- index size
- write latency after index change
- endpoint frequency
- freshness requirement for summary/read model

## Decision Framework

Slow-query triage:

1. Clarify intent
   - What does the endpoint need?
   - Does it need fresh data?
   - Is it top-N or full export?

2. Inspect query shape
   - Is the predicate SARGable?
   - Is projection too wide?
   - Is `ORDER BY` actually required?

3. Inspect plan
   - Is full scan rational?
   - Are there many rowid fetches after index range scan?
   - Are estimated and actual rows far apart?

4. Choose the smallest safe fix
   - rewrite query
   - reduce projection
   - adjust index
   - update stats
   - schema/read-model change

5. Prove the result
   - Did latency drop?
   - Did logical reads drop?
   - Is write tax acceptable?
   - Is the plan stable?

## Interview Pushback

### Why change query before index?

If the predicate is not SARGable, such as `TRUNC(scheduled_at)`, another index may still fail to form a clean range access path. Rewriting to a raw timestamp range is lower risk and may allow an existing index to work.

### Why can one extra index column help reads but hurt writes?

The extra column may make the index covering or better aligned with filter/order, but it widens the index. That increases storage, buffer pressure, page split risk, and the amount of index data maintained on every insert/update/delete.

### Why is `TABLE ACCESS BY INDEX ROWID` sometimes the bottleneck?

It means the engine found matches in the index and then fetched table rows by location. If many rows match and the row locations are scattered, these fetches become random access. The bottleneck is not the index range scan itself but row-fetch fan-out.

### When would you reject a covering index?

If the endpoint is not hot, projection is unstable, the table is write-heavy, or predicate selectivity is weak. A covering index is worth it only when row fetch is a proven bottleneck and read savings beat write tax.

### When does schema change beat index tuning?

When the query is frequent aggregation/reporting, query rewrite and reasonable indexing still miss latency/concurrency goals, and freshness requirements are explicit enough to support a summary table, materialized view, or reporting path.

## Common Mistakes

- Explaining leftmost prefix as "only the first column can be used"
- Saying an unused index means the optimizer is wrong
- Calling every full scan bad
- Forgetting that columns after the first range column may not keep seek narrowing
- Adding projected columns to the index but calling them predicates
- Forgetting that `SELECT *` makes covering index unrealistic
- Ignoring stats/cardinality risk
- Saying "add an index" for every slow query
- Jumping to schema change before cheaper query/index fixes

## 60-90 Second Answer

I design composite indexes from query shape. First I check whether the predicate is SARGable, then I look at equality columns, range or ordering columns, projection width, and write cost. The leftmost-prefix rule is about whether the query can form a contiguous usable leading prefix. Usually equality predicates narrow first, the first range column defines the leaf scan, and columns after the range do not provide the same kind of seek narrowing. If the plan shows `INDEX RANGE SCAN` followed by many `TABLE ACCESS BY INDEX ROWID` operations, the real bottleneck may be scattered row fetches, so a covering index may help only if the endpoint is hot and narrow enough to justify the write tax. If the predicate is not SARGable, I rewrite the query first. If the query is healthy but index order is wrong, I adjust the index. If repeated aggregation pressures a hot OLTP table, I consider a summary or reporting read model.

## 10-15 Minute Deep Dive Path

1. Start with composite index as an ordered access path.
2. Use `(hospital_id, status, scheduled_at)` to explain leftmost prefix.
3. Explain equality, missing leading columns, and first range column effects on seek narrowing.
4. Explain how `ORDER BY` aligns with or breaks against index order.
5. Expand SARGability, especially function-on-column rewrite.
6. Read Oracle-style plan: full scan, index range scan, rowid access.
7. Explain when covering index removes row fetch and when it is not worth it.
8. Classify three queries: query rewrite first, index change first, schema/read-model change first.
9. Close with metrics: rows, logical reads, latency, write impact, stats quality.

## Final Deliverables

You should be able to do three things:

- Given a composite index, decide which queries form a strong leading-prefix seek and which only use it weakly.
- Read a plan and explain what full scan, index range scan, and rowid fetch mean for cost.
- For a slow query, decide whether to change query, index, schema/read model, stats, or accept the plan, then prove it with metrics.
