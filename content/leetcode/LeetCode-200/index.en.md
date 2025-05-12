---
title: "LeetCode 200: Number of Islands"
summary: "LeetCode Problem Solving"
description: "LeetCode Daily"
date: 2025-05-10
tags: ["LeetCode", "blog", "DFS", "medium"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-05-10
- Total time: 10:00.00

## Intuition

This is a classic DFS problem.  
We iterate through the grid from left to right, top to bottom.  
If a cell contains `'1'`, it indicates the start of a new island, so we increment the island count by 1.  
Once we identify an island at a coordinate, we use DFS to traverse all adjacent coordinates, changing all connected land cells from `'1'` to `'#'` to mark them as visited.  
This prevents us from counting the same island multiple times.

## Approach

```python
class Solution:
    def numIslands(self, grid: List[List[str]]) -> int:
        x = len(grid[0])
        y = len(grid)
        
        def dfs(i, j):
            if grid[i][j] == "#" or grid[i][j] == "0":
                return

            grid[i][j] = "#"
            
            if i>0:
                dfs(i-1, j)
            
            if i<y-1:
                dfs(i+1, j)

            if j>0:
                dfs(i, j-1)
            
            if j<x-1:
                dfs(i, j+1)

        res = 0
        for i in range(y):
            for j in range(x):
                if grid[i][j] == "1":
                    res += 1
                    dfs(i, j)

        return res
```

## Findings

First I would like to create a `n x m` grid to record the visit path, but after I realized that I can just amend the grid.

## Encountered Problems 