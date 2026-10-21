---
title: "LeetCode 892: Surface Area of 3D Shapes"
summary: "LeetCode 892 note: a stack of v cubes has 4v + 2 faces; subtract 2 × min for each overlap with the stacks above and to the left"
description: "LeetCode 892 record from 2022-09-24"
date: 2022-09-24
tags: ["easy", "array", "math", "geometry", "matrix"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-09-24
- Submissions: Wrong Answer ×3 → Accepted

## Approach

A lone stack of `v > 0` cubes has 1 face on top, 1 below and `4v` around. Two adjacent stacks hide `min(a, b)` faces on each side, so subtract `2 × min(a, b)` ([Matrix]({{< relref "/algorithm/Matrix" >}}) Template 3). Comparing each cell only with its upper and left neighbors avoids double subtraction.

## My Attempts

- Attempt 1 doubled the three projection areas, **missing recessed faces**: `[[1, 3, 2], [3, 1, 0], [2, 1, 2]]` returned 48 instead of 54.
- Then I summed "how much taller than the previous" along rows and columns, but the column direction added the previous height `std` rather than the difference: `[[3]]` returned 8 instead of 14. Adding `row[i] - std` passed.

## Solution

```python
class Solution:
    def surfaceArea(self, grid: List[List[int]]) -> int:
        n = len(grid)
        area = 0
        for i in range(n):
            for j in range(n):
                v = grid[i][j]
                if v:
                    area += 4 * v + 2
                if i:
                    area -= 2 * min(v, grid[i - 1][j])
                if j:
                    area -= 2 * min(v, grid[i][j - 1])
        return area
```

## Complexity

Time `O(n²)`, space `O(1)`.

## Mistakes to Avoid

- The surface area is not twice the projection area; recessed faces count too.
- Subtract each adjacent pair once by looking only up and left.

## Interview Explanation

Each stack of v cubes has 4v + 2 faces, and adjacent stacks hide the shorter height on both sides, so I subtract twice that, comparing each cell only with its upper and left neighbors. Time `O(n²)`.
