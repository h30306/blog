---
title: "LeetCode 596: Classes With at Least 5 Students"
summary: "LeetCode 596 note: group by class with HAVING COUNT(DISTINCT student) >= 5; older test data had duplicate rows, so count distinct students"
description: "LeetCode 596 record from 2021-10-10"
date: 2021-10-10
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
First Attempt: 2021-10-10
- Submissions: Wrong Answer ×3 → Runtime Error → Wrong Answer → Accepted

## Approach

As in LC 182 this filters groups ([SQL]({{< relref "/algorithm/SQL" >}}) Template 4): `GROUP BY class` with `HAVING ... >= 5`. Count **distinct students**, `COUNT(DISTINCT student)`, so repeats do not count twice. The current problem makes `(student, class)` the primary key, so `COUNT(*)` also works, but `DISTINCT` is safer.

## My Attempts

This took 6 submissions, all about duplicate rows:

- The first versions used `COUNT(class)`, and the 2021 test data **listed the same student in the same class more than once**, double counting them; attempt 1 also used `SELECT *`.
- Trying `FROM distinct(courses)` to deduplicate was invalid syntax (RE).
- Computing `COUNT(DISTINCT student)` in a subquery and filtering `>= 5` outside passed; putting it straight into `HAVING` works without the subquery.

## Solution

```sql
SELECT class
FROM Courses
GROUP BY class
HAVING COUNT(DISTINCT student) >= 5;
```

## Complexity

Grouping is `O(n)` or `O(n log n)`.

## Mistakes to Avoid

- `SELECT *` with `GROUP BY` fails in strict mode; select only grouped columns.
- Count distinct students with `COUNT(DISTINCT student)`.

## Interview Explanation

I group by class and keep classes with at least five distinct students via HAVING, using COUNT DISTINCT so repeated rows do not count twice.
