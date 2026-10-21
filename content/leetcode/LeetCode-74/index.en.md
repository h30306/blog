---
title: "LeetCode 74: Search a 2D Matrix"
summary: "LeetCode 74 note: each row continues the previous one in sorted order, so binary search it as a 1-D array of length m × n, mapping mid to (mid // n, mid % n)"
description: "LeetCode 74 record from 2022-10-25"
date: 2022-10-25
tags: ["medium", "array", "binary-search", "matrix"]
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
- Submissions: Runtime Error ×3 → Wrong Answer → Runtime Error → Wrong Answer ×2 → Accepted ×3 → Runtime Error ×4 → Wrong Answer → Runtime Error ×3 → Wrong Answer → Accepted → Runtime Error → Wrong Answer → Accepted → Wrong Answer → Accepted ×2 → Runtime Error → Time Limit Exceeded → Runtime Error → Accepted → Runtime Error → Accepted ×3

## Approach

Rows are sorted and each row starts above the previous row's end, so the flattened matrix is one sorted array ([Binary Search]({{< relref "/algorithm/Binary-Search" >}}) Template 1). Binary search `[0, m·n - 1]`, mapping index `mid` to `matrix[mid // n][mid % n]`.

## My Attempts

This took 34 submissions in 2022, the most in this batch:

- At first I located the row and then the column with a strict `>`, so a target equal to a row's first element was never found: `[[1], [15]]`, `target = 1` returned `False`.
- After switching to flattened binary search, several versions computed `mid = (low + high) / 2` as a float (TypeError); others had undefined variables or out-of-range indices.

## Solution

```python
class Solution:
    def searchMatrix(self, matrix: List[List[int]], target: int) -> bool:
        m, n = len(matrix), len(matrix[0])
        l, r = 0, m * n - 1
        while l <= r:
            mid = (l + r) // 2
            v = matrix[mid // n][mid % n]
            if v == target:
                return True
            if v < target:
                l = mid + 1
            else:
                r = mid - 1
        return False
```

## Complexity

Time `O(log(m · n))`, space `O(1)`.

## Mistakes to Avoid

- Divide by the **column count** `n` to convert coordinates.
- Compute `mid` with integer division.

## Interview Explanation

Flattened, the matrix is sorted, so I binary search `0` to `m·n - 1` and map `mid` to row `mid // n`, column `mid % n`. Time `O(log(mn))`.
