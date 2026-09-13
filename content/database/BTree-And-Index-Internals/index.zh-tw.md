---
title: "B+Tree And Index Internals"
summary: "從 page read、access path、selectivity、row fetch 和 write tax 重新整理 index 心智模型"
description: "B+Tree、clustered/secondary access path、covering index、full scan、page split、write amplification 與 query plan reasoning 的資料庫複習筆記"
date: 2026-05-05
tags: ["database", "index", "btree", "query-optimization", "storage-engine", "query-plan"]
categories: ["database"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 複習重點

- Index 不是魔法加速器，而是一條 access path
- B+Tree 為什麼適合 database：page model、fan-out、height、ordered leaf
- Point lookup、range scan、ordered traversal 的差異
- Clustered / primary-style access path vs secondary / non-clustered access path
- Secondary index 的 row locator / primary key lookup / base-table fetch 成本
- Covering index 為什麼能改變成本形狀
- Selectivity、cardinality、projection width、full scan reasoning
- B+Tree insert、leaf split、separator propagation、root split
- Index 為什麼讓 writes 變慢：page split、redo/WAL、buffer churn、write amplification
- 如何用 ASUS / hospital-style query 做完整 index defense

## Tier A/S 判斷

如果回答只是：

```text
Index makes query faster because B+Tree search is O(log n).
```

這還不夠。Tier A/S backend 面試會繼續追：

- `O(log n)` 裡的單位是 CPU comparison，還是 page read？
- secondary index leaf 找到 entry 後，query 結束了嗎？
- 為什麼 `SELECT *` 可能讓 index plan 輸給 full scan？
- 為什麼 B+Tree 支援 range scan，而 hash index 不適合？
- 為什麼 random UUID primary key 可能讓 writes 更痛？
- 如果 teammate 要你替慢查詢加 index，你怎麼證明值得？

強回答要從：

```text
query shape -> access path -> page reads -> row fetch cost -> write tax -> production metrics
```

一路講到可防守。

## Mental Model

不要把 index 講成：

```text
index makes query faster
```

比較成熟的心智模型：

```text
index = a separate access structure
search key -> leaf entry -> row locator or row payload
```

真正要比較的是：

```text
index path total cost vs full scan total cost
```

總成本通常來自：

- routing page reads
- leaf page scan
- base-table row fetches
- locality / random I/O
- sort avoidance
- projection width
- write maintenance cost

## Page Model

Database 通常不是一筆一筆從 disk 讀資料，而是以 page / block 為單位讀。

所以 B+Tree 面試回答不要只說「balanced tree」，而要說：

```text
databases optimize page reads and locality, not pointer-chasing elegance
```

Internal pages 存 sorted separator keys 和 child pointers。Leaf pages 存 ordered index entries。

高 fan-out 的意思是：

```text
one page can route to many child pages
```

因此：

```text
high fan-out -> low tree height -> few page reads
```

這才是 B+Tree / B+Tree-like index 在 database 裡常見的核心原因。

## Why B+Tree Fits Databases

B+Tree-style indexes 同時支援：

- exact lookup: `WHERE appointment_id = ?`
- range scan: `WHERE scheduled_at >= ? AND scheduled_at < ?`
- ordered traversal: `ORDER BY scheduled_at`
- prefix/range behavior in composite indexes

Hash index 通常很適合 equality lookup，但不保留 key order，所以不天然支援 range scan 或 ordered traversal。

面試安全說法：

```text
Hash can be strong for exact-match lookup, but relational workloads often need equality, range, and ordered access, so B+Tree is the better general-purpose default.
```

## Search Path

一個 B+Tree / B+Tree-like lookup 可以這樣講：

```text
root page -> internal page(s) -> leaf page -> maybe base-table row fetch
```

Point lookup：

```sql
SELECT *
FROM appointments
WHERE appointment_id = :id;
```

Range scan：

```sql
SELECT appointment_id, scheduled_at
FROM appointments
WHERE hospital_id = :hospital_id
  AND scheduled_at >= :start_time
  AND scheduled_at < :end_time
ORDER BY scheduled_at;
```

Range scan 的重要點：

```text
seek once to the first matching leaf entry, then scan forward through ordered leaf entries
```

這是 B+Tree 的 hidden superpower。

## Toy B+Tree

用一個很小的 toy tree 畫面試白板。假設 leaf page 最多放 `3` 個 keys：

```text
                [24 | 44 | 63]
               /      |      |      \
 [5, 12, 18] [24, 31, 37] [44, 50, 57] [63, 71, 84]
```

Search key `50`：

1. 看 root page `[24 | 44 | 63]`
2. `50 >= 44 and < 63`，走第三個 child
3. 到 leaf `[44, 50, 57]`
4. 找到 key `50`
5. 如果是 secondary index，而且 query 需要 index 外欄位，繼續做 base-table lookup
6. 如果 query 被 covering index 滿足，就可以停在 index

強句：

```text
The expensive part is often not the tree traversal itself; it is page reads plus any extra base-row fetches after the leaf hit.
```

## Insert And Page Split

沿用 toy tree，insert key `52`。

先 route 到 leaf：

```text
[44, 50, 57]
```

插入後：

```text
[44, 50, 52, 57]
```

leaf overflow，split：

```text
[44, 50] and [52, 57]
```

promote separator `52` 到 parent：

```text
[24 | 44 | 52 | 63]
```

如果 parent 也滿了，就繼續 split，甚至 root split：

```text
                      [52]
                    /      \
              [24 | 44]    [63]
             /    |    \    /   \
 [5,12,18] [24,31,37] [44,50] [52,57] [63,71,84]
```

這段要能講出 production 意義：

- insert 不是只 append 一筆資料
- 可能改 leaf page
- 可能 split page
- 可能更新 parent separator
- 可能 root split
- 每個 secondary index 都要做自己的維護

這就是 indexes speed reads but slow writes 的底層直覺。

## Clustered vs Secondary Access Path

不同 database engine 術語不完全一樣，所以面試要講 access path，不要硬套某一家實作。

### Clustered / Primary-Style

安全說法：

```text
the primary access path is aligned with row storage, or the leaf gets you directly to the row with strong locality
```

常見效果：

- primary key point lookup 很便宜
- range scan on clustered order 有比較好的 locality
- leaf-level path 接近 base row

### Secondary / Non-Clustered

安全說法：

```text
secondary index is a separate structure whose leaf entries usually point to the base row by row locator or primary key
```

常見 access path：

```text
secondary index lookup -> row locator / primary key -> base-table fetch
```

這個 extra hop 就是：

- key lookup
- bookmark lookup
- back-to-table lookup
- hui biao

很多慢查詢真正貴的不是 B+Tree routing 那幾層，而是 secondary leaf 命中很多 entries 後，又做大量 scattered base-row fetches。

## Engine-Specific Wording

面試中可以這樣避免說錯：

```text
The exact storage detail depends on the engine. InnoDB secondary indexes point through the primary key, SQL Server has clustered/nonclustered terminology, and Oracle heap-table indexes commonly point to rows through rowids. The portable point is the access path: does the leaf contain what the query needs, or does it require another base-row lookup?
```

這樣回答比武斷說「所有 DB 的 clustered index 都怎樣」更安全。

## Covering Index

Covering index 的意思是：

```text
for this specific query, the index contains all columns needed by filter, order, and projection
```

它把：

```text
index lookup -> base-table lookup
```

變成：

```text
index-only or mostly index-only access
```

例子：

```sql
SELECT hospital_id, scheduled_at, status, appointment_id
FROM appointments
WHERE hospital_id = :hospital_id
  AND scheduled_at >= :start_time
  AND scheduled_at < :end_time
ORDER BY scheduled_at
FETCH FIRST 50 ROWS ONLY;
```

可能的 covering shape：

```text
(hospital_id, scheduled_at, status, appointment_id)
```

但不要把 covering index 當免費答案。它會帶來：

- wider index pages
- more storage
- more buffer/cache pressure
- more write amplification
- more page split risk
- indexed-column updates 更貴

面試安全說法：

```text
Covering is query-dependent. I would widen the index only if the endpoint is hot, the projection is stable, and production metrics show base-row fetch cost dominates.
```

## Selectivity And Cardinality

Cardinality：

```text
how many distinct values a column has
```

Selectivity：

```text
how much a predicate narrows the rows
```

高 cardinality 常常有幫助，但 optimizer 真正在意的是 predicate 對這次 query 的 selectivity。

例如：

```sql
WHERE status = 'ACTIVE'
```

如果 95% rows 都是 `ACTIVE`，這個 predicate selectivity 很弱。即使 `status` 有 index，也不一定值得用。

## Why Full Scan Can Win

Full scan 不等於壞 plan。它可能贏在：

- predicate 命中大比例 rows
- table 很小
- query 要讀大部分 columns 或 `SELECT *`
- secondary-index plan 造成大量 scattered base-row fetches
- stats stale 導致 optimizer 估錯 rows
- scan 可以更 sequential，locality 更好

核心句：

```text
An index is only faster when total access cost is lower, not because an index exists.
```

差的 index case：

```sql
SELECT *
FROM appointments
WHERE status = 'OPEN';
```

如果 `OPEN` 很常見：

```text
secondary index scan -> many matching entries -> many scattered base-table fetches
```

這可能比直接 full scan 更慢。

好的 index case：

```sql
SELECT patient_id, created_at
FROM appointments
WHERE patient_id = :patient_id
ORDER BY created_at DESC
FETCH FIRST 20 ROWS ONLY;
```

如果 index 對齊：

```text
(patient_id, created_at)
```

它可能：

- equality seek 到某個 patient
- ordered leaf scan
- early stop after 20 rows
- narrow projection 甚至 covering

## SARGability

SARGable 可以用實務語言講：

```text
the predicate can be mapped cleanly to an index key lookup or key-range lookup
```

不好的寫法：

```sql
WHERE DATE(created_at) = DATE '2026-05-12'
```

因為對 indexed column 套 function，可能讓 optimizer 無法直接用原本的 ordered index 做 range seek。

比較好的寫法：

```sql
WHERE created_at >= TIMESTAMP '2026-05-12 00:00:00'
  AND created_at <  TIMESTAMP '2026-05-13 00:00:00'
```

常見 index killer：

- function on indexed column
- implicit type conversion
- leading wildcard: `LIKE '%abc'`
- broad `OR`
- negative predicate: `status != 'DELETED'`
- low-selectivity predicate

## ASUS / Hospital Query

假設 hospital scheduling endpoint：

```sql
SELECT appointment_id, scheduled_at, status
FROM appointments
WHERE hospital_id = :hospital_id
  AND scheduled_at >= :start_time
  AND scheduled_at < :end_time
ORDER BY scheduled_at
FETCH FIRST 50 ROWS ONLY;
```

第一個合理 index：

```text
(hospital_id, scheduled_at)
```

理由：

- `hospital_id = ?` 是 tenant/hospital equality filter
- `scheduled_at` 是 range predicate
- `ORDER BY scheduled_at` 可以沿 leaf order 走
- `FETCH FIRST 50` 讓 early stop 有意義

Expected access path：

```text
seek to first (hospital_id, start_time)
-> ordered leaf scan within hospital/time range
-> stop at end_time or 50 rows
-> fetch base rows only if projected columns are not covered
```

如果 endpoint 很 hot，而且 projection 穩定，可以考慮：

```text
(hospital_id, scheduled_at, status, appointment_id)
```

這可能變成 covering index。但我會先確認：

- p95 latency 是否真的被 row fetch 卡住
- rows examined vs rows returned
- logical reads 是否下降
- write latency 是否可接受
- index size / cache pressure 是否合理

## Bad Index Choice

如果 proposed index 是：

```text
(scheduled_at, hospital_id)
```

對上面 query 通常比較弱，因為 DB 可能要先掃時間範圍內所有 hospitals，再篩 `hospital_id`。

比較安全的說法：

```text
For this endpoint, hospital_id first narrows to one tenant, and scheduled_at next gives the ordered range scan inside that tenant.
```

注意：這不是「永遠 equality before range」的死規則，而是這個 query shape 下的 access-path reasoning。

## Why Indexes Slow Writes

每多一個 index，write path 都多一份永久稅。

`INSERT`：

- insert base row
- insert entry into every relevant index
- maybe split leaf pages
- write redo/WAL/log

`DELETE`：

- remove or mark base row
- remove / mark index entries
- generate undo/redo/log work

indexed-column `UPDATE`：

- often remove old index entry
- insert new index entry
- maybe touch different pages

Operational cost：

- more page writes
- page split / fragmentation
- more buffer churn
- more storage
- more redo/WAL volume
- higher p95 / p99 write latency
- higher lock/latch contention risk on hot pages

所以 production 不能看到慢查詢就一直加 index。

## Primary Key Choice: Auto-Increment vs Random UUID

Auto-increment-like keys 通常比較 write-friendly：

- new rows mostly append near right edge
- better locality
- fewer scattered writes
- lower split / fragmentation pressure

Random UUID：

- values spread across key space
- inserts land in many pages
- more random page writes
- more split / fragmentation pressure

但 UUID 不是錯。它換來：

- distributed uniqueness
- independent ID generation
- harder-to-enumerate public IDs
- less coordination across writers

安全回答：

```text
Auto-increment keys are usually friendlier for B+Tree write locality, while random UUIDs trade locality for distributed ID-generation benefits.
```

## What Breaks At Scale

- low-selectivity secondary index scans become scattered row-fetch storms
- broad `SELECT *` makes projection width dominate
- stale stats cause optimizer to choose unstable plans
- hot tenant / hot time window causes skew
- too many indexes increase write latency and storage
- random keys increase page churn
- one index helps a rare report but hurts hot transactional writes
- data distribution changes and yesterday's good plan becomes today's bad plan

## What To Log Or Measure

Query/read side：

- execution plan shape
- estimated rows vs actual rows
- rows examined vs rows returned
- logical reads / consistent gets / buffer gets
- physical reads when cache misses matter
- sort operation present or avoided
- table access by rowid / bookmark lookup count
- p50 / p95 / p99 latency by endpoint

Write side：

- insert/update/delete p95 / p99 after adding index
- index size growth
- redo/WAL/log volume
- page split / fragmentation indicators if available
- buffer cache hit ratio
- lock/latch contention on hot indexes

Strong line：

```text
I would not stop at EXPLAIN; I would confirm that the production read win is larger than the write tax.
```

## Decision Framework

當 query 慢，不要直接加 index。先問：

1. Query shape
   - predicate selective 嗎？
   - projection narrow 嗎？
   - sort/order 可以由 index 滿足嗎？
   - predicate SARGable 嗎？

2. Plan and data
   - estimated rows vs actual rows 差多少？
   - rows examined vs returned 差多少？
   - 是否有大量 base-table lookup？
   - stats 是否 stale？

3. Workload
   - endpoint hot 嗎？
   - table read-heavy 還是 write-heavy？
   - 這個 index 會不會 hurt hot writes？

4. Lever
   - rewrite query
   - narrow endpoint projection
   - adjust or add index
   - update stats
   - change schema / read model
   - only then consider cache if query/index shape already合理

## Interview Pushback

### Why B+Tree instead of hash as default?

Hash index 對 exact equality lookup 很強，但不保留 order，所以不適合 range query、ordered scan、`ORDER BY`。B+Tree 保留 sorted order，internal pages fan-out 高，leaf pages ordered，所以可以同時支援 equality、range 和 ordering。這讓它比較適合作為 relational database 的 general-purpose index。

### What is key lookup / hui biao?

Secondary index leaf 通常不含完整 row，只含 indexed key 和 row locator / primary key。DB 找到 matching entries 後，如果 query 還需要其他欄位，就要回 base table 抓 row。這個 extra step 就是 key lookup / bookmark lookup / hui biao。當很多 rows match，而且 row fetch 很分散時，它會變成主成本。

### Why can full scan beat index?

Index 只有在 total access cost 比 scan 低時才比較快。如果 predicate selectivity 弱、query 要很多 rows 或 `SELECT *`，secondary index 可能先 match 很多 entries，再做大量 scattered base-table fetches。這時 full scan 順序讀一次 table 可能更便宜。

### When is covering index worth it?

當 query 很 hot、predicate selective、projection 穩定且 narrow，而且 metrics 顯示 base-table lookup 是瓶頸時，covering index 可能值得。否則 widening index 會增加 storage、cache pressure 和 write amplification，不一定划算。

### Why can random UUID hurt writes?

B+Tree 要維持 key order。Auto-increment key 多半往右側 append，locality 比較好。Random UUID 分散在 key space，新 insert 可能落在很多不同 pages，造成 more random writes、page churn、page splits 和 fragmentation。UUID 的優點是 distributed uniqueness，但要承認它的 locality trade-off。

## Common Mistakes

- 只說 `O(log n)`，不講 page reads
- 說有 index 就一定比較快
- 忘記 secondary index 後面可能還有 base-table lookup
- 忘記 `SELECT *` 會放大 row-fetch cost
- 把 covering index 當成永遠正確答案
- 說 full scan 一定是壞 plan
- 說 high cardinality first 是絕對規則，而不是 query-shape reasoning
- 忘記每個 index 都會拖慢 writes
- 說 UUID bad，卻不講 distributed ID trade-off

## 60-90 秒回答

Index 是一條 access path，不是免費加速器。Database 用 B+Tree-style index，主要是因為它以 page 為單位做高 fan-out routing，tree height 低、page reads 少，而且 leaf entries 有序，所以可以支援 point lookup、range scan 和 ordered traversal。真正要比較的是 total access cost：如果 predicate 很 selective、projection 窄、order 能和 index 對齊，index 很可能贏；但 secondary index 常常還要 row locator 回 base table，如果 `SELECT *` 或 predicate 很寬，會產生大量 scattered row fetches，full scan 反而可能比較便宜。Covering index 可以移除 extra lookup，但會增加 storage、cache pressure 和 write amplification，所以我會用 execution plan、estimated vs actual rows、logical reads、p95 latency 和 write latency 來證明這個 index 值得。

## 10-15 分鐘 Deep Dive 路線

1. 先講 index 是 access path，不是魔法加速。
2. 畫 B+Tree pages：root/internal/leaf，不畫普通 BST。
3. 說明 fan-out、height、point lookup、range scan。
4. 走一次 search path，說 leaf hit 後可能還有 base-table lookup。
5. 走一次 insert 和 page split，連到 write amplification。
6. 比較 clustered/primary-style vs secondary access path。
7. 解釋 covering index、selectivity、projection width。
8. 用 hospital scheduling query defend `(hospital_id, scheduled_at)`。
9. 說 optimizer 何時會 full scan。
10. 收斂到 metrics：plan、rows、logical reads、latency、write tax。

## 最後要能交付

你要能做到三件事：

- 畫出 B+Tree root/internal/leaf，並走 point lookup、range scan、insert split。
- 對一個 hospital-style query 說出 index shape、access path、covering vs row fetch、為什麼 optimizer 可能不用它。
- 回答 full scan、secondary index、covering index、UUID、write amplification 的 pushback，而不是只說「加 index」。
