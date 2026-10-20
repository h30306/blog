---
title: "LeetCode 3619: Count Islands With Total Value Divisible by K"
summary: "LeetCode 3619 note: flood fill each island and sum its values; with up to 10^5 cells, iterate to avoid deep recursion"
description: "LeetCode 3619 record from 2025-07-19"
date: 2025-07-19
tags: ["medium", "dfs", "bfs", "matrix", "graph"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-07-19
- Submissions: Accepted (first try)

## Approach

Find every island (4-directionally connected positive cells), sum its values, and count the islands whose total is divisible by `k`.

It is LC 200 Number of Islands, except each island is also summed.

## My Solution

The original was a recursive DFS that marked visited cells as `-1`:

```python
def search(i, j):
    if i < 0 or i >= n or j >= m or j < 0 or grid[i][j] == -1:
        return 0
    value = grid[i][j]
    if grid[i][j] == 0:
        grid[i][j] = -1
        return 0
    grid[i][j] = -1
    return value + search(i + 1, j) + search(i, j + 1) + search(i - 1, j) + search(i, j - 1)
```

It passes, but the grid can have `10^5` cells, and one long island would push the recursion past Python's default limit. An explicit stack is safer:

```python
class Solution:
    def countIslands(self, grid: List[List[int]], k: int) -> int:
        m, n = len(grid), len(grid[0])
        res = 0
        for i in range(m):
            for j in range(n):
                if grid[i][j] <= 0:
                    continue
                total = grid[i][j]
                grid[i][j] = 0                     # mark visited
                stack = [(i, j)]
                while stack:
                    r, c = stack.pop()
                    for nr, nc in ((r + 1, c), (r - 1, c), (r, c + 1), (r, c - 1)):
                        if 0 <= nr < m and 0 <= nc < n and grid[nr][nc] > 0:
                            total += grid[nr][nc]
                            grid[nr][nc] = 0
                            stack.append((nr, nc))
                if total % k == 0:
                    res += 1
        return res
```

Setting visited cells to 0 removes the need for a separate `-1` state and for telling water apart from visited land.

## Complexity

Time `O(mn)`, space `O(mn)` (the stack in the worst case).

## Mistakes to Avoid

- Recursive DFS exceeding the recursion limit on a large grid.
- Not marking a cell before pushing it: the same cell gets pushed and summed several times.

## Interview Explanation

This is Number of Islands plus a sum. I scan every cell, and from each unvisited land cell run a stack-based flood fill, adding values and zeroing cells as the visited mark. When the island is done, I check whether its total is divisible by `k`. Every cell is handled once, `O(mn)` time, and iteration avoids recursion depth problems on large grids.
