---
title: "LeetCode 463: Island Perimeter"
summary: "LeetCode 463 note: each land cell contributes 4 edges, minus 2 for each land neighbor above or to the left"
description: "LeetCode 463 record from 2022-08-24"
date: 2022-08-24
tags: ["easy", "array", "depth-first-search", "breadth-first-search", "matrix"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-24
- Submissions: Runtime Error ×6 → Wrong Answer ×3 → Runtime Error → Accepted → Runtime Error → Accepted ×2

## Approach

No DFS is needed ([BFS]({{< relref "/algorithm/BFS" >}}) Template 2). Each land cell has 4 edges, and two adjacent cells hide their shared edge on both sides, removing 2. Checking only the cells **above and to the left** subtracts each adjacent pair exactly once.

## My Attempts

In 2022-08 this failed 11 times:

- The first versions lacked bound checks: `grid[row - 1]` wrapped to the last row on the first row, or `row + 1` ran out of range.
- The next two **checked diagonals** (`grid[row + 1][s + 1]`, `grid[row - 1][s - 1]`) and subtracted only 1 per neighbor: the first lacked bound checks, so a lone `[[1]]` read `grid[-1][-1]` (itself) and returned 2; the second added bounds, and `[[1, 1]]` returned 8 instead of 6.
- A 2024 rewrite, "+4 per cell, -2 per up or left neighbor", passed.

## Solution

```python
class Solution:
    def islandPerimeter(self, grid: List[List[int]]) -> int:
        res = 0
        for i in range(len(grid)):
            for j in range(len(grid[0])):
                if grid[i][j]:
                    res += 4
                    if i and grid[i - 1][j]:
                        res -= 2
                    if j and grid[i][j - 1]:
                        res -= 2
        return res
```

## Complexity

Time `O(mn)`, space `O(1)`.

## Mistakes to Avoid

- Adjacency is orthogonal only, not diagonal.
- Subtract 2 per adjacent pair, checking only up and left to avoid double counting.
- `grid[i - 1]` with `i = 0` wraps to the last row; check `i > 0` first.

## Interview Explanation

Each land cell has four edges, and each shared edge between two land cells removes two from the perimeter; looking only up and left avoids double counting. Time `O(mn)`, space `O(1)`.
