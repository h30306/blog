---
title: "LeetCode 181: Employees Earning More Than Their Managers"
summary: "LeetCode 181 note: self-join Employee on managerId = id to pair employees with managers, then compare salaries"
description: "LeetCode 181 record from 2021-10-09"
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
- Submissions: Runtime Error → Wrong Answer ×2 → Accepted → Wrong Answer → Accepted

## Approach

One table plays both employee and manager, so self-join it ([SQL]({{< relref "/algorithm/SQL" >}}) Template 3): `e.managerId = m.id` pairs each employee with the manager, and `e.salary > m.salary` filters. Name the output column `Employee`. People without a manager have a `NULL` `managerId`, never join, and are excluded naturally.

## My Attempts

This took 6 submissions:

- Attempt 1 selected `Name` without an alias, **ambiguous because both aliases have `Name`** (RE).
- With `A.Name`, the output column was not named `Employee`; one version switched to `SELECT *` to inspect the data. `a.Name AS 'Employee'` passed.

## Solution

```sql
SELECT e.name AS Employee
FROM Employee e
JOIN Employee m ON e.managerId = m.id
WHERE e.salary > m.salary;
```

## Complexity

A self join, near `O(n)` with an index.

## Mistakes to Avoid

- Qualify columns with an alias; a bare `Name` is ambiguous.
- The output column must be named `Employee`.
- Alias case does not matter in MySQL by default, but keep it consistent.

## Interview Explanation

The table plays both roles, so I self-join it, matching each employee's managerId to the manager's id, keep employees earning more, and name the column Employee.
