---
title: "LeetCode 1878: Get Biggest Three Rhombus Sums in a Grid"
summary: "LeetCode 1878 note: enumerate every top vertex and size, walk the four edges, and keep the three largest distinct sums"
description: "LeetCode 1878 record from 2026-06-23"
date: 2026-06-23
tags: ["medium", "matrix", "enumeration", "heap"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-06-23
- Submissions: Accepted (first try)

## Approach

A rhombus is defined by its **top vertex** `(i, j)` and size `l`. Its four vertices are:

```text
top (i, j), right (i + l, j + l), bottom (i + 2l, j), left (i + l, j - l)
```

It is valid when all four vertices are inside the grid. A size-0 rhombus is a single cell.

With `m, n <= 50`, enumerate every top vertex and size and walk around the four edges to sum the border.

The answer wants the three largest **distinct** values, so dedupe with a set, sort, and take three.

## My Solution

```python
class Solution:
    def getBiggestThree(self, grid: List[List[int]]) -> List[int]:
        m, n = len(grid), len(grid[0])
        sums = set()
        for i in range(m):
            for j in range(n):
                sums.add(grid[i][j])                       # size 0
                l = 1
                while i + 2 * l < m and j - l >= 0 and j + l < n:
                    total = 0
                    r, c = i, j
                    for dr, dc in ((1, 1), (1, -1), (-1, -1), (-1, 1)):
                        for _ in range(l):                 # l steps per edge
                            total += grid[r][c]
                            r += dr
                            c += dc
                    sums.add(total)
                    l += 1
        return sorted(sums, reverse=True)[:3]
```

Walking `l` steps per edge, counting from each edge's start, adds each of the `4l` border cells exactly once and returns to the start without double counting.

My original code had four separate loops for the four edges; the logic is the same, merged here with a direction list.

## Complexity

Time `O(m * n * min(m, n)^2)`: up to `min(m, n)` sizes per vertex, and `O(l)` steps per rhombus. Space `O(m * n * min(m, n))` for the distinct sums.

To go faster, prefix sums along both diagonals give each edge in `O(1)`, for `O(m * n * min(m, n))` total. And since only the top three are needed, a size-3 min-heap could replace the whole set.

## Mistakes to Avoid

- Missing size-0 rhombuses.
- Walking `l + 1` steps per edge: vertices get counted twice.
- Not deduplicating: the problem wants distinct values.

## Interview Explanation

A rhombus is fixed by its top vertex and size, and both `m` and `n` are at most 50, so I enumerate every top vertex and valid size and walk `l` steps along each of the four directions, which adds every border cell once. Size 0 is the cell itself. All sums go into a set for deduplication, then I sort and take three. As an optimization, diagonal prefix sums make each edge `O(1)`.
