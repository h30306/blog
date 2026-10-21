---
title: "LeetCode 175: Combine Two Tables"
summary: "LeetCode 175 note: people without an address must still appear, so LEFT JOIN, leaving city and state NULL when unmatched"
description: "LeetCode 175 record from 2021-10-09"
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
- Submissions: Runtime Error → Accepted ×3

## Approach

Everyone must appear even without a row in `Address`, so use `Person LEFT JOIN Address` ([SQL]({{< relref "/algorithm/SQL" >}}) Template 3): every left row is kept and unmatched right columns become `NULL`. An `INNER JOIN` would drop people without addresses.

## My Attempts

Attempt 1 wrapped the join in parentheses with an alias `as ouptut`, which MySQL rejected (RE); dropping the alias passed.

## Solution

```sql
SELECT p.firstName, p.lastName, a.city, a.state
FROM Person p
LEFT JOIN Address a ON p.personId = a.personId;
```

## Complexity

Joining on `personId`, roughly `O(n + m)` with an index.

## Mistakes to Avoid

- To keep every left row use `LEFT JOIN`, not `JOIN`.
- Wrapping a join in parentheses with an alias makes it a derived table; the syntax must be right.

## Interview Explanation

People without an address must still appear, so I use Person LEFT JOIN Address, which leaves city and state NULL when there is no match.
