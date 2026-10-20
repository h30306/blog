---
title: "LeetCode 3989: Maximum Consistent Columns in a Grid"
summary: "LeetCode 3989 note: the kept columns form a subsequence constrained only between neighbors; an LIS-style DP with dp[j] = the longest valid sequence ending at column j"
description: "LeetCode 3989 record from 2026-07-13"
date: 2026-07-13
tags: ["hard", "dynamic-programming", "matrix", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-07-13
- Submissions: Accepted ×2 (memoized → LIS-style loop)

## Approach

The kept columns stay in order, forming a **subsequence** of columns. The condition only involves **adjacent kept columns**: every row's difference is `<= limit`.

That is exactly LIS: `dp[j]` = the most columns kept ending at column `j`.

```text
dp[j] = 1 + max(dp[i]) over i < j where columns i and j are compatible
```

Checking compatibility takes `m` rows, so it is `O(n^2 · m)` overall.

## My Solution

```python
class Solution:
    def maxConsistentColumns(self, grid: List[List[int]], limit: int) -> int:
        m, n = len(grid), len(grid[0])

        def compatible(a: int, b: int) -> bool:
            return all(abs(grid[r][b] - grid[r][a]) <= limit for r in range(m))

        dp = [1] * n                               # dp[j]: ending at column j
        for j in range(n):
            for i in range(j):
                if dp[i] + 1 > dp[j] and compatible(i, j):
                    dp[j] = dp[i] + 1
        return max(dp)
```

Comparing `dp[i] + 1 > dp[j]` before the compatibility check skips checks that could not improve the answer.

My first accepted version memoized `dp(cur, prev)` (at column `cur`, last kept column `prev`), also `O(n^2)` states but with recursion overhead.

## Complexity

Time `O(n^2 · m)`, space `O(n)`.

## Mistakes to Avoid

- At least one column must remain, so `dp` starts at 1.
- The condition is about columns adjacent after removal, not originally adjacent columns.

## Interview Explanation

The kept columns form a subsequence and the condition only checks neighbors after removal, so this is LIS: `dp[j]` is the most columns kept ending at column `j`, trying every earlier kept column `i` and extending it when every row differs by at most `limit`. Time `O(n^2 · m)`.
