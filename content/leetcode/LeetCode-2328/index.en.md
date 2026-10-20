---
title: "LeetCode 2328: Number of Increasing Paths in a Grid"
summary: "LeetCode 2328 note: strictly increasing means no cycles; dp[cell] = 1 + Σ dp[larger neighbors], processed from largest to smallest value (or by memoized DFS), summed over all cells"
description: "LeetCode 2328 record from 2026-08-30"
date: 2026-08-30
tags: ["hard", "dynamic-programming", "grid-dp", "memoization", "topological-sort", "matrix"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-08-30
- Submissions: Accepted (first try)

## Approach

Moves go in four directions, so an ordinary grid DP would have cycles. But paths must be **strictly increasing**, only moving from smaller to larger, so there are no cycles: it is a DAG.

`dp[cell]` = the number of increasing paths starting at this cell:

```text
dp[cell] = 1 (the cell alone) + Σ dp[neighbors with larger values]
```

Process values **from largest to smallest**, so every larger neighbor is ready. The answer sums all `dp`.

## My Solution

My accepted version was a memoized DFS:

```python
from functools import cache

class Solution:
    def countPaths(self, grid: List[List[int]]) -> int:
        MOD = 10 ** 9 + 7
        m, n = len(grid), len(grid[0])

        @cache
        def dfs(r: int, c: int) -> int:            # increasing paths starting at (r, c)
            paths = 1
            for dr, dc in ((0, 1), (1, 0), (0, -1), (-1, 0)):
                nr, nc = r + dr, c + dc
                if 0 <= nr < m and 0 <= nc < n and grid[nr][nc] > grid[r][c]:
                    paths += dfs(nr, nc)
            return paths % MOD

        return sum(dfs(r, c) for r in range(m) for c in range(n)) % MOD
```

With up to `10^5` cells, the longest increasing path can be deep and recursion may hit the depth limit. The loop version sorted by value avoids that:

```python
class Solution:
    def countPaths(self, grid: List[List[int]]) -> int:
        MOD = 10 ** 9 + 7
        m, n = len(grid), len(grid[0])
        dp = [[1] * n for _ in range(m)]
        cells = sorted(((grid[r][c], r, c) for r in range(m) for c in range(n)), reverse=True)
        for val, r, c in cells:                    # largest first
            for dr, dc in ((0, 1), (1, 0), (0, -1), (-1, 0)):
                nr, nc = r + dr, c + dc
                if 0 <= nr < m and 0 <= nc < n and grid[nr][nc] > val:
                    dp[r][c] = (dp[r][c] + dp[nr][nc]) % MOD
        return sum(map(sum, dp)) % MOD
```

## Complexity

Time `O(mn log(mn))` (sorting; the memoized DFS is `O(mn)`), space `O(mn)`.

## Mistakes to Avoid

- Using a right / down DP: moves go in all four directions.
- Every cell alone is a path, so `dp` starts at 1.

## Interview Explanation

Moves go in four directions, but strictly increasing paths cannot cycle. `dp` is the number of increasing paths from a cell: 1 plus the `dp` of every larger neighbor. I use a memoized DFS, or sort by value from largest to smallest and fill in order, then sum everything. Time `O(mn)` to `O(mn log(mn))`.
