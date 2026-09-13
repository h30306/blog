---
title: "B+Tree And Index Internals"
summary: "Index reasoning from page reads, access paths, selectivity, and write cost"
description: "Week 5 learning notes: B+Tree, clustered/secondary indexes, index scan vs full scan"
date: 2026-05-05
tags: ["database", "index", "btree", "query-optimization", "storage-engine"]
categories: ["database"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Learning Note Sources

- Day 22: B+Tree structure, page model, point lookup, range scan
- Day 23: clustered vs secondary index, base-table lookup, covering index
- Day 24: index scan vs full table scan, why indexes slow writes
- Day 25 and Day 27: ASUS-style query defense, B+Tree insert and page split review

## Mental Model

An index is not magic acceleration. It is an access path:

```text
search key -> leaf entry -> row locator or row payload
```

The real interview question is whether this path reduces total work compared with scanning the table: fewer page reads, better locality, and fewer scattered row fetches.

## Why B+Tree Fits Databases

Databases optimize for page reads, not elegant pointer chasing. B+Tree-style indexes work well because internal pages contain many sorted keys and child pointers:

```text
high fan-out -> low tree height -> few page reads
```

Ordered leaves also support point lookups, range scans, and ordered traversal. A hash index can be strong for equality lookup, but it does not naturally support range scans.

## Clustered vs Secondary Index

A clustered or primary-style access path is aligned with the row storage. A secondary index usually looks more like:

```text
secondary index lookup -> row locator / primary key -> base table lookup
```

That second hop is often the expensive part. If a predicate matches many rows, the database may perform many scattered base-row fetches after the index scan.

## Covering Index

A covering index contains all columns needed by the query, so the engine may avoid base-table row fetches.

For example, an appointment list endpoint that only needs:

```text
hospital_id, doctor_id, scheduled_at, status, appointment_id
```

might consider:

```text
(hospital_id, doctor_id, scheduled_at, status, appointment_id)
```

But "make it covering" is not automatically a good answer. Wider indexes cost storage, slow writes, and increase buffer pressure.

## Why Full Scan Can Be Correct

A full scan can beat an index when:

- the predicate has weak selectivity
- the query needs a large fraction of the table
- the table is small
- secondary index matches cause many scattered row fetches
- statistics or cardinality estimates make the index path look more expensive

The safer phrasing is:

```text
I would compare total access cost, not just whether an index exists.
```

## Why Indexes Slow Writes

Every extra index must be maintained during `INSERT`, `DELETE`, or indexed-column `UPDATE`.

That means:

- more page writes
- possible page splits
- more redo / WAL / logging
- more buffer churn
- more lock or latch contention risk

Each index must earn its place against read improvement and write cost.

## What To Measure

- plan shape: index scan, rowid lookup, full scan
- estimated rows vs actual rows
- rows examined vs rows returned
- logical reads / buffer gets
- p95 and p99 latency by endpoint
- write latency after adding an index
- index size and cache hit ratio

## 60-90 Second Answer

An index is an access path, not a free speedup. B+Tree indexes fit databases because high fan-out keeps tree height low and ordered leaves support equality, range, and ordered scans. A secondary index can still be expensive because after matching index entries, the engine may need scattered base-table lookups. If the predicate is low-selectivity or the query returns many rows, a full scan can be cheaper. Covering indexes can remove that extra row fetch, but wider indexes increase write cost and storage, so I would validate with plan shape, rows examined, logical reads, latency, and write impact.
