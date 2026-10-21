---
title: "LeetCode 54: Spiral Matrix"
summary: "LeetCode 54 note: keep four boundaries and walk right, down, left and up, shrinking a boundary after each side"
description: "LeetCode 54 record from 2022-10-22"
date: 2022-10-22
tags: ["medium", "array", "matrix", "simulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-10-22
- Submissions: Wrong Answer ×3 → Runtime Error → Accepted ×3

## Approach

Keep `top`, `bottom`, `left` and `right` ([Matrix]({{< relref "/algorithm/Matrix" >}}) Template 4): after the top row `top += 1`, after the right column `right -= 1`, after the bottom row `bottom -= 1`, after the left column `left += 1`. **Recheck the bounds** before the bottom row and the left column, so a single remaining row or column is not walked twice.

## My Attempts

On 2022-10-22 I sliced "ring `c`" by index and failed four times:

- **With one column left, an element was visited twice**: `[[3], [6], [1]]` returned `[3, 6, 1, 6]`.
- From the second ring on, the bottom row was taken as `matrix[c]`, **the top row reversed**, instead of `matrix[-c - 1]`: `[[5, 2], [2, 4], [1, 2], [2, 8]]` came out in the wrong order.

A week later "pop the first row and rotate the rest counterclockwise" (`zip(*matrix)[::-1]`) passed.

## Solution

```python
class Solution:
    def spiralOrder(self, matrix: List[List[int]]) -> List[int]:
        top, bottom, left, right = 0, len(matrix) - 1, 0, len(matrix[0]) - 1
        res = []
        while top <= bottom and left <= right:
            res += [matrix[top][j] for j in range(left, right + 1)]
            top += 1
            res += [matrix[i][right] for i in range(top, bottom + 1)]
            right -= 1
            if top <= bottom:
                res += [matrix[bottom][j] for j in range(right, left - 1, -1)]
                bottom -= 1
            if left <= right:
                res += [matrix[i][left] for i in range(bottom, top - 1, -1)]
                left += 1
        return res
```

## Complexity

Time `O(mn)`, space `O(1)` excluding output.

## Mistakes to Avoid

- With one row or column left, do not walk the bottom row or left column again.
- The bottom row is `bottom`, not the `top` row reversed.

## Interview Explanation

I keep four boundaries and walk the top row, right column, bottom row and left column, shrinking each after use and rechecking before the bottom and left so a single remaining row is not repeated. Time `O(mn)`.
