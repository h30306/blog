---
title: "LeetCode 182: Duplicate Emails"
summary: "LeetCode 182 解題筆記：按 email 分組，HAVING COUNT(*) > 1 留下出現超過一次的"
description: "2021-10-09 的 LeetCode 182 解題紀錄"
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
- 提交紀錄：Accepted（一次通過）

## 解題思路

「出現超過一次」是對分組後的結果下條件，所以用 `GROUP BY email` 加 `HAVING COUNT(*) > 1`（[SQL]({{< relref "/algorithm/SQL" >}}) 模板四）。`WHERE` 是分組之前過濾單一列，不能用聚合函數。

## 我的嘗試

一次 AC，就是 `GROUP BY` 加 `HAVING count(Email) > 1`。

## 正確解法

```sql
SELECT email AS Email
FROM Person
GROUP BY email
HAVING COUNT(*) > 1;
```

## 複雜度

分組 `O(n)`（雜湊）或 `O(n log n)`（排序）。

## 要特別避免的錯誤

- 聚合條件放在 `HAVING`，不是 `WHERE`。

## 面試口說整理

我按 email 分組，用 HAVING 留下次數大於一的組別。聚合的條件要放在 HAVING，WHERE 是分組前過濾單一列。
