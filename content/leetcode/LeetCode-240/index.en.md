---
title: "LeetCode 240: Search a 2D Matrix II"
summary: "LeetCode 240 note: start at the top-right corner, moving left when larger and down when smaller, eliminating a row or column each step"
description: "LeetCode 240 record from 2022-11-12"
date: 2022-11-12
tags: ["medium", "array", "binary-search", "divide-and-conquer", "matrix"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-11-12
- Submissions: Accepted ×2 → Runtime Error ×2 → Accepted → Runtime Error → Accepted → Wrong Answer ×2 → Accepted

## Approach

Rows increase left to right and columns top to bottom, but rows do not continue each other, so no flattening. Start at the **top-right** ([Binary Search]({{< relref "/algorithm/Binary-Search" >}})):

- Current value larger than the target: everything below in this column is larger too, so go left.
- Smaller: everything to the left in this row is smaller, so go down.

Each step eliminates a column or a row, at most `m + n` steps.

## My Attempts

My first accepted version in 2022 began with `if not matrix or not target: return False`, which returns `False` whenever `target` is 0; the tests simply missed it. A 2026 rewrite walked right as far as possible and then straight down, which skips answers: `[[1, 1, 3], [4, 7, 8]]`, `target = 7` should be `True`; it returned `False`.

## Solution

```python
class Solution:
    def searchMatrix(self, matrix: List[List[int]], target: int) -> bool:
        i, j = 0, len(matrix[0]) - 1
        while i < len(matrix) and j >= 0:
            v = matrix[i][j]
            if v == target:
                return True
            if v > target:
                j -= 1
            else:
                i += 1
        return False
```

## Complexity

Time `O(m + n)`, space `O(1)`.

## Mistakes to Avoid

- Start at the top-right (or bottom-left), where one direction increases and the other decreases.
- `target` can be 0; do not test it with `not target`.

## Interview Explanation

From the top-right I go left when larger and down when smaller, eliminating a column or row each step; leaving the grid means absent. Time `O(m + n)`.
