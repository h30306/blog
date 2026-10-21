---
title: "LeetCode 3195: Find the Minimum Area to Cover All Ones I"
summary: "LeetCode 3195 note: track the topmost, bottommost, leftmost and rightmost 1; the area is height times width"
description: "LeetCode 3195 record from 2025-08-22"
date: 2025-08-22
tags: ["medium", "array", "matrix"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-08-22
- Submissions: Accepted (first try)

## Approach

With sides parallel to the grid, the smallest rectangle containing every 1 hugs the outermost ones ([Array]({{< relref "/algorithm/Array" >}}) Template 5): top at the highest row with a 1, bottom at the lowest, and likewise for columns. The area is `(max_r - min_r + 1) × (max_c - min_c + 1)`.

## My Solution

```python
class Solution:
    def minimumArea(self, grid: List[List[int]]) -> int:
        rows = [i for i, row in enumerate(grid) if 1 in row]
        cols = [j for j in range(len(grid[0])) if any(row[j] for row in grid)]
        return (rows[-1] - rows[0] + 1) * (cols[-1] - cols[0] + 1)
```

I originally updated the four bounds cell by cell in two nested loops, almost 3 s; here I find the rows containing a 1 and then the columns, and `1 in row` is a built-in scan, which is faster.

## Complexity

Time `O(m · n)`, space `O(m + n)`.

## Mistakes to Avoid

- The bounds are inclusive; add 1 to both height and width.

## Interview Explanation

The smallest rectangle hugs the outermost ones, so I find the top and bottom rows and the left and right columns containing a 1, and multiply the inclusive spans. Time `O(mn)`.
