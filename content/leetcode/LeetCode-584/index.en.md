---
title: "LeetCode 584: Find Customer Referee"
summary: "LeetCode 584 note: referee_id != 2 misses NULLs, since comparing with NULL is unknown; add IS NULL explicitly"
description: "LeetCode 584 record from 2025-12-23"
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

We want customers not referred by customer 2, which includes those with **no referrer** (`referee_id` is NULL).

SQL comparisons have three outcomes, and `NULL != 2` is **unknown**, not true, while `WHERE` keeps only true rows ([SQL]({{< relref "/algorithm/SQL" >}}) Template 2). Writing only `referee_id != 2` therefore drops the NULL rows; add `IS NULL` explicitly.

## My Solution

```sql
SELECT name
FROM Customer
WHERE referee_id IS NULL OR referee_id != 2;
```

`WHERE COALESCE(referee_id, 0) != 2` also works, replacing NULL with a value that cannot be 2.

## Complexity

One table scan, `O(n)`.

## Mistakes to Avoid

- Test for NULL with `IS NULL`; neither `= NULL` nor `!= 2` selects NULL rows.

## Interview Explanation

Customers not referred by 2 include those with no referrer, but `NULL != 2` is unknown in SQL and `WHERE` drops it, so the condition is `referee_id IS NULL OR referee_id != 2`.
