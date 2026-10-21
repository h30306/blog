---
title: "LeetCode 620: Not Boring Movies"
summary: "LeetCode 620 note: odd id and description not 'boring', ordered by rating from high to low"
description: "LeetCode 620 record from 2021-10-10"
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
- Submissions: Runtime Error → Wrong Answer ×2 → Accepted

## Approach

Filter with two `AND`ed conditions ([SQL]({{< relref "/algorithm/SQL" >}}) Template 1), `id % 2 = 1` and `description <> 'boring'`, then sort with `ORDER BY rating DESC`. Quote the string.

## My Attempts

Attempt 1 left `boring` unquoted, so it was read as a column (RE); after quoting it **forgot the ordering**, then used `ORDER BY rating` (ascending by default); `DESC` passed.

## Solution

```sql
SELECT *
FROM Cinema
WHERE id % 2 = 1 AND description <> 'boring'
ORDER BY rating DESC;
```

## Complexity

Sorting dominates, `O(n log n)`.

## Mistakes to Avoid

- Quote the string: `'boring'`.
- High to low is `DESC`; the default is `ASC`.

## Interview Explanation

I keep movies with odd ids that are not boring and order them by rating from high to low.
