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

## Key Parameters

- Only `IS NULL` / `IS NOT NULL` test for NULL.
- `AND` binds tighter than `OR`; add parentheses when mixing them.

## Complexity

Both problems scan the table once, `O(n)`.

## Common Mistakes

- Testing with `= NULL`, or only `!=`, which drops the NULL rows.

## Related LeetCode

- `LC 1757` Recyclable and Low Fat Products
- `LC 584` Find Customer Referee
