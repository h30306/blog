---
title: "LeetCode 183: Customers Who Never Order"
summary: "LeetCode 183 note: LEFT JOIN Orders, and customers with no matching order (o.id IS NULL) never ordered; NOT IN also works"
description: "LeetCode 183 record from 2021-10-09"
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

Find rows absent from another table ([SQL]({{< relref "/algorithm/SQL" >}}) Template 3): `Customers LEFT JOIN Orders` leaves order columns `NULL` when unmatched, filtered by `o.id IS NULL`. `NOT IN (SELECT customerId FROM Orders)` works too, but a `NULL` in the subquery makes `NOT IN` return nothing ([SQL]({{< relref "/algorithm/SQL" >}}) Template 2), so `LEFT JOIN ... IS NULL` or `NOT EXISTS` is safer.

## My Attempts

Passed on the first try with `NOT IN (SELECT CustomerId FROM Orders)`.

## Solution

```sql
SELECT c.name AS Customers
FROM Customers c
LEFT JOIN Orders o ON c.id = o.customerId
WHERE o.id IS NULL;
```

## Complexity

Near `O(n + m)` with an index.

## Mistakes to Avoid

- Test NULL with `IS NULL`, never `= NULL`.
- `NOT IN` breaks when the subquery contains `NULL`.

## Interview Explanation

I left-join Orders onto Customers and keep rows whose order columns are NULL, the customers who never ordered; NOT IN also works but misbehaves if the subquery contains NULL.
