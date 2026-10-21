---
title: "LeetCode 73: Set Matrix Zeroes"
summary: "LeetCode 73 note: record which rows and columns contain a 0 first, then update afterward; the follow-up uses the first row and column as markers"
description: "LeetCode 73 record from 2022-10-25"
date: 2022-10-25
tags: ["medium", "array", "hash-table", "matrix"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-10-25
- Submissions: Wrong Answer → Accepted → Runtime Error ×2 → Accepted ×2

## Approach

**Do not modify while scanning**: a freshly written 0 later looks like an original 0 and spreads across rows and columns. Scan once to record the rows and columns containing 0, then zero them in a second pass, with `O(m + n)` space. The `O(1)` version stores the markers in the first row and column, plus one variable for whether the first column itself must be cleared ([Matrix]({{< relref "/algorithm/Matrix" >}}) Template 2).

## My Attempts

Attempt 1 **zeroed the whole row as soon as it saw a 0**, so the rest of that row then read as 0 and their columns were marked too: `[[3, 1], [0, 2]]` became all zeros instead of `[[0, 1], [0, 0]]`. Clearing a row only after scanning it passed.

## Solution

```python
class Solution:
    def setZeroes(self, matrix: List[List[int]]) -> None:
        m, n = len(matrix), len(matrix[0])
        rows = {i for i in range(m) for j in range(n) if matrix[i][j] == 0}
        cols = {j for i in range(m) for j in range(n) if matrix[i][j] == 0}
        for i in range(m):
            for j in range(n):
                if i in rows or j in cols:
                    matrix[i][j] = 0
```

## Complexity

Time `O(mn)`, space `O(m + n)`.

## Mistakes to Avoid

- Record everything before modifying; zeroing during the scan makes new zeros look original.

## Interview Explanation

One pass records the rows and columns containing a 0 and a second pass zeroes them, so new zeros are never mistaken for originals. Space `O(m + n)`; for `O(1)`, keep the markers in the first row and column.
