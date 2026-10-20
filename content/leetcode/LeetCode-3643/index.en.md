---
title: "LeetCode 3643: Flip Square Submatrix Vertically"
summary: "LeetCode 3643 note: flip only the submatrix rows, swapping the slices of rows x + i and x + k - 1 - i"
description: "LeetCode 3643 record from 2025-08-10"
date: 2025-08-10
tags: ["easy", "two-pointers", "matrix"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2025-08-10
- Submissions: Wrong Answer → Accepted → Accepted (retyped 2026-01-24)

## Approach

The submatrix has top-left corner `(x, y)` and side `k`. Flipping it vertically swaps its `i`-th row with its `i`-th row from the bottom, but **only the slice from `y` to `y + k - 1`**; the rest of the matrix is untouched.

Use converging pointers: the top row starts at `x` going down, the bottom row at `x + k - 1` going up, for `k // 2` swaps.

## My Attempt: using the last row of the whole matrix

```python
for i in range(x, x + (len(grid) - x) // 2):
    grid[i][y:y + k], grid[-1][y:y + k] = grid[-1][y:y + k], grid[i][y:y + k]
```

Two mistakes:

1. The bottom row is `grid[-1]`, the last row of **the whole matrix**, and it is the same row every time instead of moving up with `i`.
2. The number of swaps comes from the matrix's remaining rows rather than the submatrix side `k`.

For a 4-row matrix with `x = 2` and `k = 1`, the submatrix is a single cell and nothing should change, but this version swapped that cell in row 2 with the last row.

## Solution

```python
class Solution:
    def reverseSubmatrix(self, grid: List[List[int]], x: int, y: int, k: int) -> List[List[int]]:
        top, bottom = x, x + k - 1
        while top < bottom:
            grid[top][y:y + k], grid[bottom][y:y + k] = grid[bottom][y:y + k], grid[top][y:y + k]
            top += 1
            bottom -= 1
        return grid
```

The slice assignment `grid[top][y:y + k] = ...` replaces only that part of the row, leaving the other columns alone.

## Complexity

Time `O(k^2)`, space `O(k)` (slices copy a segment).

## Mistakes to Avoid

- Using `grid[-1]` as the submatrix's last row.
- Swapping whole rows instead of only the `y` to `y + k - 1` slice.

## Interview Explanation

Two pointers mark the submatrix's first and last rows, `x` and `x + k - 1`. I swap their slices from `y` to `y + k - 1` and move both inward, for `k // 2` swaps in total. Time `O(k^2)`.
