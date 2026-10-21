---
title: "LeetCode 48: Rotate Image"
summary: "LeetCode 48 note: rotating 90 degrees clockwise is a transpose followed by reversing each row, both in place"
description: "LeetCode 48 record from 2022-10-31"
date: 2022-10-31
tags: ["medium", "array", "math", "matrix"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-10-31
- Submissions: Runtime Error ×2 → Accepted ×3

## Approach

A 90-degree clockwise rotation moves `(i, j)` to `(j, n - 1 - i)`. Split it into two steps ([Matrix]({{< relref "/algorithm/Matrix" >}}) Template 1):

1. Transpose: swap `matrix[i][j]` with `matrix[j][i]` (only for `j > i`).
2. Reverse every row.

Both use swaps only, so extra space is `O(1)`. Counterclockwise is a transpose followed by flipping top to bottom.

## My Attempts

The first two used the wrong parameter name (`A`, NameError); every accepted version was `matrix[:] = zip(*matrix[::-1])`, flipping then transposing in one line, **which actually builds a new matrix** rather than rotating in place. The version above is truly `O(1)` space.

## Solution

```python
class Solution:
    def rotate(self, matrix: List[List[int]]) -> None:
        n = len(matrix)
        for i in range(n):
            for j in range(i + 1, n):
                matrix[i][j], matrix[j][i] = matrix[j][i], matrix[i][j]
        for row in matrix:
            row.reverse()
```

## Complexity

Time `O(n²)`, space `O(1)`.

## Mistakes to Avoid

- Transpose only half (`j > i`); swapping everything undoes itself.
- `matrix[:] = zip(*matrix[::-1])` passes but builds new rows (tuples, too), so it is not truly in place.

## Interview Explanation

A clockwise quarter turn equals transposing and then reversing each row; I swap only one side of the diagonal and reverse rows in place, using `O(1)` extra space.
