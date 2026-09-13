---
title: "LeetCode 198: House Robber"
summary: "LeetCode 解題筆記：House Robber"
description: "2026-05-17 的 LeetCode 學習紀錄"
date: 2026-05-17
tags: ["medium", "dynamic-programming"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-05-17
來源筆記：`notes/day22-week5-day1-stock-i-ii-btree-index-internals.md`

## 解題思路

這篇整理 House Robber 的解題筆記，重點放在 1D DP / choose-skip recurrence、狀態定義、轉移式與容易犯錯的地方。

## 解法

以下內容整理自當天的 learning note，保留英文關鍵句，方便之後直接拿來做面試口說複習。

- **Pattern:** 1D DP / choose-skip recurrence.

## Why This Review Matters
Week 5 starts a harder DP derivation week, so one stable 1D DP review keeps the baseline clean:
```text
dp[i] = max(dp[i - 1], nums[i] + dp[i - 2])
```

## Interview-Ready Explanation
For each house, I either skip it and keep the best result up to `i - 1`, or rob it and add `nums[i]` to the best result up to `i - 2`. The recurrence is a clean choose-vs-skip DP.

## Topic - B+Tree And Index Internals

## First Judgment
Knowing only:
```text
index makes query faster
```

is far below Tier A/S mid-level bar.

The real bar is:
- what an index actually stores
- why the default structure is B+Tree-style
- why point lookup and range scan behave differently
- why a secondary-index lookup can still be expensive
- when a full scan is better than an index
- why some query shapes block index usage
- why indexes help reads but hurt writes

## What A Strong Mid-Level Candidate Must Know
- index as a separate structure, not the table itself
- `search key -> row locator` mental model
- page / block model and why DBs optimize page reads
- B+Tree vs hash index
- point lookup vs range scan
- clustered / primary-style vs secondary / non-clustered intuition
- `key lookup` / `bookmark lookup` / `hui biao`
- covering index
- selectivity and cardinality intuition
- why full scan can beat index
- SARGability and common index-killers
- page split, write amplification, and PK choice trade-offs

## Core Mental Model

### What An Index Is
An index is a separate access structure built on one or more columns.

Conceptually:
```text
indexed key -> row locator
```

Without an index, the DB may scan table rows one by one.

With an index, the DB can narrow quickly toward relevant rows instead of reading large amounts of irrelevant data.

### What The Index Usually Does Not Store
The index often does not store the full row.

That means many queries are really:
```text
index lookup -> row locator -> base table lookup
```

This is the foundation for understanding secondary-index cost.

## Why B+Tree, Not Just "Some Tree"

### Why Databases Do Not Think Like A Normal BST
The storage engine is not optimizing for pointer-chasing elegance.

It is optimizing for:
```text
few page reads, high locality, and ordered traversal
```

### Why B+Tree Fits
Each internal page stores many sorted keys and child references, which gives:
```text
high fan-out -> low tree height -> few page reads
```

This is the real reason B+Tree-style indexes are common.

### B+Tree Vs Hash
Hash index:
- strong for exact equality lookup
- does not preserve order
- weak for range scans and ordered traversal

B+Tree:
- supports exact lookup
- preserves order
- supports range scan and ordered access

Interview-safe summary:
```text
Relational databases prefer B+Tree as the default because workloads need both equality lookup and ordered/range access, while hash is mainly for exact-match queries.
```

## Pages, Search Path, And Range Behavior

### Page Mental Model
A page is the DB's fixed-size storage/read unit.

B+Tree nodes are page-shaped routing blocks.

Internal pages:
- route the search by key range

Leaf pages:
- hold final indexed entries in sorted order

### Search Path
```text
root page -> internal page(s) -> leaf page -> row locator -> maybe base table row
```

### Point Lookup
Example:
```sql
SELECT * FROM patients WHERE patient_id = 123;
```

The DB navigates to one exact leaf position.

### Range Scan
Example:
```sql
WHERE created_at >= ? AND created_at < ?
ORDER BY created_at
```

The DB navigates once to the start of the range, then scans forward through ordered leaf entries.

This ordered leaf behavior is the hidden superpower of B+Tree.

## Clustered Vs Secondary Intuition

### Clustered / Primary-Style
The base row layout is aligned with the key order, or tightly coupled to it.

This usually gives better locality for ordered/range-heavy reads.

### Secondary / Non-Clustered
The index is separate and usually stores:
```text
search key + row locator / primary key reference
```

So after the index finds a match, the DB may still need to fetch the base row.

This is where `key lookup` / `bookmark lookup` / `hui biao` comes from.

## Covering Index And Extra Lookup Cost

### What Key Lookup Means
In a secondary index, the engine may find matching index entries first, then go back to the base table to fetch columns not available in the index.

That extra step is:
- `key lookup`
- `bookmark lookup`
- `hui biao`

### Why It Gets Expensive
If many rows match, the DB may have to do many extra row fetches with poor locality.

### What A Covering Index Means
A covering index contains all columns needed for that specific query.

That turns:
```text
index lookup + base table lookup
```

into:
```text
index lookup only
```

This reduces extra page reads and random I/O.

Important nuance:
```text
"Covering" depends on the query, not only on the index definition.
```

## Selectivity, Cardinality, And Why Full Scan Can Win

### Cardinality
```text
how many distinct values a column has
```

### Selectivity
```text
how much a specific predicate narrows the result set
```

High cardinality can help, but the optimizer really cares about predicate selectivity.

### Why Index Exists Does Not Mean Index Is Best
If a predicate matches a large share of the table:
- index traversal still happens
- many base-row fetches may still happen
- those fetches may be scattered

At that point, a full table scan can be cheaper because it is more sequential.

Interview-safe summary:
```text
A full scan can beat an index when the predicate is low-selectivity and index traversal plus many scattered row fetches costs more than reading the table once sequentially.
```

## SARGability And Common Index-Killers

### What SARGable Means
In practice:
```text
the predicate can be mapped cleanly to an index key lookup or key-range lookup
```

### Good Predicate Shape
```sql
WHERE created_at >= '2026-05-12 00:00:00'
  AND created_at <  '2026-05-13 00:00:00'
```

### Common Index-Killers
- function on indexed column:
  - `WHERE DATE(created_at) = '2026-05-12'`
- leading wildcard:
  - `LIKE '%tan%'`
- implicit type conversion
- broad `OR`
- very weak predicates such as:
  - `status != 'DELETED'`
  - `status = 'ACTIVE'` when most rows are active

### Why Function-On-Column Hurts
If you wrap the indexed column in a function, the optimizer often cannot use the original ordered index as a direct searchable range.

Better rewrite:
```sql
WHERE created_at >= '2026-05-12 00:00:00'
  AND created_at <  '2026-05-13 00:00:00'
```

## Why Indexes Speed Reads But Slow Writes

### Read Benefit
Indexes reduce unnecessary search work and page reads for the right query shape.

### Write Cost
Every insert, update, and delete must also maintain the index structure.

That means:
- more writes
- more maintenance
- more storage

### Page Split
If a target leaf page is full, the DB may need to split the page to keep keys ordered.

This is one source of write amplification.

## Primary Key Choice: Auto-Increment Vs UUID

### Auto-Increment
Usually gives better insertion locality because new rows land near the rightmost edge of the B+Tree.

Benefits:
- more sequential insert pattern
- fewer scattered page writes
- lower page-split/fragmentation pressure

### Random UUID
Can land anywhere in the key space.

Costs:
- more scattered inserts
- more random I/O
- higher page-split and fragmentation risk

### Trade-Off
UUID is still useful for:
- distributed uniqueness
- independent ID generation
- harder-to-enumerate public IDs

Interview-safe summary:
```text
Auto-increment keys are usually more write-friendly in B+Tree-organized storage, while random UUIDs trade write locality for distributed ID-generation benefits.
```

## Gold-Standard Interview Answers

## 1. Why B+Tree Instead Of Hash As Default?
```text
Hash indexes are mainly useful for exact equality lookups, but they do not preserve key order, so they are poor for range queries, ORDER BY, and ordered scans. B+Tree indexes keep keys in sorted order and store many keys per page, which gives high fan-out and keeps lookups shallow in terms of page reads. Because relational workloads need not only equality lookup but also range filtering and ordered traversal, B+Tree is usually the better default general-purpose index structure.
```

## 2. What Is Key Lookup / Hui Biao?
```text
In a secondary index, the index usually stores the indexed key plus a row locator or primary key reference, not the full row. After the database finds matching index entries, it may still need to go back to the base table to fetch the remaining columns the query needs. That extra step is called key lookup or hui biao. It becomes expensive when many rows match, because the engine has to perform many additional row fetches, often with poor locality.
```

## 3. Why Can Full Scan Beat An Index?
```text
A full table scan can be faster when the predicate has low selectivity, meaning it matches a large share of the table. In that case, using the index may still require the database to fetch many base table rows after finding the index entries, especially for a secondary index. Those row fetches can be scattered and cause a lot of random I/O. By contrast, a full table scan reads the table more sequentially, which can be cheaper when a large percentage of rows are needed anyway.
```

## 4. What Makes A Predicate SARGable?
```text
A predicate is SARGable when the database can use it directly as an index search argument, typically by exact key lookup or key-range lookup. When we write DATE(created_at) = '2026-05-12', we apply a function to the indexed column, so the optimizer often cannot use the original ordered index on created_at efficiently. The better rewrite is created_at >= '2026-05-12 00:00:00' AND created_at < '2026-05-13 00:00:00', because that keeps the predicate in a direct range form the B+Tree index can use.
```

## 5. Why Is A Covering Index Faster?
```text
A covering index means the index already contains all the columns needed for a specific query, including the filter and returned columns. That allows the database to satisfy the query from the index alone without going back to the base table for an extra key lookup. It helps because it reduces additional page reads and random I/O, which lowers latency, especially for frequent read queries on secondary indexes.
```

## 6. Why Auto-Increment Often Beats Random UUID For Write Locality
```text
Auto-increment primary keys usually produce better insertion locality because each new key is larger than the previous one, so inserts tend to land near the rightmost edge of the B+Tree. That makes writes more sequential and reduces scattered page modifications. Random UUIDs still need to be inserted in sorted order, but because their values are distributed across the key space, new rows can land in many different pages, which increases random I/O, page-split frequency, and fragmentation risk. The trade-off is that UUIDs are often better for distributed uniqueness and independent ID generation.
```

## 7. Proposed Index For The ASUS/Hospital Query
Query:
```sql
SELECT hospital_id, appointment_time, status
FROM appointments
WHERE hospital_id = 10
  AND appointment_time >= '2026-05-12 00:00:00'
  AND appointment_time < '2026-05-13 00:00:00'
ORDER BY appointment_time;
```

Strong answer:
```text
I would propose an index on (hospital_id, appointment_time, status). The query first filters by hospital_id with equality, then scans a time range inside that hospital, and finally orders by appointment_time. Putting hospital_id first lets the index narrow to one tenant, and putting appointment_time next lets the database do an ordered range scan without needing an extra sort. Including status makes this a covering index for this specific query and avoids extra base-table lookups.
```

## 8. Why Is `status = 'ACTIVE'` Often A Weak Index Predicate?
```text
Status is often a weak index predicate because it usually has low selectivity, meaning the condition does not narrow the result set very much. If most rows are ACTIVE, then using the index may still require the database to fetch a large number of base table rows after finding the matching index entries. Those extra row fetches can be scattered and expensive, so the optimizer may decide that a sequential full table scan is cheaper.
```

## What To Be Able To Draw
- a B+Tree with:
  - root page
  - one internal page level
  - ordered leaf pages
- one point-lookup path from root to leaf
- one range-scan path that starts at a leaf and continues forward
- one secondary-index lookup with extra base-table fetch
- one covering-index lookup that avoids the extra fetch

## What To Be Able To Explain Without Notes
- why DBs optimize page reads instead of pointer-chasing BST logic
- why B+Tree is the default relational index structure
- why ordered leaves matter
- why full scan can still be the best plan
- why some query shapes block index usage
- why indexes are a read/write trade-off

## Common Mistakes To Avoid
- saying only `O(1)` or `O(log n)` without discussing page reads and access patterns
- saying `index exists so it should be used`
- using `high cardinality first` as a universal index-order rule
- forgetting that covering index is query-dependent
- saying `UUID bad` without stating the distributed-ID trade-off
- calling every slow indexed query a DB bug instead of checking selectivity and query shape

## Tomorrow Drill Targets
- re-answer all 8 gold-standard questions without notes
- speak slower and use cost-based wording:
  - `selectivity`
  - `page reads`
  - `ordered traversal`
  - `extra base-table lookup`
  - `lower total cost`

## 收穫

- 先講清楚 state meaning，再寫 recurrence。
- base case、迴圈方向、return value 要在 coding 前確認。
- 如果是 DP 壓縮、graph traversal、或 greedy frontier，要能說出 invariant 為什麼成立。

## 遇到的問題

原始筆記沒有另外紀錄失誤點。
