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

## 模板三：JOIN

```sql
SELECT a.col, b.col
FROM A a
LEFT JOIN B b ON a.key = b.key        -- 左表全部保留，對不到的補 NULL
WHERE b.key IS NULL;                  -- 加上這行：在 B 裡找不到的列
```

- **保留沒有對應的列**（LC 175）：`LEFT JOIN`；`INNER JOIN` 會把它們丟掉。
- **找不存在的列**（LC 183）：`LEFT JOIN ... WHERE b.key IS NULL`，或 `NOT EXISTS`；`NOT IN` 遇到 `NULL` 會一筆都不回傳。
- **同一張表扮演兩個角色**（LC 181、197）：self join，例如員工接主管（`e.managerId = m.id`）、今天接前一天（`DATEDIFF(w.recordDate, y.recordDate) = 1`）。前一天要用日期判斷，不要用 id。

## 模板四：GROUP BY 和 HAVING

```sql
SELECT key
FROM T
GROUP BY key
HAVING COUNT(DISTINCT x) >= k;        -- 對分組下條件
```

- **出現超過一次**（LC 182）、**至少 5 個不同的學生**（LC 596）：`WHERE` 在分組前過濾單一列，聚合條件要放 `HAVING`。
- **刪除重複**（LC 196）：要真的 `DELETE`；保留每組的 `MIN(id)`，MySQL 的子查詢要多包一層衍生表才能讀同一張表。

## 主要參數說明

- `IS NULL` / `IS NOT NULL` 才能判斷 NULL。
- `AND` 的優先順序比 `OR` 高，混用時加括號。

## 複雜度

這兩題都是掃一次資料表，`O(n)`。

## 常見錯誤

- 用 `= NULL` 或只用 `!=` 判斷，漏掉 NULL 的列。
- **字串沒加引號**：`boring` 會被當成欄位名稱（LC 620）。
- **由高到低忘了 `DESC`**（LC 620）。
- **欄位沒寫屬於哪個別名**：self join 時 `Name` 有歧義；輸出欄位名稱要照題目（LC 181）。
- **聚合條件寫在 `WHERE`**、**沒用 `DISTINCT` 計數**（LC 596）。
- **題目要刪除卻寫了 `SELECT`**（LC 196）。
- **「至少」用了 `>`**（LC 595）。

## 相關 LeetCode

- `LC 1757` Recyclable and Low Fat Products
- `LC 584` Find Customer Referee
- `LC 595` Big Countries
- `LC 620` Not Boring Movies
- `LC 175` Combine Two Tables
- `LC 181` Employees Earning More Than Their Managers
- `LC 183` Customers Who Never Order
- `LC 182` Duplicate Emails
- `LC 596` Classes With at Least 5 Students
- `LC 196` Delete Duplicate Emails
- `LC 197` Rising Temperature
