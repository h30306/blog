---
title: "SQL Basics"
summary: "Combining conditions in SELECT ... WHERE, and NULL's three-valued logic: any comparison with NULL is not true, so use IS NULL"
description: "Algorithm Learning"
date: 2026-10-21
tags: ["database", "sql"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Introduction

LeetCode's Database problems use MySQL. Most introductory ones are a `SELECT` with a `WHERE` filter; the real trap is **NULL**.

## Template 1: Filtering

```sql
SELECT product_id
FROM Products
WHERE low_fats = 'Y' AND recyclable = 'Y';
```

- Quote strings with single quotes, `'Y'`; MySQL also accepts double quotes by default, but in standard SQL double quotes name columns.
- **Both conditions must hold** (LC 1757): the query above.

## Template 2: NULL's three-valued logic

SQL conditions have three outcomes: true, false and unknown. **Any comparison with NULL (`=`, `!=`, `<`, ...) is unknown**, and `WHERE` keeps only rows that are true:

```sql
SELECT name
FROM Customer
WHERE referee_id IS NULL OR referee_id != 2;
```

Writing only `referee_id != 2` drops people whose `referee_id` is NULL, because `NULL != 2` is unknown, not true.

- **Customers not referred by customer 2** (LC 584): the query above. `COALESCE(referee_id, 0) != 2` also works.

## Template 3: JOIN

```sql
SELECT a.col, b.col
FROM A a
LEFT JOIN B b ON a.key = b.key        -- keep every left row, NULL when unmatched
WHERE b.key IS NULL;                  -- add this line: rows missing from B
```

- **Keeping unmatched rows** (LC 175): `LEFT JOIN`; an `INNER JOIN` drops them.
- **Finding missing rows** (LC 183): `LEFT JOIN ... WHERE b.key IS NULL`, or `NOT EXISTS`; `NOT IN` returns nothing once a `NULL` appears.
- **One table in two roles** (LC 181, 197): a self join, such as employee to manager (`e.managerId = m.id`) or today to yesterday (`DATEDIFF(w.recordDate, y.recordDate) = 1`). Find the previous day by date, not by id.

## Template 4: GROUP BY and HAVING

```sql
SELECT key
FROM T
GROUP BY key
HAVING COUNT(DISTINCT x) >= k;        -- conditions on groups
```

- **Appearing more than once** (LC 182) and **at least 5 distinct students** (LC 596): `WHERE` filters rows before grouping, so aggregate conditions go in `HAVING`.
- **Deleting duplicates** (LC 196): actually `DELETE`, keeping each group's `MIN(id)`; MySQL needs an extra derived table for a subquery to read the same table.

## Key Parameters

- Only `IS NULL` / `IS NOT NULL` test for NULL.
- `AND` binds tighter than `OR`; add parentheses when mixing them.

## Complexity

Both problems scan the table once, `O(n)`.

## Common Mistakes

- Testing with `= NULL`, or only `!=`, which drops the NULL rows.
- **Unquoted strings**: `boring` is read as a column (LC 620).
- **Forgetting `DESC` for high to low** (LC 620).
- **Unqualified columns in a self join**: `Name` is ambiguous, and the output column must be named as required (LC 181).
- **Aggregate conditions in `WHERE`**, and **counting without `DISTINCT`** (LC 596).
- **Writing a `SELECT` when the task deletes** (LC 196).
- **Using `>` for "at least"** (LC 595).

## Related LeetCode

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
