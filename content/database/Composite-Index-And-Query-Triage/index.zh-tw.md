---
title: "Composite Index And Query Triage"
summary: "用 predicate、order、projection 和 write cost 判斷 composite index 是否真的對"
description: "Week 6 learning notes: leftmost prefix、SARGability、covering index、Oracle-style plan reading"
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

## 心智模型

Composite index 不是把幾個常用欄位塞在一起就好。要從 workload 問：

```text
predicate -> order -> projection -> write cost
```

也就是：

- query 怎麼 filter？
- 是否需要 range scan 或 order？
- 回傳欄位有多寬？
- 這個 table 寫入頻率多高？

## Leftmost Prefix

假設 index 是：

```sql
(hospital_id, status, scheduled_at)
```

它很適合：

```sql
WHERE hospital_id = ?
```

也適合：

```sql
WHERE hospital_id = ?
  AND status = ?
```

最完整的是：

```sql
WHERE hospital_id = ?
  AND status = ?
  AND scheduled_at >= ?
  AND scheduled_at < ?
```

但它不太適合拿來做乾淨的 seek：

```sql
WHERE status = ?
  AND scheduled_at >= ?
```

因為缺少 leading column `hospital_id`。比較準確的說法不是「完全不能用 index」，而是「不能形成好的 contiguous leading-prefix seek」。

## Equality Before Range

Composite index 的常見排序直覺是：

```text
equality filters first -> range / ordering column -> optional covering columns
```

原因是 equality 可以先把 search space 縮小，range 開始後，後面的欄位通常很難再拿來做同等效率的 seek narrowing。

例如：

```sql
WHERE hospital_id = ?
  AND doctor_id = ?
  AND scheduled_at >= ?
  AND scheduled_at < ?
ORDER BY scheduled_at
FETCH FIRST 50 ROWS ONLY
```

比較自然的 candidate 是：

```sql
(hospital_id, doctor_id, scheduled_at)
```

如果中間塞一個 query 沒有固定住的欄位，就可能破壞乾淨的 time-ordered access path。

## SARGability

SARGable 的意思是 predicate 能被 index access path 有效使用。

常見 index-killers：

- 對 indexed column 套 function：`TRUNC(scheduled_at) = ?`
- leading wildcard：`LIKE '%abc'`
- broad `OR`
- `!=` 或 low-selectivity predicate
- type conversion 造成欄位端被轉換

修正方向通常不是「硬加 index」，而是改寫 predicate。

例如把：

```sql
TRUNC(scheduled_at) = DATE '2026-05-12'
```

改成：

```sql
scheduled_at >= DATE '2026-05-12'
AND scheduled_at < DATE '2026-05-13'
```

這樣 range condition 才能比較自然地對上 index。

## Oracle-Style Plan Reading

最少要能講清楚這幾個 operator：

- `TABLE ACCESS FULL`: 掃 table
- `INDEX RANGE SCAN`: 走 index 的連續 key range
- `TABLE ACCESS BY INDEX ROWID`: index 找到 rowid 後回 table 抓 row

重要修正：

```text
TABLE ACCESS BY INDEX ROWID is not a second full-table search.
```

它是根據 row location 抓資料。問題在於很多 rowid fetch 分散時，成本會累積很快。

## Query / Index / Schema Triage

面試或 production debug 時，不要第一句就說加 index。

我會照順序問：

1. Query shape 是否本身不 SARGable？
2. 現有 index order 是否符合 predicate 和 order？
3. Projection 是否太寬，導致 row fetch 很重？
4. Statistics / cardinality 是否不準？
5. Table 是否小到 full scan 本來就合理？
6. 這個 access pattern 是否代表 schema shape 不適合？
7. 加 index 的 write cost 是否能接受？

這就是「query rewrite、index change、schema change、或 no change」的取捨。

## ASUS-Style Query Example

假設有 appointment list：

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

第一個候選 index：

```sql
(hospital_id, doctor_id, scheduled_at)
```

理由：

- `hospital_id` 和 `doctor_id` 是 equality filters
- `scheduled_at` 是 range + ordering column
- `FETCH FIRST 50` 能從 ordered range 裡早停

如果 row fetch 仍然是瓶頸，才考慮 covering：

```sql
(hospital_id, doctor_id, scheduled_at, status, appointment_id)
```

但要先證明這個 endpoint 夠 hot、projection 夠窄、write cost 值得。

## 我要量測什麼

- execution plan operators
- estimated rows vs actual rows
- logical reads / buffer gets
- rows examined vs rows returned
- sort operation 是否消失
- rowid lookup 次數
- p95 / p99 latency
- write latency and index maintenance cost

## 60-90 秒回答

Composite index 要從 query shape 反推，不是把常用欄位全部放進去。我會先看 equality predicates，再看 range / ordering column，最後才看 covering。Leftmost prefix 的重點是 contiguous leading columns 能不能形成有效 seek；第一個 missing leading column 或 range predicate 後，後面欄位通常就不再有同樣的 narrowing 能力。如果 plan 顯示 `INDEX RANGE SCAN` 後接大量 `TABLE ACCESS BY INDEX ROWID`，那 bottleneck 可能是 scattered row fetch；這時候可能考慮 covering index，但也要衡量 write cost。若 predicate 不 SARGable，我會先 rewrite query，而不是直接加 index。
