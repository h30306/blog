---
title: "LeetCode 59: Spiral Matrix II"
summary: "LeetCode 59 note: keep four boundaries as in LC 54, but fill in 1 to n² instead of reading"
description: "LeetCode 59 record from 2022-10-22"
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
- Submissions: Runtime Error → Wrong Answer → Runtime Error → Accepted ×2

## Approach

Use the same four boundaries as LC 54 ([Matrix]({{< relref "/algorithm/Matrix" >}}) Template 4) and write `1, 2, ..., n²` along right, down, left and up. Each ring of a square is complete, but the single center cell for odd `n` still relies on the boundary checks.

## My Attempts

I used a trick that builds from the largest numbers backwards: prepend a new `range` row and rotate what was built so far clockwise. The first tries had wrong starting values (attempt 2 returned only `[[1]]`) and type errors before the right start passed. It is short but not intuitive; the boundary simulation above is easier to explain.

## Solution

```python
class Solution:
    def generateMatrix(self, n: int) -> List[List[int]]:
        res = [[0] * n for _ in range(n)]
        top, bottom, left, right = 0, n - 1, 0, n - 1
        k = 1
        while top <= bottom and left <= right:
            for j in range(left, right + 1):
                res[top][j] = k; k += 1
            top += 1
            for i in range(top, bottom + 1):
                res[i][right] = k; k += 1
            right -= 1
            if top <= bottom:
                for j in range(right, left - 1, -1):
                    res[bottom][j] = k; k += 1
                bottom -= 1
            if left <= right:
                for i in range(bottom, top - 1, -1):
                    res[i][left] = k; k += 1
                left += 1
        return res
```

## Complexity

Time `O(n²)`, space `O(1)` excluding output.

## Mistakes to Avoid

- `[[0] * n] * n` makes every row the same list.

## Interview Explanation

As in Spiral Matrix, I keep four boundaries and fill numbers right, down, left and up, shrinking each boundary after its side. Time `O(n²)`.
