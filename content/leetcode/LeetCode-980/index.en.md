---
title: "LeetCode 980: Unique Paths III"
summary: "LeetCode 980 note: grid backtracking that marks visited cells in place and checks at the end that every empty cell was covered"
description: "LeetCode 980 record from 2026-07-26"
date: 2026-07-26
tags: ["hard", "backtracking", "matrix", "dfs"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-07-26
- Submissions: Accepted (first try)

## Approach

Walk from the start to the end, **visiting every non-obstacle cell exactly once**. The grid has at most 20 cells, so backtracking over all paths is fine.

1. Count the non-obstacle cells, `total` (including the start and end).
2. DFS from the start, marking visited cells as `-1` in place and restoring them on return.
3. On reaching the end, the path is valid if exactly `total` cells have been visited.

## My Solution

```python
class Solution:
    def uniquePathsIII(self, grid: List[List[int]]) -> int:
        m, n = len(grid), len(grid[0])
        total = 0
        for i in range(m):
            for j in range(n):
                if grid[i][j] != -1:
                    total += 1
                if grid[i][j] == 1:
                    start = (i, j)

        def dfs(r: int, c: int, visited: int) -> int:
            if grid[r][c] == 2:
                return 1 if visited == total else 0      # stop at the end cell
            original = grid[r][c]
            grid[r][c] = -1
            count = 0
            for dr, dc in ((0, 1), (1, 0), (-1, 0), (0, -1)):
                nr, nc = r + dr, c + dc
                if 0 <= nr < m and 0 <= nc < n and grid[nr][nc] != -1:
                    count += dfs(nr, nc, visited + 1)
            grid[r][c] = original
            return count

        return dfs(*start, 1)
```

`visited` counts cells walked so far including the current one, starting at 1 for the start cell.

My original version did not stop at the end cell when the step count was wrong, and kept walking out of it. The end cell gets marked visited, so the walk can never return to it and the count stays correct; it just explores some paths that cannot succeed. The version above returns as soon as it reaches the end.

## Complexity

Worst case `O(3^k)`, where `k` is the number of non-obstacle cells: after the first step, each step has at most 3 directions (no going back). Space `O(k)` for the recursion depth.

## Mistakes to Avoid

- An off-by-one in the step count: be clear whether `total` includes the start and end, and whether `visited` starts at 0 or 1.
- Continuing past the end cell.
- Not restoring cells when backtracking.

## Interview Explanation

The grid has at most 20 cells, so I backtrack over every path. I count the non-obstacle cells, DFS from the start, mark visited cells in place, and restore them on the way back. On reaching the end, the path counts only if the number of visited cells equals the non-obstacle total, and the walk never continues past the end cell.
