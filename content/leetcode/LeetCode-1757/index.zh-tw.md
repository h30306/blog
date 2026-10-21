---
title: "LeetCode 1757: Recyclable and Low Fat Products"
summary: "LeetCode 1757 解題筆記：兩個條件都要成立，用 WHERE ... AND ... 過濾"
description: "2025-12-23 的 LeetCode 1757 解題紀錄"
date: 2025-12-23
tags: ["easy", "database", "sql"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2025-12-23
- 提交紀錄：Accepted（一次通過）

## 解題思路

要的是「低脂而且可回收」的產品，兩個欄位都要是 `'Y'`，用 `AND` 連起來（[SQL]({{< relref "/algorithm/SQL" >}}) 模板一）。

## 我的解法

```sql
SELECT product_id
FROM Products
WHERE low_fats = 'Y' AND recyclable = 'Y';
```

我當時用雙引號 `"Y"`，MySQL 預設接受；單引號是 SQL 標準的字串寫法，換資料庫也不會出錯。

## 複雜度

掃一次資料表，`O(n)`。

## 要特別避免的錯誤

- 字串用單引號，雙引號在標準 SQL 裡是欄位名稱。

## 面試口說整理

用 `WHERE` 過濾兩個欄位都是 `'Y'` 的列，回傳 `product_id`。
