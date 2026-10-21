---
title: "SQL 基本查詢"
summary: "SELECT ... WHERE 的條件組合，以及 NULL 的三值邏輯：任何跟 NULL 的比較都不是 true，要用 IS NULL"
description: "演算法學習"
date: 2026-10-21
tags: ["database", "sql"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 介紹

LeetCode 的 Database 題用 MySQL。入門題大多是 `SELECT` 加上 `WHERE` 過濾，真正容易錯的是 **NULL**。

## 模板一：過濾

```sql
SELECT product_id
FROM Products
WHERE low_fats = 'Y' AND recyclable = 'Y';
```

- 字串用單引號 `'Y'`；MySQL 預設也接受雙引號，但 SQL 標準裡雙引號是欄位名稱。
- **兩個條件都要成立**（LC 1757）：上面的查詢。

## 模板二：NULL 的三值邏輯

SQL 的條件有三種結果：true、false、unknown。**任何跟 NULL 的比較（`=`、`!=`、`<`…）結果都是 unknown**，而 `WHERE` 只留下 true 的列：

```sql
SELECT name
FROM Customer
WHERE referee_id IS NULL OR referee_id != 2;
```

只寫 `referee_id != 2` 會漏掉 `referee_id` 是 NULL 的人，因為 `NULL != 2` 是 unknown，不是 true。

- **推薦人不是 2 的客戶**（LC 584）：上面的查詢。也可以寫成 `COALESCE(referee_id, 0) != 2`。

## 主要參數說明

- `IS NULL` / `IS NOT NULL` 才能判斷 NULL。
- `AND` 的優先順序比 `OR` 高，混用時加括號。

## 複雜度

這兩題都是掃一次資料表，`O(n)`。

## 常見錯誤

- 用 `= NULL` 或只用 `!=` 判斷，漏掉 NULL 的列。

## 相關 LeetCode

- `LC 1757` Recyclable and Low Fat Products
- `LC 584` Find Customer Referee
