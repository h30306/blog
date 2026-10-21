---
title: "LeetCode 867: Transpose Matrix"
summary: "LeetCode 867 note: the transpose is n × m with res[j][i] = matrix[i][j]; in Python, zip(*matrix)"
description: "LeetCode 867 record from 2022-09-17"
date: 2022-09-17
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
First Attempt: 2022-09-17
- Submissions: Runtime Error ×2 → Accepted ×3

## Approach

Transposing swaps rows and columns ([Matrix]({{< relref "/algorithm/Matrix" >}}) Template 1): an `m × n` matrix becomes `n × m` with `res[j][i] = matrix[i][j]`. The outer loop runs over the new rows (old columns), the inner over the new columns (old rows). Python's `zip(*matrix)` is exactly the transpose, with tuples as rows.

## My Attempts

The first two **swapped the loop ranges**: attempt 1 even passed `matrix[0]` (a list) to `range`, and attempt 2 used `len(matrix[0])` but with inner and outer reversed, so the non-square `[[5, 0]]` went out of range. A one-line `zip(*matrix)` passed.

## Solution

```python
class Solution:
    def transpose(self, matrix: List[List[int]]) -> List[List[int]]:
        m, n = len(matrix), len(matrix[0])
        return [[matrix[i][j] for i in range(m)] for j in range(n)]
```

## Complexity

Time `O(mn)`, space `O(mn)` (output).

## Mistakes to Avoid

- The matrix need not be square; size both loops to the new shape.

## Interview Explanation

Transposing swaps rows and columns, so I build an n × m matrix whose row j, column i holds the original row i, column j. Time `O(mn)`.
