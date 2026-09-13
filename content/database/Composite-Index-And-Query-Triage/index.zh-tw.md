---
title: "Composite Index And Query Triage"
summary: "用 predicate、order、projection、plan shape 和 write cost 判斷 composite index 是否真的對"
description: "Leftmost prefix、SARGability、covering index、Oracle-style plan reading、query/index/schema triage 的資料庫複習筆記"
date: 2026-05-12
tags: ["database", "composite-index", "query-plan", "oracle", "sargability", "query-optimization"]
categories: ["database"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 複習重點

- Composite index 不是把常用欄位全部塞進去，而是要對齊 query shape
- Leftmost prefix 的核心是 contiguous usable leading prefix
- Equality predicate、range predicate、ordering column 會決定 seek/scan 能力在哪裡停止
- SARGability 要先修，否則加 index 常常是在錯層解問題
- Oracle-style plan 要能讀懂 `TABLE ACCESS FULL`、`INDEX RANGE SCAN`、`TABLE ACCESS BY INDEX ROWID`
- Covering index 能減少 row fetch，但會增加 index width 和 write tax
- Full scan 可能是合理 plan，不是看到就說 bad
- 慢查詢要先分類：query rewrite、index change、schema/read-model change、stats fix、或 no change

## Tier A/S 判斷

如果回答只是：

```text
Put equality columns first, then range columns.
```

還不夠。Tier A/S 面試會繼續追：

- 為什麼這個 query 能用 index leading prefix，而另一個不能？
- range predicate 出現後，後面的欄位還能做什麼？
- `ORDER BY` 能不能被 index order 滿足？
- plan 裡 `INDEX RANGE SCAN` 後接 `TABLE ACCESS BY INDEX ROWID` 是好還是壞？
- predicate 不 SARGable 時，為什麼應該先 rewrite query？
- covering index 什麼時候值得，什麼時候只是把 write path 搞重？
- 什麼時候應該改 schema/read model，而不是再加 index？

強回答要像這樣思考：

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

Composite index 的設計入口：

```text
predicate -> order -> projection -> write cost
```

也就是先問：

- query 要篩哪些欄位？
- 哪些是 equality？
- 哪些是 range？
- 有沒有 `ORDER BY` / top-N？
- 回傳欄位是否很寬？
- query frequency 高不高？
- table 是 read-heavy 還是 write-heavy？

不要把 composite index 當成：

```text
(all columns that appear somewhere in the query)
```

比較正確：

```text
an ordered access path whose left-to-right key order must match how the query narrows, scans, sorts, and returns rows
```

## Leftmost Prefix

假設 index 是：

```sql
(hospital_id, status, scheduled_at)
```

強 fit：

```sql
WHERE hospital_id = ?
```

更強：

```sql
WHERE hospital_id = ?
  AND status = ?
```

完整 leading-prefix + range：

```sql
WHERE hospital_id = ?
  AND status = ?
  AND scheduled_at >= ?
  AND scheduled_at < ?
```

弱很多：

```sql
WHERE status = ?
  AND scheduled_at >= ?
```

因為缺少 leading column `hospital_id`。

更精準的說法不是：

```text
the database cannot use the index at all
```

而是：

```text
the query cannot form a strong contiguous leading-prefix seek on this index
```

有些 optimizer 可能仍然掃 index、skip scan、或用 index 做其他事情，但那不是我們想要的乾淨 seek path。

## Where Seek Narrowing Stops

Composite index 能有效 narrow 的部分通常是：

```text
leading equality columns + first range column
```

範例：

```sql
WHERE hospital_id = ?
  AND status = ?
  AND scheduled_at >= ?
  AND scheduled_at < ?
  AND doctor_id = ?
```

對 index：

```sql
(hospital_id, status, scheduled_at, doctor_id)
```

通常可以先用：

```text
hospital_id equality
status equality
scheduled_at range
```

但 `doctor_id` 在 range column 後面，通常不能提供同等級的 seek narrowing。它可能仍可被用來 filter index entries，但不是同樣乾淨的 left-to-right seek。

## Equality Before Range

實務直覺：

```text
equality filters first -> range / ordering column -> optional covering columns
```

原因：

- equality 先把 search space 切小
- range 決定 leaf scan 的起點與終點
- range 後面的欄位多半很難再繼續 narrow search path
- `ORDER BY` 若能和 index order 對齊，可能避免 sort

範例 query：

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

自然候選：

```sql
(hospital_id, doctor_id, scheduled_at)
```

因為：

- `hospital_id` equality
- `doctor_id` equality
- `scheduled_at` range + order
- top-N 可以從 ordered range 早停

如果 index 是：

```sql
(hospital_id, status, scheduled_at)
```

但 query 沒有固定 `status`，那 `status` 會卡在中間，破壞乾淨的 time-ordered access path。

## Ordering Behavior

`ORDER BY` 能否被 index 滿足，不只看欄位有沒有在 index 裡。

要看：

- leading columns 是否被 equality 固定
- ordering column 是否接在可用 prefix 後面
- sort direction 是否可由 index scan 方向處理
- range predicate 是否和 order compatible
- 是否有 missing middle column

例子：

```sql
WHERE hospital_id = ?
  AND doctor_id = ?
ORDER BY scheduled_at
```

Index：

```sql
(hospital_id, doctor_id, scheduled_at)
```

通常很適合。

但：

```sql
(hospital_id, scheduled_at, doctor_id)
```

對 `doctor_id = ? ORDER BY scheduled_at` 可能也有某些用途，但如果 query 需要先 narrow 到某個 doctor，`doctor_id` 放在 `scheduled_at` 後面可能讓 scan 範圍變大。重點不是背規則，而是說出 access path。

## SARGability

SARGable 的實務意思：

```text
the predicate can be mapped cleanly to an index lookup or index range scan
```

常見 index blockers：

- function on indexed column: `TRUNC(scheduled_at) = :day`
- leading wildcard: `LIKE '%abc'`
- broad `OR`
- `!=`
- low-selectivity predicate
- implicit type conversion on the column side

不好的寫法：

```sql
WHERE TRUNC(scheduled_at) = DATE '2026-05-12'
```

較好的寫法：

```sql
WHERE scheduled_at >= TIMESTAMP '2026-05-12 00:00:00'
  AND scheduled_at <  TIMESTAMP '2026-05-13 00:00:00'
```

原因：

```text
range predicate preserves the raw indexed column order
```

## Oracle-Style Plan Reading

至少要能解釋這幾個：

```text
TABLE ACCESS FULL
INDEX RANGE SCAN
TABLE ACCESS BY INDEX ROWID
INDEX FULL SCAN
INDEX FAST FULL SCAN
```

### TABLE ACCESS FULL

掃 table blocks，套 predicate filter。

它不一定壞。當 table 小、predicate selectivity 弱、或需要大量 rows 時，full scan 可能是最低成本。

### INDEX RANGE SCAN

走 B-tree index 的 contiguous key range。

這通常代表 index 可以拿來定位一段 key range，但不代表整個 query 已經完成。

### TABLE ACCESS BY INDEX ROWID

index 找到 rowid / row location 後，回 table 抓 row。

重要修正：

```text
TABLE ACCESS BY INDEX ROWID is not a second full-table search.
```

它是 by location fetch。問題是如果 rowid fetch 很多又很分散，總成本會暴增。

### INDEX FULL SCAN vs INDEX FAST FULL SCAN

簡化理解：

- `INDEX FULL SCAN`: 按 index order 掃整個 index，可能保留 ordering
- `INDEX FAST FULL SCAN`: 更像把 index 當比較窄的 segment 掃，通常不保證 order，但可能比 table scan 輕

面試不需要過度背細節，但要知道：

```text
index scan does not always mean selective seek
```

## Covering / Index-Only Access

Covering index 是 query-dependent：

```text
filter columns + order columns + returned columns are all available from the index path
```

它最大的價值是移除：

```text
TABLE ACCESS BY INDEX ROWID
```

適合：

- hot endpoint
- narrow projection
- selective predicate
- top-N ordered query
- read-heavy path

不適合或要小心：

- `SELECT *`
- projection 很寬
- write-heavy table
- endpoint 很冷
- predicate selectivity 弱，會讀很多 rows

安全回答：

```text
I would make the index covering only if row fetch is the proven bottleneck and the read win is worth the wider index.
```

## Full Scan Can Still Be Correct

Full scan 可能是對的：

- table 小
- query 要大比例 rows
- predicate selectivity 弱
- secondary index 造成大量 scattered row fetches
- stats 顯示掃 table 更便宜
- index 不支援 order/filter shape
- index 比 table 窄，但仍需要掃大範圍

面試安全句：

```text
Full scan is not automatically bad; it is bad only if it is unexpectedly reading much more than necessary for a hot query.
```

## Stats And Cardinality Risk

Optimizer 依賴統計資訊來估：

- predicate 會命中多少 rows
- index path 是否比 scan 便宜
- join order
- sort/hash cost

如果 stats stale 或 data skew 很大，可能發生：

- 明明 index shape 合理，但 optimizer 不用
- optimizer 預估 rows 很少，實際 rows 很多
- plan 在資料分布變化後突然變差

要量：

- estimated rows vs actual rows
- histogram / data skew 是否重要
- stats last gathered time
- bind variable 是否造成 plan instability

## Query / Index / Schema Triage

慢查詢不要第一句就說加 index。先分類問題。

### 1. Query Rewrite First

適用：

- predicate 不 SARGable
- `SELECT *` 明顯過寬
- function on indexed column
- implicit conversion
- broad `OR` 可以拆 query

例子：

```sql
SELECT *
FROM appointments
WHERE TRUNC(scheduled_at) = :day
  AND hospital_id = :hid
ORDER BY created_at DESC
FETCH FIRST 100 ROWS ONLY;
```

第一步：

```text
rewrite query shape first
```

改成：

```sql
SELECT appointment_id, scheduled_at, status, created_at
FROM appointments
WHERE hospital_id = :hid
  AND scheduled_at >= :day_start
  AND scheduled_at < :next_day_start
ORDER BY created_at DESC
FETCH FIRST 100 ROWS ONLY;
```

理由：

- range predicate 比 `TRUNC(column)` 更 index-friendly
- narrow projection 降低 row fetch / covering 壓力
- 可能讓既有 index 或較窄的新 index 就夠用

### 2. Index Change First

適用：

- query 已經 SARGable
- projection 已經 narrow
- endpoint hot
- 現有 index shape 明顯不符合 predicate/order

例子：

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

如果現有 index 只有：

```text
(hospital_id, scheduled_at)
```

候選調整：

```text
(hospital_id, doctor_id, scheduled_at)
```

因為 query shape 已經健康，問題是 access path 沒有用 `doctor_id` 先縮小範圍。

### 3. Schema / Read Model Change

適用：

- query rewrite + sane index 仍不達標
- repeated aggregation 很頻繁
- OLTP hot table 被 dashboard/reporting query 壓垮
- freshness requirement 可被定義

例子：

```sql
SELECT hospital_id, doctor_id, COUNT(*) AS appointment_count
FROM appointments
WHERE scheduled_at >= :month_start
  AND scheduled_at < :next_month_start
  AND status = 'COMPLETED'
GROUP BY hospital_id, doctor_id
ORDER BY appointment_count DESC;
```

如果它頻繁支撐 dashboard，而且 base table 很大、寫入又熱，可能要考慮：

- summary table
- materialized view
- reporting replica/path
- pre-aggregation by day/month

但 schema/read-model change 是重武器，要先證明 query/index tuning 不夠。

### 4. Stats Fix / No Change

有時候不是 index 錯，而是：

- stats stale
- data skew 未被 optimizer 捕捉
- table 很小，full scan 本來合理
- query 很冷，不值得為它加 write tax

這時候可能是 update stats、加 histogram、或接受現有 plan。

## Three-Query Classification

| Case | Main Problem | First Move | Why |
|---|---|---|---|
| `TRUNC(scheduled_at)` + `SELECT *` | query shape | rewrite query / narrow projection | 先恢復 SARGability，減少不必要 row fetch |
| SARGable appointment list but missing `doctor_id` in index | index shape | adjust composite index | query 已健康，access path 不夠窄 |
| frequent monthly aggregation dashboard | workload/schema fit | summary/read model after cheaper fixes | OLTP table 上反覆 aggregation 可能不是索引能優雅解決 |

## What To Measure

Before / after 都要量：

- execution plan operators
- estimated rows vs actual rows
- rows examined vs rows returned
- logical reads / buffer gets
- physical reads
- sort operation 是否消失
- `TABLE ACCESS BY INDEX ROWID` 次數
- endpoint p50 / p95 / p99 latency
- index size
- write latency after index change
- endpoint frequency
- data freshness requirement for summary/read model

## Decision Framework

慢查詢 triage 順序：

1. Clarify intent
   - 這個 endpoint 要什麼？
   - 需要最新資料嗎？
   - top-N 還是 full export？

2. Inspect query shape
   - predicate SARGable 嗎？
   - projection 是否太寬？
   - `ORDER BY` 是否真的必要？

3. Inspect plan
   - full scan 是不是合理？
   - index range scan 後 rowid fetch 多不多？
   - estimated vs actual rows 差距大嗎？

4. Choose smallest safe fix
   - rewrite query
   - reduce projection
   - adjust index
   - update stats
   - schema/read model change

5. Prove the result
   - latency 降了嗎？
   - logical reads 降了嗎？
   - write tax 可接受嗎？
   - plan 穩定嗎？

## Interview Pushback

### Why change query before index?

如果 predicate 不 SARGable，例如 `TRUNC(scheduled_at)`，加 index 可能仍然不能形成乾淨 range access。先 rewrite 成 raw timestamp range 比較低風險，也可能讓既有 index 就能工作。

### Why can one extra index column help reads but hurt writes?

多一欄可能讓 index covering 或讓 order/filter 更貼合 query，但 index 變寬會增加 storage、buffer pressure、page split risk，而且每次 insert/update/delete 都要維護更多 index data。

### Why is `TABLE ACCESS BY INDEX ROWID` sometimes the bottleneck?

它代表 index match 後回 table fetch rows。如果 match 很多 rows，而且 row locations 分散，這些 fetch 會變成大量 random access。這時候 bottleneck 不在 index range scan，而在 row fetch fan-out。

### When would you reject a covering index?

當 endpoint 不 hot、projection 不穩定、table write-heavy、或 predicate selectivity 很弱時，我會拒絕。Covering index 只有在 row fetch 是已證明 bottleneck，且 read win 大於 write tax 時才值得。

### When does schema change beat index tuning?

當 query 是頻繁 aggregation/reporting、query rewrite 和合理 index 仍達不到 latency/concurrency 目標，而且 freshness requirement 可以被清楚定義時，summary table、materialized view 或 reporting path 才合理。

## Common Mistakes

- 把 leftmost prefix 說成「只能用第一欄」
- 說 index 沒被用就一定是 optimizer 錯
- 看到 full scan 就說 bad
- 忘記 range 後面的 column 很難繼續 seek narrowing
- 把 projected columns 加進 index，卻說成加進 predicate
- 忘記 `SELECT *` 會讓 covering index 幾乎不現實
- 忘記 stats/cardinality 會改變 plan
- 每個慢 query 都回答加 index
- 直接跳 schema change，沒有先做 query/index 較低成本修正

## 60-90 秒回答

Composite index 要從 query shape 反推。我會先看 predicate 是否 SARGable，再看 equality columns、range/order column、projection width 和 write cost。Leftmost prefix 的重點是 query 能不能形成 contiguous usable leading prefix；通常 equality predicates 先縮小範圍，第一個 range column 決定 leaf scan，range 後面的欄位不一定還能做同等級的 seek narrowing。如果 plan 是 `INDEX RANGE SCAN` 後接大量 `TABLE ACCESS BY INDEX ROWID`，真正瓶頸可能是 scattered row fetch，這時候 covering index 可能有用，但要證明 endpoint 夠 hot、projection 夠窄，而且 write tax 值得。若 predicate 不 SARGable，我會先 rewrite query；若 query 已健康但 index order 錯，我才調 index；若是頻繁 aggregation 壓在 OLTP hot table 上，才考慮 summary/read model。

## 10-15 分鐘 Deep Dive 路線

1. 先講 composite index 是 ordered access path。
2. 用 `(hospital_id, status, scheduled_at)` 解釋 leftmost prefix。
3. 說明 equality、missing leading column、first range column 對 seek narrowing 的影響。
4. 展開 `ORDER BY` 如何跟 index order 對齊或失效。
5. 展開 SARGability，尤其 function-on-column rewrite。
6. 讀 Oracle-style plan：full scan、index range scan、rowid access。
7. 說明 covering index 何時移除 row fetch、何時不值得。
8. 用三個 query 分類：query rewrite first、index change first、schema/read-model change first。
9. 收斂到 metrics：rows、logical reads、latency、write impact、stats quality。

## 最後要能交付

你要能做到三件事：

- 對一個 composite index 判斷哪些 query 能形成強 leading-prefix seek，哪些只是弱用法。
- 讀一個 plan，說出 full scan、index range scan、rowid fetch 各自代表什麼成本。
- 對慢查詢決定先改 query、index、schema/read model、stats，或接受現有 plan，並用 metrics 證明。
