---
title: "LeetCode 1235: Maximum Profit in Job Scheduling"
summary: "LeetCode 1235 note: sort jobs by end time with best[j] = best profit using the first j jobs; taking job j binary-searches the last job ending <= its start"
description: "LeetCode 1235 record from 2026-07-31"
date: 2026-07-31
tags: ["hard", "dynamic-programming", "binary-search", "sorting", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-07-31
- Submissions: WA ×3 → MLE ×2 → TLE → AC

## Approach

Sort jobs by **end time**, and let `best[j]` = the best profit considering only the first `j` jobs (`best[0] = 0`). For job `j`:

- **Skip it**: `best[j - 1]`.
- **Take it**: only jobs ending before it starts can join. Binary-search the last job `i` with `end <= start`: `best[i] + profit`.

`best` is non-decreasing, so "the last job with `end <= start`" is the best among them.

## My Attempts

I first tried to index the DP by **time**: `dp[t]` = the best profit up to time `t`.

| Version | Problem |
|---|---|
| Attempt 1, WA | Handled only one job ending at each time. With two jobs ending at time 7 with profits 1 and 9, only the profit-1 job was processed; it returned 1, the answer is 9 |
| Attempts 2–3, WA | Used `while` to handle every job ending at that time, but each wrote `dp[i] = max(dp[i - 1], ...)`, so later jobs **overwrote** earlier results. For `startTime = [4, 1, 1]`, `endTime = [5, 3, 5]`, `profit = [1, 9, 4]`, taking `[1, 3]` and `[4, 5]` gives 10; it returned 9 |
| Two MLEs | Fixed the overwrite, but the `dp` array was as long as the largest end time, up to `10^9` |
| TLE | Switched to a dict, but still looped over every time point |
| AC | Worked per job instead: sort, then binary search |

## Solution

```python
from bisect import bisect_right

class Solution:
    def jobScheduling(self, startTime: List[int], endTime: List[int], profit: List[int]) -> int:
        jobs = sorted(zip(endTime, startTime, profit))
        ends, best = [0], [0]                      # best[j]: using only the first j jobs
        for e, s, p in jobs:
            i = bisect_right(ends, s) - 1          # last job with end <= s
            best.append(max(best[-1], best[i] + p))
            ends.append(e)
        return best[-1]
```

## Complexity

Time `O(n log n)`, space `O(n)`.

## Mistakes to Avoid

- Indexing by time: times reach `10^9`.
- For jobs ending together, take the max with the **current value**; never overwrite it.
- A job may start exactly when another ends, so the test is `end <= start`, hence `bisect_right`.

## Interview Explanation

I sort jobs by end time, with `best[j]` the best profit using only the first `j` jobs. Skipping job `j` gives `best[j - 1]`; taking it binary-searches the last job ending before it starts and adds its profit. `best` is non-decreasing, so that position is the best choice. Time `O(n log n)`.
