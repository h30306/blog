---
title: "LeetCode 695: Max Area of Island"
summary: "LeetCode 695 note: DFS each unvisited 1 to measure its island and keep the maximum; cells are the integer 1, not a string"
description: "LeetCode 695 record from 2022-10-30"
date: 2022-10-30
tags: ["medium", "array", "depth-first-search", "breadth-first-search", "union-find"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-10-30
- Submissions: Wrong Answer → Accepted

## Approach

Connected components ([BFS]({{< relref "/algorithm/BFS" >}}) Template 2): scan every cell and DFS from each `1`, zeroing visited cells in place and counting the island's size, keeping the maximum. Here cells are the **integers** `0` and `1`, unlike the string `"1"` in LC 200.

## My Attempts

Attempt 1 was adapted from LC 200 and **still compared with the string `'1'`**, while this problem uses integers, so nothing ever matched: `[[1]]` returned 0. Comparing with `1` passed.

## Solution

```python
class Solution:
    def maxAreaOfIsland(self, grid: List[List[int]]) -> int:
        m, n = len(grid), len(grid[0])
        def dfs(i, j):
            if i < 0 or j < 0 or i >= m or j >= n or grid[i][j] != 1:
                return 0
            grid[i][j] = 0
            return 1 + dfs(i + 1, j) + dfs(i - 1, j) + dfs(i, j + 1) + dfs(i, j - 1)
        return max((dfs(i, j) for i in range(m) for j in range(n)), default=0)
```

## Complexity

Time `O(mn)`, space `O(mn)` for recursion depth.

## Mistakes to Avoid

- Cells are integers; do not compare with `'1'`.

## Interview Explanation

Scanning every cell, I DFS from each 1, zeroing visited cells and counting them, and keep the largest island. Each cell is visited once, so time is `O(mn)`.
