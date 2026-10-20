---
title: "LeetCode 1292: Maximum Side Length of a Square with Sum Less than or Equal to Threshold"
summary: "LeetCode 1292 note: 2D prefix sums plus binary search on the side length; never mix the two binary search styles"
description: "LeetCode 1292 record from 2026-08-30"
date: 2026-08-30
tags: ["medium", "binary-search", "prefix-sum", "matrix"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-08-30
- Submissions: Accepted → Wrong Answer (changed the loop condition)

## Approach

1. **2D prefix sums**: `P[i][j]` is the sum from `(0, 0)` to `(i-1, j-1)`, so any square sum takes `O(1)`.
2. **Binary search on the side length**: all values are non-negative, so if a square of side `L` fits, any side `L - 1` square inside it has no larger sum, so `L - 1` fits too. The condition is monotonic.

`check(L)` scans every bottom-right corner for a side-`L` square with sum `<= threshold`, in `O(mn)`.

## My Attempt: changing the loop condition but not the updates

The first submission passed with the closed style:

```python
while left <= right:
    ...
    if valid:
        left = mid + 1
    else:
        right = mid - 1
```

Later I switched to `while left < right` but kept `right = mid - 1`. The half-open style needs `hi = mid`; mixing the two skips the answer, hence the WA.

## Solution

Using the "find the largest feasible value" form: find the first **infeasible** side length and subtract 1.

```python
class Solution:
    def maxSideLength(self, mat: List[List[int]], threshold: int) -> int:
        m, n = len(mat), len(mat[0])
        P = [[0] * (n + 1) for _ in range(m + 1)]
        for i in range(m):
            for j in range(n):
                P[i + 1][j + 1] = P[i][j + 1] + P[i + 1][j] - P[i][j] + mat[i][j]

        def ok(L: int) -> bool:
            for i in range(L, m + 1):
                for j in range(L, n + 1):
                    if P[i][j] - P[i - L][j] - P[i][j - L] + P[i - L][j - L] <= threshold:
                        return True
            return False

        lo, hi = 1, min(m, n) + 1          # first infeasible side length
        while lo < hi:
            mid = (lo + hi) // 2
            if ok(mid):
                lo = mid + 1
            else:
                hi = mid
        return lo - 1
```

`ok` returns as soon as it finds a fitting square instead of scanning everything.

## Complexity

Time `O(mn log(min(m, n)))`, space `O(mn)`.

## Mistakes to Avoid

- Mixing the two binary search styles: changing the loop condition but not the updates.
- Getting the 2D prefix arithmetic wrong: `P[i][j] - P[i-L][j] - P[i][j-L] + P[i-L][j-L]`, adding the last term back.
- Forgetting the answer can be 0: return 0 when even side 1 does not fit.

## Interview Explanation

I build 2D prefix sums so any square sum is `O(1)`. Since values are non-negative, if side `L` fits then smaller sides fit, so I binary search the side length; `check` scans every bottom-right corner and returns as soon as some square's sum is within the threshold. I use the "first infeasible side minus 1" form. Time `O(mn log(min(m, n)))`.
