---
title: "LeetCode 566: Reshape the Matrix"
summary: "LeetCode 566 note: return the original if the element counts differ; otherwise element k goes to (k // c, k % c)"
description: "LeetCode 566 record from 2022-08-27"
date: 2022-08-27
tags: ["easy", "array", "matrix", "simulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-27
- Submissions: Runtime Error ×3 → Wrong Answer → Runtime Error ×3 → Accepted ×2

## Approach

Treat the matrix as one row-major sequence ([Matrix]({{< relref "/algorithm/Matrix" >}}) Template 2): element `k` sits at `(k // n, k % n)` in the original and `(k // c, k % c)` in the result. When `m × n != r × c`, reshaping is impossible and the original is returned.

## My Attempts

This took 9 submissions:

- The first three had syntax errors; attempt 4 returned `False` when reshaping was impossible (the original matrix is expected), sliced every `r` elements and wrapped each slice in an extra list.
- After returning the original, the row length became `c // r`, which is 0 when `r > c` (ValueError); then `mat // r`, dividing a list (TypeError). `len(mat) // r`, which equals `c`, finally passed.

## Solution

```python
class Solution:
    def matrixReshape(self, mat: List[List[int]], r: int, c: int) -> List[List[int]]:
        m, n = len(mat), len(mat[0])
        if m * n != r * c:
            return mat
        res = [[0] * c for _ in range(r)]
        for k in range(m * n):
            res[k // c][k % c] = mat[k // n][k % n]
        return res
```

## Complexity

Time `O(mn)`, space `O(mn)` (output).

## Mistakes to Avoid

- When reshaping is impossible return the original matrix, not `False`.
- Each row holds `c` elements, so slices have length `c`, not `r`.

## Interview Explanation

Viewing the matrix as one row-major sequence, element k is at k // n, k % n originally and at k // c, k % c in the result; if the counts differ I return the original. Time `O(mn)`.
