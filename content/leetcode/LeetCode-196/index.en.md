---
title: "LeetCode 196: Delete Duplicate Emails"
summary: "LeetCode 196 note: it must be a DELETE, not a SELECT; keep only the smallest id per email and delete the rest"
description: "LeetCode 196 record from 2021-10-09"
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
- Submissions: Wrong Answer ×2 → Accepted

## Approach

The problem asks to **modify the table**, so this is a `DELETE` of every row whose id is not the smallest for its email. Two ways:

- A `NOT IN` subquery keeping each group's `MIN(id)` ([SQL]({{< relref "/algorithm/SQL" >}}) Template 4); MySQL forbids a `DELETE` subquery from reading the same table directly, so wrap it in a derived table.
- MySQL's self-join form: `DELETE p1 FROM Person p1 JOIN Person p2 ON p1.email = p2.email AND p1.id > p2.id` ([SQL]({{< relref "/algorithm/SQL" >}}) Template 3).

## My Attempts

The first two were `SELECT`s: `SELECT DISTINCT(Email)`, then a self join selecting the rows to remove, **but the task requires actually deleting them**, and a `SELECT` leaves the table unchanged. Turning the same condition into `DELETE p1 FROM ...` passed.

## Solution

```sql
DELETE FROM Person
WHERE id NOT IN (
    SELECT id FROM (SELECT MIN(id) AS id FROM Person GROUP BY email) AS keep
);
```

## Complexity

Grouping in `O(n)` or `O(n log n)`, then deleting.

## Mistakes to Avoid

- The task deletes data; a `SELECT` changes nothing.
- MySQL `DELETE` subqueries cannot read the same table directly; wrap them once more.

## Interview Explanation

The table itself must change, so I DELETE every row except the smallest id per email, found by grouping in a subquery wrapped in a derived table because MySQL forbids reading the target table directly; a self-join DELETE of the larger ids also works.
