---
title: "Matrix"
summary: "Transposing and rotating, converting between 2D indices and a 1D sequence, neighbors and diagonals, and spiral traversal with four boundaries"
description: "Algorithm Learning"
date: 2026-10-21
tags: ["matrix", "simulation", "array"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Introduction

Most matrix problems are simulations on a 2D array, and the hard part is **indexing**: which dimension is the row, which the column, and where the boundaries are. A few fixed patterns:

| Form | Approach | Examples |
|---|---|---|
| Transpose, rotate | Swap `(i, j)` with `(j, i)`, then reverse | Rotating 90 degrees, transposing |
| Index conversion | Element `k` sits at `(k // n, k % n)` | Reshaping, in-place markers |
| Neighbors and diagonals | Enumerate `dx, dy`, or compare with `(i - 1, j - 1)` | Smoothing, Toeplitz, surface area |
| Spiral traversal | Shrink four boundaries inward | Spiral reading, spiral filling |

For BFS / DFS on grids see [BFS]({{< relref "/algorithm/BFS" >}}), for grid DP see [Grid DP]({{< relref "/algorithm/Grid-DP" >}}), and for 2D prefix sums see [Prefix Sum]({{< relref "/algorithm/Prefix-Sum" >}}).

## Template 1: Transposing and rotating

```python
n = len(matrix)
for i in range(n):
    for j in range(i + 1, n):            # swap one side of the diagonal only
        matrix[i][j], matrix[j][i] = matrix[j][i], matrix[i][j]
for row in matrix:
    row.reverse()                        # transpose + reverse rows = 90 degrees clockwise
```

- **Transpose** (LC 867): `m × n` becomes `n × m` with `res[j][i] = matrix[i][j]`; in Python, `zip(*matrix)` (rows are tuples).
- **Rotate 90 degrees** (LC 48): clockwise = transpose, then reverse each row; counterclockwise = transpose, then flip top to bottom. `matrix[:] = zip(*matrix[::-1])` passes but is not truly in place.

## Template 2: Converting between 2D indices and a 1D sequence

```python
m, n = len(mat), len(mat[0])
for k in range(m * n):
    i, j = k // n, k % n                 # element k in row-major order
```

- **Reshape** (LC 566): move the original `(k // n, k % n)` to the new `(k // c, k % c)`; return the original when the counts differ.
- **Zeroing rows and columns** (LC 73): record which rows and columns contain 0, then modify; zeroing during the scan makes new zeros look original. The `O(1)` version keeps the markers in the first row and column.

## Template 3: Neighbors and diagonals

```python
for dx in (-1, 0, 1):
    for dy in (-1, 0, 1):
        x, y = i + dx, j + dy
        if 0 <= x < m and 0 <= y < n:
            ...
```

- **3 × 3 averages** (LC 661): write into a new matrix built with `[[0] * n for _ in range(m)]`, not `[[0] * n] * m`.
- **Constant diagonals** (LC 766): a diagonal shares `i - j`, so compare `matrix[i][j]` with `matrix[i - 1][j - 1]`.
- **Stacks of cubes** (LC 883, 892): the projection area is the nonzero count plus the row and column maxima; the surface area is `4v + 2` per stack minus `2 × min` for each adjacent pair.
- **Drawing a shape** (LC 3071): decide whether each cell belongs to the shape, count the two groups, then enumerate the target values.
- **Sudoku** (LC 36): a box is identified by `(i // 3, j // 3)`.

## Template 4: Spiral traversal

```python
top, bottom, left, right = 0, m - 1, 0, n - 1
while top <= bottom and left <= right:
    for j in range(left, right + 1): visit(top, j)
    top += 1
    for i in range(top, bottom + 1): visit(i, right)
    right -= 1
    if top <= bottom:                    # with one row left, do not walk back
        for j in range(right, left - 1, -1): visit(bottom, j)
        bottom -= 1
    if left <= right:                    # with one column left, do not walk back
        for i in range(bottom, top - 1, -1): visit(i, left)
        left += 1
```

- **Spiral reading** (LC 54) and **spiral filling with 1 to n²** (LC 59): the same skeleton, with `visit` reading or writing.

## Key Parameters

- `m`, `n`: the number of rows and columns. `len(matrix)` is the row count and `len(matrix[0])` the column count.
- `top`, `bottom`, `left`, `right`: the unvisited range during a spiral, all inclusive.

## Complexity

Each cell is handled a constant number of times: `O(mn)` time. In-place versions use `O(1)` space, new matrices `O(mn)`.

## Common Mistakes

These are all mistakes I actually made while practicing:

- **Swapping the loop ranges for a non-square matrix** (LC 867).
- **`[[0] * n] * m`**: every row is the same list, so writing one writes all (LC 661).
- **Zeroing while scanning**: new zeros look original and spread across the matrix (LC 73).
- **Slicing every `r` elements when reshaping**: rows hold `c`; and when reshaping is impossible return the original, not `False` (LC 566).
- **Revisiting a lone column in a spiral**, and **taking the top row as the bottom row** (LC 54).
- **Padding with `None` and using `zip` for diagonals**: rows differ in length and `zip` truncates (LC 766).
- **Treating surface area as twice the projection area**: recessed faces are missed (LC 892).
- **Counting `'0'` characters to find empty cells**: `10` contains a `'0'` too (LC 883).
- **Forgetting the 3 × 3 boxes in Sudoku** (LC 36).
- **Returning distances instead of coordinates** (LC 1030).

## Related LeetCode

- `LC 867` Transpose Matrix
- `LC 48` Rotate Image
- `LC 566` Reshape the Matrix
- `LC 73` Set Matrix Zeroes
- `LC 661` Image Smoother
- `LC 766` Toeplitz Matrix
- `LC 883` Projection Area of 3D Shapes
- `LC 892` Surface Area of 3D Shapes
- `LC 3071` Minimum Operations to Write the Letter Y on a Grid
- `LC 36` Valid Sudoku
- `LC 54` Spiral Matrix
- `LC 59` Spiral Matrix II
- `LC 1030` Matrix Cells in Distance Order
- `LC 3070` Count Submatrices with Top-Left Element and Sum Less Than k
