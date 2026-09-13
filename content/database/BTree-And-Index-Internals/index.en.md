---
title: "B+Tree And Index Internals"
summary: "Index reasoning through page reads, access paths, selectivity, row fetches, and write tax"
description: "Database review notes for B+Tree, clustered/secondary access paths, covering indexes, full scans, page splits, write amplification, and query plan reasoning"
date: 2026-05-05
tags: ["database", "index", "btree", "query-optimization", "storage-engine", "query-plan"]
categories: ["database"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Review Points

- An index is not magic acceleration; it is an access path
- Why B+Tree fits databases: page model, fan-out, height, and ordered leaves
- Point lookup, range scan, and ordered traversal
- Clustered / primary-style access path vs secondary / non-clustered access path
- Secondary-index row locator / primary-key lookup / base-table fetch cost
- Why covering indexes can change the cost shape
- Selectivity, cardinality, projection width, and full-scan reasoning
- B+Tree insert, leaf split, separator propagation, and root split
- Why indexes slow writes: page splits, redo/WAL, buffer churn, and write amplification
- How to defend a hospital-style query index end to end

## Tier A/S Readiness

If your answer is only:

```text
Indexes make queries faster because B+Tree search is O(log n).
```

that is not enough. A Tier A/S backend interview keeps pushing:

- Is the unit inside `O(log n)` a CPU comparison or a page read?
- After a secondary-index leaf entry is found, is the query done?
- Why can `SELECT *` make an index plan lose to a full scan?
- Why does a B+Tree support range scan while a hash index does not?
- Why can a random UUID primary key make writes more painful?
- If a teammate asks for a new index on a slow query, how do you prove it is worth it?

A strong answer moves through:

```text
query shape -> access path -> page reads -> row fetch cost -> write tax -> production metrics
```

## Mental Model

Do not describe an index as:

```text
index makes query faster
```

A better model:

```text
index = a separate access structure
search key -> leaf entry -> row locator or row payload
```

The real comparison is:

```text
index path total cost vs full scan total cost
```

Total cost often comes from:

- routing page reads
- leaf page scan
- base-table row fetches
- locality / random I/O
- sort avoidance
- projection width
- write maintenance cost

## Page Model

Databases usually read storage in pages or blocks, not one abstract tree node at a time.

So the interview answer should not stop at "balanced tree." Say:

```text
databases optimize page reads and locality, not pointer-chasing elegance
```

Internal pages store sorted separator keys and child pointers. Leaf pages store ordered index entries.

High fan-out means:

```text
one page can route to many child pages
```

Therefore:

```text
high fan-out -> low tree height -> few page reads
```

That is the core reason B+Tree / B+Tree-like indexes are common in databases.

## Why B+Tree Fits Databases

B+Tree-style indexes support:

- exact lookup: `WHERE appointment_id = ?`
- range scan: `WHERE scheduled_at >= ? AND scheduled_at < ?`
- ordered traversal: `ORDER BY scheduled_at`
- prefix and range behavior in composite indexes

Hash indexes can be strong for equality lookup, but they do not preserve key order, so they do not naturally support range scans or ordered traversal.

Interview-safe summary:

```text
Hash can be strong for exact-match lookup, but relational workloads often need equality, range, and ordered access, so B+Tree is the better general-purpose default.
```

## Search Path

A B+Tree / B+Tree-like lookup can be explained as:

```text
root page -> internal page(s) -> leaf page -> maybe base-table row fetch
```

Point lookup:

```sql
SELECT *
FROM appointments
WHERE appointment_id = :id;
```

Range scan:

```sql
SELECT appointment_id, scheduled_at
FROM appointments
WHERE hospital_id = :hospital_id
  AND scheduled_at >= :start_time
  AND scheduled_at < :end_time
ORDER BY scheduled_at;
```

The important range-scan behavior:

```text
seek once to the first matching leaf entry, then scan forward through ordered leaf entries
```

This is the hidden superpower of B+Tree.

## Toy B+Tree

Use a tiny toy tree for whiteboard interviews. Assume each leaf page holds at most `3` keys:

```text
                [24 | 44 | 63]
               /      |      |      \
 [5, 12, 18] [24, 31, 37] [44, 50, 57] [63, 71, 84]
```

Search key `50`:

1. Inspect root page `[24 | 44 | 63]`
2. `50 >= 44 and < 63`, so follow the third child
3. Reach leaf `[44, 50, 57]`
4. Find key `50`
5. If this is a secondary index and the query needs columns outside the index, continue to a base-table lookup
6. If the query is covered by the index, stop at the index

Strong line:

```text
The expensive part is often not the tree traversal itself; it is page reads plus any extra base-row fetches after the leaf hit.
```

## Insert And Page Split

Using the same toy tree, insert key `52`.

Route to the leaf:

```text
[44, 50, 57]
```

After insert:

```text
[44, 50, 52, 57]
```

The leaf overflows, so split it:

```text
[44, 50] and [52, 57]
```

Promote separator `52` to the parent:

```text
[24 | 44 | 52 | 63]
```

If the parent is full too, split upward and possibly split the root:

```text
                      [52]
                    /      \
              [24 | 44]    [63]
             /    |    \    /   \
 [5,12,18] [24,31,37] [44,50] [52,57] [63,71,84]
```

Tie it back to production:

- an insert is not just appending one row
- it may modify a leaf page
- it may split a page
- it may update a parent separator
- it may split the root
- every secondary index must perform its own maintenance

This is the concrete intuition behind indexes speeding reads but slowing writes.

## Clustered vs Secondary Access Path

Different database engines use different terminology, so explain access paths instead of forcing every engine into one implementation.

### Clustered / Primary-Style

Safe wording:

```text
the primary access path is aligned with row storage, or the leaf gets you directly to the row with strong locality
```

Common effects:

- primary-key point lookups are cheap
- range scans on the clustered order have better locality
- the leaf-level path is close to the base row

### Secondary / Non-Clustered

Safe wording:

```text
secondary index is a separate structure whose leaf entries usually point to the base row by row locator or primary key
```

Common access path:

```text
secondary index lookup -> row locator / primary key -> base-table fetch
```

This extra hop is called:

- key lookup
- bookmark lookup
- back-to-table lookup
- hui biao

Many slow indexed queries are not expensive because of the few B+Tree routing levels. They are expensive because the secondary leaf matches many entries and then triggers many scattered base-row fetches.

## Engine-Specific Wording

Use this wording to avoid overclaiming:

```text
The exact storage detail depends on the engine. InnoDB secondary indexes point through the primary key, SQL Server has clustered/nonclustered terminology, and Oracle heap-table indexes commonly point to rows through rowids. The portable point is the access path: does the leaf contain what the query needs, or does it require another base-row lookup?
```

That is safer than saying every database's clustered index behaves the same way.

## Covering Index

A covering index means:

```text
for this specific query, the index contains all columns needed by filter, order, and projection
```

It turns:

```text
index lookup -> base-table lookup
```

into:

```text
index-only or mostly index-only access
```

Example:

```sql
SELECT hospital_id, scheduled_at, status, appointment_id
FROM appointments
WHERE hospital_id = :hospital_id
  AND scheduled_at >= :start_time
  AND scheduled_at < :end_time
ORDER BY scheduled_at
FETCH FIRST 50 ROWS ONLY;
```

Possible covering shape:

```text
(hospital_id, scheduled_at, status, appointment_id)
```

But do not treat covering index as a free answer. It creates:

- wider index pages
- more storage
- more buffer/cache pressure
- more write amplification
- more page split risk
- more expensive indexed-column updates

Interview-safe statement:

```text
Covering is query-dependent. I would widen the index only if the endpoint is hot, the projection is stable, and production metrics show base-row fetch cost dominates.
```

## Selectivity And Cardinality

Cardinality:

```text
how many distinct values a column has
```

Selectivity:

```text
how much a predicate narrows the rows
```

High cardinality often helps, but the optimizer really cares about the selectivity of this predicate in this query.

Example:

```sql
WHERE status = 'ACTIVE'
```

If 95% of rows are `ACTIVE`, the predicate has weak selectivity. Even with an index on `status`, the index path may not be worth using.

## Why Full Scan Can Win

A full scan is not automatically a bad plan. It can win when:

- the predicate matches a large share of rows
- the table is small
- the query needs most columns or `SELECT *`
- the secondary-index plan causes many scattered base-row fetches
- stale statistics make the optimizer misestimate row counts
- scanning is more sequential and has better locality

Core sentence:

```text
An index is only faster when total access cost is lower, not because an index exists.
```

Bad index case:

```sql
SELECT *
FROM appointments
WHERE status = 'OPEN';
```

If `OPEN` is common:

```text
secondary index scan -> many matching entries -> many scattered base-table fetches
```

This may be slower than a full scan.

Good index case:

```sql
SELECT patient_id, created_at
FROM appointments
WHERE patient_id = :patient_id
ORDER BY created_at DESC
FETCH FIRST 20 ROWS ONLY;
```

With a matching index:

```text
(patient_id, created_at)
```

it may:

- equality-seek to one patient
- perform an ordered leaf scan
- stop early after 20 rows
- become covering because the projection is narrow

## SARGability

SARGable can be explained practically:

```text
the predicate can be mapped cleanly to an index key lookup or key-range lookup
```

Bad shape:

```sql
WHERE DATE(created_at) = DATE '2026-05-12'
```

Applying a function to the indexed column can prevent the optimizer from using the original ordered index as a direct range seek.

Better shape:

```sql
WHERE created_at >= TIMESTAMP '2026-05-12 00:00:00'
  AND created_at <  TIMESTAMP '2026-05-13 00:00:00'
```

Common index killers:

- function on indexed column
- implicit type conversion
- leading wildcard: `LIKE '%abc'`
- broad `OR`
- negative predicate: `status != 'DELETED'`
- low-selectivity predicate

## Hospital Query

Assume a hospital scheduling endpoint:

```sql
SELECT appointment_id, scheduled_at, status
FROM appointments
WHERE hospital_id = :hospital_id
  AND scheduled_at >= :start_time
  AND scheduled_at < :end_time
ORDER BY scheduled_at
FETCH FIRST 50 ROWS ONLY;
```

First reasonable index:

```text
(hospital_id, scheduled_at)
```

Why:

- `hospital_id = ?` is a tenant/hospital equality filter
- `scheduled_at` is the range predicate
- `ORDER BY scheduled_at` can follow leaf order
- `FETCH FIRST 50` makes early-stop behavior useful

Expected access path:

```text
seek to first (hospital_id, start_time)
-> ordered leaf scan within hospital/time range
-> stop at end_time or 50 rows
-> fetch base rows only if projected columns are not covered
```

If the endpoint is hot and the projection is stable, consider:

```text
(hospital_id, scheduled_at, status, appointment_id)
```

That may become a covering index. But I would first confirm:

- whether p95 latency is really dominated by row fetches
- rows examined vs rows returned
- whether logical reads drop
- whether write latency remains acceptable
- whether index size and cache pressure are reasonable

## Bad Index Choice

If the proposed index is:

```text
(scheduled_at, hospital_id)
```

it is usually weaker for the query above, because the DB may need to scan the time range across all hospitals before filtering `hospital_id`.

Safer explanation:

```text
For this endpoint, hospital_id first narrows to one tenant, and scheduled_at next gives the ordered range scan inside that tenant.
```

This is not a universal "equality before range" slogan. It is access-path reasoning for this query shape.

## Why Indexes Slow Writes

Every extra index is a permanent tax on the write path.

`INSERT`:

- insert base row
- insert entry into every relevant index
- maybe split leaf pages
- write redo/WAL/log

`DELETE`:

- remove or mark base row
- remove or mark index entries
- generate undo/redo/log work

indexed-column `UPDATE`:

- often remove old index entry
- insert new index entry
- maybe touch different pages

Operational cost:

- more page writes
- page split / fragmentation
- more buffer churn
- more storage
- more redo/WAL volume
- higher p95 / p99 write latency
- higher lock/latch contention risk on hot pages

So production systems should not add indexes endlessly just because one query is slow.

## Primary Key Choice: Auto-Increment vs Random UUID

Auto-increment-like keys are usually more write-friendly:

- new rows mostly append near the right edge
- better locality
- fewer scattered writes
- lower split / fragmentation pressure

Random UUID:

- values spread across the key space
- inserts land in many pages
- more random page writes
- more split / fragmentation pressure

But UUIDs are not simply wrong. They provide:

- distributed uniqueness
- independent ID generation
- harder-to-enumerate public IDs
- less coordination across writers

Safe answer:

```text
Auto-increment keys are usually friendlier for B+Tree write locality, while random UUIDs trade locality for distributed ID-generation benefits.
```

## What Breaks At Scale

- low-selectivity secondary index scans become scattered row-fetch storms
- broad `SELECT *` makes projection width dominate
- stale stats make the optimizer choose unstable plans
- hot tenant / hot time window creates skew
- too many indexes increase write latency and storage
- random keys increase page churn
- one index helps a rare report but hurts hot transactional writes
- data distribution changes and yesterday's good plan becomes today's bad plan

## What To Log Or Measure

Read/query side:

- execution plan shape
- estimated rows vs actual rows
- rows examined vs rows returned
- logical reads / consistent gets / buffer gets
- physical reads when cache misses matter
- sort operation present or avoided
- table access by rowid / bookmark lookup count
- p50 / p95 / p99 latency by endpoint

Write side:

- insert/update/delete p95 / p99 after adding an index
- index size growth
- redo/WAL/log volume
- page split / fragmentation indicators if available
- buffer cache hit ratio
- lock/latch contention on hot indexes

Strong line:

```text
I would not stop at EXPLAIN; I would confirm that the production read win is larger than the write tax.
```

## Decision Framework

When a query is slow, do not immediately add an index. Ask:

1. Query shape
   - Is the predicate selective?
   - Is the projection narrow?
   - Can the index satisfy the sort/order?
   - Is the predicate SARGable?

2. Plan and data
   - How far off are estimated rows vs actual rows?
   - How far apart are rows examined vs rows returned?
   - Are there many base-table lookups?
   - Are statistics stale?

3. Workload
   - Is the endpoint hot?
   - Is the table read-heavy or write-heavy?
   - Will this index hurt hot writes?

4. Lever
   - rewrite query
   - narrow endpoint projection
   - adjust or add index
   - update statistics
   - change schema / read model
   - only consider cache after query/index shape is already sane

## Interview Pushback

### Why B+Tree instead of hash as default?

Hash indexes are strong for exact equality lookup, but they do not preserve order, so they are poor for range queries, ordered scans, and `ORDER BY`. B+Tree keeps keys sorted, uses high fan-out internal pages, and has ordered leaves, so it supports equality, range, and ordering. That makes it a better general-purpose index for relational workloads.

### What is key lookup / hui biao?

A secondary-index leaf usually does not contain the full row. It contains the indexed key and a row locator or primary key. If the query needs other columns, the DB must go back to the base table to fetch the row. That extra step is key lookup / bookmark lookup / hui biao. It becomes the dominant cost when many rows match and the row fetches are scattered.

### Why can full scan beat index?

An index is faster only when total access cost is lower. If the predicate has weak selectivity, the query needs many rows, or the query uses `SELECT *`, a secondary index may match many entries and then perform many scattered base-table fetches. A full scan can be cheaper because it reads the table more sequentially.

### When is covering index worth it?

When the query is hot, the predicate is selective, the projection is stable and narrow, and metrics show that base-table lookup is the bottleneck. Otherwise, widening the index increases storage, cache pressure, and write amplification, so it may not be worth it.

### Why can random UUID hurt writes?

B+Tree must maintain key order. Auto-increment keys usually append near the right edge, which has better locality. Random UUID values are spread across the key space, so new inserts can land in many different pages, causing more random writes, page churn, page splits, and fragmentation. UUIDs are useful for distributed uniqueness, but they trade away write locality.

## Common Mistakes

- Saying only `O(log n)` without page reads
- Saying an index should be used because it exists
- Forgetting that secondary indexes may require base-table lookups
- Forgetting that `SELECT *` multiplies row-fetch cost
- Treating covering index as always correct
- Saying full scan is always a bad plan
- Treating high-cardinality-first as an absolute rule instead of query-shape reasoning
- Forgetting that every index slows writes
- Saying UUIDs are bad without naming the distributed-ID trade-off

## 60-90 Second Answer

An index is an access path, not a free speedup. Databases use B+Tree-style indexes because they route through pages with high fan-out, keeping tree height low and page reads small, and because ordered leaf entries support point lookup, range scan, and ordered traversal. The real question is total access cost. If the predicate is selective, the projection is narrow, and ordering lines up with the index, the index likely wins. But a secondary index often still needs a row locator lookup back to the base table, so broad `SELECT *` queries or low-selectivity predicates can create many scattered row fetches and make a full scan cheaper. Covering indexes can remove the extra lookup, but they increase storage, cache pressure, and write amplification, so I would validate the index with execution plan shape, estimated vs actual rows, logical reads, p95 latency, and write impact.

## 10-15 Minute Deep Dive Path

1. Start with index as access path, not magic acceleration.
2. Draw B+Tree pages: root, internal pages, leaves; do not draw a plain BST.
3. Explain fan-out, height, point lookup, and range scan.
4. Walk one search path and mention that a leaf hit may still require base-table lookup.
5. Walk one insert and page split, then tie it to write amplification.
6. Compare clustered/primary-style vs secondary access paths.
7. Explain covering index, selectivity, and projection width.
8. Defend `(hospital_id, scheduled_at)` for a hospital scheduling query.
9. Explain when the optimizer may prefer a full scan.
10. Close with metrics: plan, rows, logical reads, latency, and write tax.

## Final Deliverables

You should be able to do three things:

- Draw B+Tree root/internal/leaf pages and walk point lookup, range scan, and insert split.
- For a hospital-style query, explain index shape, access path, covering vs row fetch, and why the optimizer may not use it.
- Answer pushback about full scans, secondary indexes, covering indexes, UUIDs, and write amplification instead of only saying "add an index."
