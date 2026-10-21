---
title: "LeetCode 182: Duplicate Emails"
summary: "LeetCode 182 note: group by email and keep groups with HAVING COUNT(*) > 1"
description: "LeetCode 182 record from 2021-10-09"
date: 2021-10-09
tags: ["easy", "database"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2021-10-09
- Submissions: Accepted (first try)

## Approach

"Appears more than once" is a condition on groups, so use `GROUP BY email` with `HAVING COUNT(*) > 1` ([SQL]({{< relref "/algorithm/SQL" >}}) Template 4). `WHERE` filters single rows before grouping and cannot use aggregates.

## My Attempts

Passed on the first try with `GROUP BY` and `HAVING count(Email) > 1`.

## Solution

```sql
SELECT email AS Email
FROM Person
GROUP BY email
HAVING COUNT(*) > 1;
```

## Complexity

Grouping is `O(n)` by hashing or `O(n log n)` by sorting.

## Mistakes to Avoid

- Aggregate conditions go in `HAVING`, not `WHERE`.

## Interview Explanation

I group by email and keep groups with a count above one using HAVING, since aggregate conditions belong there rather than in WHERE.
