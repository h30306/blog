---
title: "LeetCode 595: Big Countries"
summary: "LeetCode 595 note: filter with WHERE and OR for an area of at least 3 million or a population of at least 25 million"
description: "LeetCode 595 record from 2021-10-10"
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
- Submissions: Accepted ×3

## Approach

A country is big if either condition holds, so join them with `OR` ([SQL]({{< relref "/algorithm/SQL" >}}) Template 1). The problem says **at least**, so use `>=`.

## My Attempts

All three passed: `OR`, `OR` in the other order, and a `UNION` of two queries. They used `>` although the problem says "at least"; the boundary should be `>=`, which the tests happened not to probe.

## Solution

```sql
SELECT name, population, area
FROM World
WHERE area >= 3000000 OR population >= 25000000;
```

## Complexity

One table scan, `O(n)`.

## Mistakes to Avoid

- "At least" means `>=`.
- Two queries with `UNION` can be faster with indexes, but `OR` is usually fine.

## Interview Explanation

I filter with WHERE for an area of at least three million or a population of at least twenty-five million and return the name, population and area.
