---
title: "LeetCode 183: Customers Who Never Order"
summary: "LeetCode 183 解題筆記：LEFT JOIN Orders，對不到訂單（o.id IS NULL）的就是從來沒下過單的客戶；也可以用 NOT IN"
description: "2021-10-09 的 LeetCode 183 解題紀錄"
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

找「在另一張表沒有出現」的列（[SQL]({{< relref "/algorithm/SQL" >}}) 模板三）：`Customers LEFT JOIN Orders`，對不到的訂單欄位是 `NULL`，用 `o.id IS NULL` 篩出來。`NOT IN (SELECT customerId FROM Orders)` 也可以，但子查詢裡如果有 `NULL`，`NOT IN` 會變成一筆都不回傳（[SQL]({{< relref "/algorithm/SQL" >}}) 模板二），`LEFT JOIN ... IS NULL` 或 `NOT EXISTS` 比較安全。

## 我的嘗試

一次 AC，當時用的是 `NOT IN (SELECT CustomerId FROM Orders)`。

## 正確解法

```sql
SELECT c.name AS Customers
FROM Customers c
LEFT JOIN Orders o ON c.id = o.customerId
WHERE o.id IS NULL;
```

## 複雜度

有索引時接近 `O(n + m)`。

## 要特別避免的錯誤

- 判斷 NULL 要用 `IS NULL`，不能用 `= NULL`。
- `NOT IN` 遇到子查詢有 `NULL` 會出錯。

## 面試口說整理

我用 Customers LEFT JOIN Orders，對不到訂單的客戶訂單欄位會是 NULL，用 IS NULL 篩出來就是從來沒下過單的人。用 NOT IN 也可以，但子查詢有 NULL 時會出問題。
