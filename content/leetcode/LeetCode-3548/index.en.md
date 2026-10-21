---
title: "LeetCode 3548: Equal Sum Grid Partition II"
summary: "LeetCode 3548 note: try each horizontal cut (transpose for vertical); the difference must equal a cell on the larger side, and a one-row or one-column side can only drop an end cell, while any cell works otherwise"
description: "LeetCode 3548 record from 2026-07-27"
date: 2026-07-27
tags: ["hard", "prefix-sum", "hash-table", "matrix", "enumeration"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-07-27
- Submissions: Accepted ×2

## Approach

Handle only horizontal cuts; for vertical cuts, transpose the grid and run it again. Cutting below row `k`, accumulate the top sum from row sums ([Prefix Sum]({{< relref "/algorithm/Prefix-Sum" >}}) Template 2), with `diff = top - bottom`:

- `diff == 0`: done.
- `diff > 0`: drop a cell with value exactly `diff` from the top; for `diff < 0`, drop `-diff` from the bottom.

The section must stay connected after dropping the cell:

| Section shape | Which cells can be dropped |
|---|---|
| A single row (or single column) | Only the two ends; a middle cell splits it in two |
| At least 2 × 2 | Any cell |

So we need "does this value appear in the top / bottom part": record each value's **first** and **last** row. The top is rows `0..k`, so its first row must be `<= k`; the bottom is rows `k+1..m-1`, so its last row must be `>= k + 1`.

## My Solution

```python
class Solution:
    def canPartitionGrid(self, grid: List[List[int]]) -> bool:
        def check(g):                              # horizontal cuts only
            m, n = len(g), len(g[0])
            total = sum(map(sum, g))
            first_row, last_row = {}, {}
            for r in range(m):
                for v in g[r]:
                    first_row.setdefault(v, r)
                    last_row[v] = r
            top = 0
            for k in range(m - 1):                 # cut between rows k and k+1
                top += sum(g[k])
                diff = top - (total - top)
                if diff == 0:
                    return True
                if diff > 0:                       # drop a cell worth diff from the top
                    if k == 0:                     # single row: ends only
                        ok = diff in (g[0][0], g[0][-1])
                    elif n == 1:                   # single column: ends only
                        ok = diff in (g[0][0], g[k][0])
                    else:
                        ok = first_row.get(diff, m) <= k
                else:                              # drop a cell worth -diff from the bottom
                    if k == m - 2:
                        ok = -diff in (g[-1][0], g[-1][-1])
                    elif n == 1:
                        ok = -diff in (g[k + 1][0], g[-1][0])
                    else:
                        ok = last_row.get(-diff, -1) >= k + 1
                if ok:
                    return True
            return False

        return check(grid) or check([list(col) for col in zip(*grid)])
```

## Complexity

Time `O(m · n)`, space `O(m · n)` (the transpose and dictionaries).

## Mistakes to Avoid

- In a single-row or single-column section, dropping a middle cell disconnects it; only the ends work.
- The top uses each value's first row and the bottom its last row; they cannot share one position.
- Do not forget vertical cuts: transpose and reuse the same function.

## Interview Explanation

I handle horizontal cuts and transpose for vertical ones. Accumulating row sums gives the difference between the sides, which must equal a cell on the larger side. If that side is a single row or column, only an end cell can be dropped without disconnecting it; otherwise any cell works, so I record each value's first and last row to tell whether it lies in that part. Time `O(mn)`.
