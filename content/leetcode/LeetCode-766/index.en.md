---
title: "LeetCode 766: Toeplitz Matrix"
summary: "LeetCode 766 note: every diagonal is constant exactly when each cell equals its upper-left neighbor"
description: "LeetCode 766 record from 2022-09-06"
date: 2022-09-06
tags: ["easy", "array", "matrix"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-09-06
- Submissions: Wrong Answer ×2 → Accepted

## Approach

Cells on the same top-left to bottom-right diagonal share `i - j` ([Matrix]({{< relref "/algorithm/Matrix" >}}) Template 3). All diagonals are constant exactly when `matrix[i][j] == matrix[i - 1][j - 1]` for every `i, j >= 1`: one pass that only needs the previous row, which also fits the follow-up of reading one row at a time.

## My Attempts

The first two padded each row with `None`s to straighten the diagonals and pulled them out with `zip`, but **the padded rows have different lengths, so `zip` truncates to the shortest and some diagonals are never compared**; the `None` check was also wrong, sending a column with `None` and a single value into the `elif`: `[[1], [1]]` returned `False` and `[[0, 1], [0, 1], [1, 0]]` returned `True`. Comparing row against row passed.

## Solution

```python
class Solution:
    def isToeplitzMatrix(self, matrix: List[List[int]]) -> bool:
        return all(matrix[i][j] == matrix[i - 1][j - 1]
                   for i in range(1, len(matrix)) for j in range(1, len(matrix[0])))
```

## Complexity

Time `O(mn)`, space `O(1)`.

## Mistakes to Avoid

- Compare only with the upper-left neighbor; there is no need to extract whole diagonals.

## Interview Explanation

Constant diagonals mean every cell equals its upper-left neighbor, so one comparison pass suffices, needing only the previous row. Time `O(mn)`, space `O(1)`.
