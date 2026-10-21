---
title: "LeetCode 3071: Minimum Operations to Write the Letter Y on a Grid"
summary: "LeetCode 3071 note: count each value on and off the Y, enumerate the Y value a and background value b (a != b), and take the fewest cells to change"
description: "LeetCode 3071 record from 2024-03-03"
date: 2024-03-03
tags: ["medium", "array", "hash-table", "matrix", "counting"]
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
- Submissions: Accepted (first try)

## Approach

The Y has three segments: top-left to center, top-right to center, and center down to the bottom ([Matrix]({{< relref "/algorithm/Matrix" >}}) Template 3). Count the 0s, 1s and 2s on and off the Y ([Hash Table]({{< relref "/algorithm/Hash-Table" >}})), then over the 6 pairs `(a, b)` with `a != b` the changes needed are `|Y| - Y[a] + |rest| - rest[b]`.

## My Attempts

Passed on the first try.

## Solution

```python
class Solution:
    def minimumOperationsToWriteY(self, grid: List[List[int]]) -> int:
        n = len(grid)
        mid = n // 2
        on, off = [0] * 3, [0] * 3
        for i in range(n):
            for j in range(n):
                in_y = (i <= mid and (j == i or j == n - 1 - i)) or (i >= mid and j == mid)
                (on if in_y else off)[grid[i][j]] += 1
        total_on, total_off = sum(on), sum(off)
        return min(total_on - on[a] + total_off - off[b]
                   for a in range(3) for b in range(3) if a != b)
```

## Complexity

Time `O(n²)`, space `O(1)`.

## Mistakes to Avoid

- The center belongs to all three segments; count it once.
- The Y and background values must differ.

## Interview Explanation

I count each value on and off the Y, then over the six pairs of distinct Y and background values the cost is the cells not already matching, and I take the minimum. Time `O(n²)`.
