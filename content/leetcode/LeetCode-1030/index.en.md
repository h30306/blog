---
title: "LeetCode 1030: Matrix Cells in Distance Order"
summary: "LeetCode 1030 note: list every coordinate and sort by Manhattan distance to the center; return coordinates, not distances"
description: "LeetCode 1030 record from 2022-09-30"
date: 2022-09-30
tags: ["easy", "array", "math", "geometry", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-09-30
- Submissions: Runtime Error ×2 → Wrong Answer ×5 → Accepted ×3 → Runtime Error → Accepted

## Approach

There are at most `100 × 100` cells, so list the coordinates and sort by `abs(i - r0) + abs(j - c0)`. Distances are at most `rows + cols`, so a counting sort or a BFS from the center gives `O(rows × cols)` ([Sorting]({{< relref "/algorithm/Sorting" >}})).

## My Attempts

This took 12 submissions, mainly **returning distances instead of coordinates**: each cell became `[|r0 - i|, |c0 - j|]` before sorting, and the key went through `len` (always 2, so no sorting) and `sum` with `reverse=True` (backwards). Sorting the coordinates themselves with the distance as key passed.

## Solution

```python
class Solution:
    def allCellsDistOrder(self, rows: int, cols: int, rCenter: int, cCenter: int) -> List[List[int]]:
        cells = [[i, j] for i in range(rows) for j in range(cols)]
        cells.sort(key=lambda p: abs(p[0] - rCenter) + abs(p[1] - cCenter))
        return cells
```

## Complexity

Time `O(RC log(RC))`, space `O(RC)`.

## Mistakes to Avoid

- Return coordinates; the distance is only the sort key.
- The distance is the sum of absolute differences, not `key=len` or `key=sum`.

## Interview Explanation

I list all coordinates and sort by Manhattan distance to the center; with at most ten thousand cells sorting is fast enough, and counting sort or BFS from the center would be linear.
