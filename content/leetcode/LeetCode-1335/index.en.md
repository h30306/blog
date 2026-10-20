---
title: "LeetCode 1335: Minimum Difficulty of a Job Schedule"
summary: "LeetCode 1335 note: partition DP into d segments; dp(i, k) = the least difficulty starting at job i with k days left, enumerating where today ends while updating today's maximum"
description: "LeetCode 1335 record from 2026-07-02"
date: 2026-07-02
tags: ["hard", "dynamic-programming", "interval-dp", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-07-02
- Submissions: WA → TLE → AC (memoized) → AC ×4 (loop versions, 07-03 and 07-04)

## Approach

Jobs go in order, at least one per day, and a day's difficulty is its hardest job. That is **cutting the array into `d` segments**, each costing its range maximum, minimizing the total.

`dp(i, k)` = the least total difficulty starting at job `i` with `k` days left:

- `k == 1`: today finishes everything left, `max(jobs[i:])`.
- Otherwise try today as `i..j`, leaving at least `k - 1` jobs for `k - 1` days, so `j <= n - k`. Today's difficulty updates as `cur = max(cur, jobs[j])` while enumerating.

With fewer jobs than `d`, there is no schedule: return -1.

## My Attempts

1. **WA**: the `min` line was mis-indented outside the `for` loop, so only the last split point was compared. For `jobs = [1, 2, 4]`, `d = 2`, `[1, 2] + [4]` is 6 and `[1] + [2, 4]` is 5, so the answer is 5; it returned 6.
2. **TLE**: fixed the indentation, but the recursion had no memoization.
3. **AC**: added `@cache`. I later wrote several bottom-up loop versions, going from 2 seconds to about 0.3.

## Solution

```python
from functools import cache

class Solution:
    def minDifficulty(self, jobDifficulty: List[int], d: int) -> int:
        n = len(jobDifficulty)
        if n < d:
            return -1

        @cache
        def dp(i: int, k: int) -> int:             # start at i, k days left
            if k == 1:
                return max(jobDifficulty[i:])
            best = float("inf")
            cur = 0
            for j in range(i, n - k + 1):          # today does i..j
                cur = max(cur, jobDifficulty[j])
                best = min(best, cur + dp(j + 1, k - 1))
            return best

        return dp(0, d)
```

## Complexity

Time `O(d · n^2)`, space `O(d · n)`. (A monotonic stack brings it to `O(d · n)`.)

## Mistakes to Avoid

- Keep the min update inside the loop.
- Memoize the recursion.
- Today ends at `n - k` at most, leaving enough jobs for the remaining days.

## Interview Explanation

This is partition DP: cut the array into `d` segments, each costing its range maximum. `dp(i, k)` is the least difficulty starting at job `i` with `k` days left; I try where today ends, keep today's maximum while walking, and add the `dp` of the rest, leaving enough jobs for the remaining days. Time `O(d · n^2)`.
