---
title: "LeetCode 3651: Minimum Cost Path with Teleportations"
summary: "LeetCode 3651 note: compute layer by layer over teleports; arriving at a cell by teleport costs the previous layer's minimum over cells with value >= it, found with a running minimum after sorting, followed by the usual right / down grid DP"
description: "LeetCode 3651 record from 2026-06-26"
date: 2026-06-26
tags: ["hard", "dynamic-programming", "grid-dp", "matrix", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-06-26
- Submissions: Accepted ×3

## Approach

`dp_t[r][c]` = the least cost to reach `(r, c)` with at most `t` teleports.

- **`t = 0`**: the usual right / down grid DP.
- **From layer `t - 1` to layer `t`**:
  1. Teleport: from any cell with value `>=` `grid[r][c]`, at cost 0. So the starting cost at `(r, c)` = the previous layer's minimum `dp` over all cells with value `>= grid[r][c]`. Sort cells by value **descending** and keep a running minimum.
  2. After teleporting you can still move right / down, so run the grid DP again.

Every layer updates the answer at the destination, for up to `k` layers.

## My Solution

```python
class Solution:
    def minCost(self, grid: List[List[int]], k: int) -> int:
        m, n = len(grid), len(grid[0])
        INF = float("inf")
        cells = sorted(((grid[r][c], r, c) for r in range(m) for c in range(n)), reverse=True)

        def walk(dp: List[List[float]]) -> None:     # the usual right / down DP
            for r in range(m):
                for c in range(n):
                    if r > 0:
                        dp[r][c] = min(dp[r][c], dp[r - 1][c] + grid[r][c])
                    if c > 0:
                        dp[r][c] = min(dp[r][c], dp[r][c - 1] + grid[r][c])

        dp = [[INF] * n for _ in range(m)]
        dp[0][0] = 0
        walk(dp)
        ans = dp[m - 1][n - 1]

        for _ in range(k):
            best_from = {}                           # value -> previous layer's min over values >= it
            running = INF
            for val, r, c in cells:                  # largest first
                running = min(running, dp[r][c])
                best_from[val] = running
            dp = [[best_from[grid[r][c]] for c in range(n)] for r in range(m)]
            walk(dp)
            ans = min(ans, dp[m - 1][n - 1])
        return ans
```

Equal values appear consecutively, so `best_from[val]` ends up overwritten with the minimum including every cell of that value, letting equal-valued cells teleport to each other too.

## Complexity

Time `O(mn log(mn) + k · mn)`, space `O(mn)`.

## Mistakes to Avoid

- The teleport direction: from **larger** values to smaller, so reaching `(r, c)` looks at cells with value `>=` it.
- Run the normal DP again after teleporting, since you can keep walking.

## Interview Explanation

I compute one layer per teleport. Each layer first handles teleports: the cost into a cell is the previous layer's minimum over every cell with value at least its own, computed in one pass by sorting cells by value descending with a running minimum; then I rerun the right / down grid DP. Each layer updates the destination's answer. Time `O(mn log(mn) + k · mn)`.
