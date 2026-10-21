---
title: "LeetCode 196: Delete Duplicate Emails"
summary: "LeetCode 196 解題筆記：要用 DELETE 而不是 SELECT；每個 email 只保留最小的 id，其他刪掉"
description: "2021-10-09 的 LeetCode 196 解題紀錄"
date: 2021-10-09
tags: ["easy", "database"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2021-10-09
- 提交紀錄：Wrong Answer ×2 → Accepted

## 解題思路

題目要求**修改資料表**，所以是 `DELETE`。要刪的是「同一個 email 裡 id 不是最小的列」。兩種寫法：

- `NOT IN` 子查詢：保留每組的 `MIN(id)`，其他刪掉（[SQL]({{< relref "/algorithm/SQL" >}}) 模板四）。MySQL 不允許 `DELETE` 的子查詢直接讀同一張表，所以多包一層衍生表。
- MySQL 的 self join：`DELETE p1 FROM Person p1 JOIN Person p2 ON p1.email = p2.email AND p1.id > p2.id`（[SQL]({{< relref "/algorithm/SQL" >}}) 模板三）。

## 我的嘗試

前兩版都是 `SELECT`：先是 `SELECT DISTINCT(Email)`，再來是用 self join 選出要刪的列，**但題目要的是真的刪掉**，`SELECT` 不會改資料表。把同一個條件改成 `DELETE p1 FROM ...` 就 AC 了。

## 正確解法

```sql
DELETE FROM Person
WHERE id NOT IN (
    SELECT id FROM (SELECT MIN(id) AS id FROM Person GROUP BY email) AS keep
);
```

## 複雜度

分組 `O(n)` 或 `O(n log n)`，再刪除。

## 要特別避免的錯誤

- 題目要刪除資料，`SELECT` 不會改到表。
- MySQL 的 `DELETE` 子查詢不能直接用同一張表，要多包一層。

## 面試口說整理

題目要直接改資料表，所以我用 DELETE，每個 email 只保留最小的 id：子查詢按 email 分組取最小的 id，其他 id 都刪掉。MySQL 不允許子查詢直接讀要刪的表，所以多包一層衍生表；也可以用 self join 刪掉 id 比較大的那一筆。
