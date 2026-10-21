---
title: "LeetCode 197: Rising Temperature"
summary: "LeetCode 197 note: self-join Weather on a one-day date difference with today warmer; compare dates with DATEDIFF, never ids"
description: "LeetCode 197 record from 2021-10-10"
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
- Submissions: Runtime Error → Accepted

## Approach

Join each day to the previous day ([SQL]({{< relref "/algorithm/SQL" >}}) Template 3) with `DATEDIFF(w.recordDate, y.recordDate) = 1` and filter `w.temperature > y.temperature`. **Adjacent ids do not mean adjacent dates**: ids need not follow date order, and dates may be missing.

## My Attempts

Attempt 1 mistyped the join as `JOIN weather,w`, with a stray comma (RE); removing it passed.

## Solution

```sql
SELECT w.id
FROM Weather w
JOIN Weather y ON DATEDIFF(w.recordDate, y.recordDate) = 1
WHERE w.temperature > y.temperature;
```

## Complexity

A self join, near `O(n)` with a date index.

## Mistakes to Avoid

- Determine the previous day by date, not by id.
- `DATEDIFF` is MySQL-specific; other databases differ (for example `date - interval`).

## Interview Explanation

I self-join Weather where the dates differ by exactly one day and keep ids warmer than the previous day; the previous day must be found by date, since id order need not follow dates.
