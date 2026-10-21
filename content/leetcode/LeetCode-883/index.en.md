---
title: "LeetCode 883: Projection Area of 3D Shapes"
summary: "LeetCode 883 note: the top view counts nonzero cells, and the front and side views sum each row's and each column's maximum"
description: "LeetCode 883 record from 2022-09-21"
date: 2022-09-21
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
First Attempt: 2022-09-21
- Submissions: Runtime Error ×4 → Wrong Answer ×2 → Accepted

## Approach

The three projections ([Matrix]({{< relref "/algorithm/Matrix" >}}) Template 3):

- From above: each cell with `grid[i][j] > 0` contributes 1.
- From the front: the tallest stack in each column.
- From the side: the tallest stack in each row.

## My Attempts

The first attempts were variable and type REs. The next two joined every number into one string and **counted `'0'` characters** to subtract empty cells, but once any cell is empty, the `'0'` inside numbers such as `10` and `20` is counted too: `[[0, 10]]` should be 21; it returned 20. Testing `grid[i][j] > 0` passed.

## Solution

```python
class Solution:
    def projectionArea(self, grid: List[List[int]]) -> int:
        top = sum(v > 0 for row in grid for v in row)
        side = sum(max(row) for row in grid)
        front = sum(max(col) for col in zip(*grid))
        return top + side + front
```

## Complexity

Time `O(n²)`, space `O(1)`.

## Mistakes to Avoid

- The top view counts **nonzero cells**; do not count `'0'` characters in a string.

## Interview Explanation

The top view is the number of nonzero cells, and the front and side views sum the maxima of the columns and rows; I add all three. Time `O(n²)`.
