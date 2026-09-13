---
title: "B+Tree And Index Internals"
summary: "從 page read、access path、selectivity 和 write cost 重新整理 index 心智模型"
description: "Week 5 learning notes: B+Tree、clustered/secondary index、index scan vs full scan"
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

## 心智模型

不要把 index 講成：

```text
index makes query faster
```

這個答案太淺。比較安全的 mental model 是：

```text
index is an access path:
search key -> leaf entry -> row locator or row payload
```

真正要回答的是：這條 access path 有沒有比直接 scan 更少 page reads、更好的 locality、更少 scattered row fetches。

## 為什麼資料庫常用 B+Tree

Database 不是在最佳化 pointer-chasing 的漂亮樹結構。它主要在最佳化：

- page / block reads
- locality
- range traversal
- predictable update behavior

B+Tree / B+Tree-like index 的 internal page 可以放很多 sorted keys 和 child pointers，所以 fan-out 很高。Fan-out 高代表 tree height 低，查找時通常只需要讀很少層的 page。

Leaf nodes 又是 ordered 的，所以它同時適合：

- point lookup: `WHERE id = ?`
- range scan: `WHERE scheduled_at >= ? AND scheduled_at < ?`
- ordered traversal: 搭配 `ORDER BY` 時可能避免額外排序

Hash index 在 equality lookup 很強，但不擅長 range scan。這也是面試裡不能只說「用 hash 不是更快嗎」的原因。

## Clustered vs Secondary Index

Clustered / primary-style access path 的 leaf 通常比較接近實際 row storage。查到 leaf 後，資料本身或主要 row location 就在那裡。

Secondary / non-clustered index 則常見是：

```text
secondary index lookup -> row locator / primary key -> base table lookup
```

這個 extra lookup 就是很多 note 裡反覆修正的重點。慢的地方常常不是 B+Tree 往下走那幾層，而是命中很多 index entries 後，還要用 row locator 到 table 裡做大量 scattered fetch。

如果 query 需要 `SELECT *`，secondary index 就很容易變貴。因為即使 index 很快找到候選 row，最後還是要去 base table 把每一列完整抓出來。

## Covering Index

Covering index 的意思是 query 需要的欄位都已經在 index 裡。

例如一個 appointment list endpoint 只需要：

```text
hospital_id, doctor_id, scheduled_at, status, appointment_id
```

那 candidate index 可能是：

```text
(hospital_id, doctor_id, scheduled_at, status, appointment_id)
```

這樣 DB 可能不用再回 base table 做 row fetch。

但 strong answer 不能只說「make it covering」。要補 trade-off：

- index 變寬會增加 storage
- write-heavy table 每次 insert/update/delete 都要維護更多 index pages
- cache / buffer pressure 會變高
- 若 endpoint 不 hot 或 selectivity 很弱，covering index 不一定值得

## 為什麼 Full Scan 有時候是對的

Full table scan 不等於 bad plan。

Full scan 可能贏的情況：

- predicate selectivity 很低，很多 rows 都會被讀出來
- table 很小
- query 要讀大比例資料
- secondary index 會造成大量 scattered row fetches
- stale statistics 讓 optimizer 對 rows examined / rows returned 的估計不同

比較好的說法是：

```text
I would compare the total access cost, not just whether an index exists.
```

## Index 為什麼會拖慢寫入

每多一個 index，寫入就不只是改 table row。

每次 `INSERT`、`DELETE`、或更新 indexed column 時，DB 還要維護相關 index structure：

- 寫更多 pages
- 可能 page split
- 增加 redo / WAL / log volume
- 增加 buffer churn
- 增加 lock / latch contention 的機率

所以 production 上不能看到慢查詢就一直加 index。每個 index 都是在跟未來的 write path 和 storage budget 借錢。

## 常見面試追問

### 為什麼 plain BST 不適合資料庫 index？

因為 DB 的主要成本不是 CPU pointer comparison，而是 page I/O。B+Tree 一個 page 放很多 key，fan-out 高、height 低，通常可以用較少 page reads 找到資料，leaf 又天然支援 ordered range scan。

### 為什麼 secondary index 可能比 full scan 慢？

如果 predicate 命中很多 rows，secondary index 會先掃 index，再做大量 base-table lookup。那些 row fetch 如果很分散，總成本可能比一次順序掃 table 還高。

### 什麼時候 covering index 值得？

當 endpoint 很 hot、predicate selective、projection 很窄，而且 row fetch 是明顯瓶頸時，covering index 才值得考慮。否則先看 query shape、index order、projection width 和 write cost。

## 我要量測什麼

- query plan shape: index scan, rowid lookup, full scan
- rows estimated vs rows actual
- rows examined vs rows returned
- logical reads / buffer gets
- p95 / p99 latency by endpoint
- write latency after adding index
- index size and cache hit ratio

## 60-90 秒回答

Index 是一條 access path，不是免費加速器。B+Tree 適合資料庫，因為它用高 fan-out 降低 tree height，減少 page reads，而且 leaf ordered，所以支援 point lookup、range scan 和 ordering。Secondary index 常常還要回 base table 抓 row，如果 predicate 很寬或 `SELECT *` 命中很多 rows，大量 scattered row fetch 可能讓 full scan 更便宜。Covering index 可以避免 row fetch，但會增加 write cost 和 storage，所以我會用 query plan、rows examined、logical reads、latency 和 write impact 來決定是否加 index。
