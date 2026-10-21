---
title: "LeetCode 1757: Recyclable and Low Fat Products"
summary: "LeetCode 1757 note: both conditions must hold, so filter with WHERE ... AND ..."
description: "LeetCode 1757 record from 2025-12-23"
date: 2025-12-23
tags: ["easy", "database", "sql"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2025-12-23
- Submissions: Accepted (first try)

## Approach

We want products that are low fat and recyclable, so both columns must be `'Y'`, joined with `AND` ([SQL]({{< relref "/algorithm/SQL" >}}) Template 1).

## My Solution

```sql
SELECT product_id
FROM Products
WHERE low_fats = 'Y' AND recyclable = 'Y';
```

I originally used double quotes, `"Y"`, which MySQL accepts by default; single quotes are the standard SQL string syntax and work across databases.

## Complexity

One table scan, `O(n)`.

## Mistakes to Avoid

- Quote strings with single quotes; in standard SQL double quotes name columns.

## Interview Explanation

Filter with `WHERE` for rows where both columns are `'Y'` and return `product_id`.
