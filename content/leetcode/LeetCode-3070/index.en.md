---
title: "LeetCode 3070: Count Submatrices with Top-Left Element and Sum Less Than k"
summary: "LeetCode 3070 note: submatrices containing the top-left corner are exactly the 2D prefix sums P[i][j]; count those <= k"
description: "LeetCode 3070 record from 2024-03-03"
date: 2024-03-03
tags: ["medium", "array", "matrix", "prefix-sum"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2024-03-03
- Submissions: Wrong Answer ×2 → Accepted

## Approach

A submatrix containing `(0, 0)` is determined by its bottom-right corner `(i, j)`, and its sum is the 2D prefix sum `P[i][j] = grid[i][j] + P[i - 1][j] + P[i][j - 1] - P[i - 1][j - 1]` ([Prefix Sum]({{< relref "/algorithm/Prefix-Sum" >}})). **Subtract the doubly counted `P[i - 1][j - 1]`.** Count how many `P[i][j] <= k`.

## My Attempts

It failed twice during the 2024 contest:

- Attempt 1 accumulated top and left in place **without subtracting the upper-left**, counting the overlap twice: for `[[1, 0], [4, 4]]`, `k = 9` the bottom-right became 10, returning 3 instead of 4.
- Then row prefix sums plus the previous row's results (no double counting), but with `< k`: `[[3]]`, `k = 3` returned 0. `<=` passed.

## Solution

```python
class Solution:
    def countSubmatrices(self, grid: List[List[int]], k: int) -> int:
        m, n = len(grid), len(grid[0])
        P = [[0] * (n + 1) for _ in range(m + 1)]
        count = 0
        for i in range(m):
            for j in range(n):
                P[i + 1][j + 1] = grid[i][j] + P[i][j + 1] + P[i + 1][j] - P[i][j]
                count += P[i + 1][j + 1] <= k
        return count
```

## Complexity

Time `O(mn)`, space `O(mn)`.

## Mistakes to Avoid

- Subtract the upper-left term, or the overlap counts twice.
- The condition is `<= k`.

## Interview Explanation

Submatrices containing the top-left corner correspond to the 2D prefix sums ending at each cell; I compute them as top plus left minus top-left and count those at most k. Time `O(mn)`.
