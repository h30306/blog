---
title: "LeetCode 1001: Grid Illumination"
summary: "LeetCode 1001 note: one counter each for rows, columns and both diagonals (r - c, r + c), plus a set of lit lamps; turning one off decrements all four"
description: "LeetCode 1001 record from 2026-10-03"
date: 2026-10-03
tags: ["hard", "hash-table", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-10-03
- Submissions: Runtime Error → Wrong Answer → Accepted → Wrong Answer ×2 → Accepted

## Approach

`n` can reach `10^9`, so no grid. A lamp lights its row, column and both diagonals, so count "how many lit lamps" along each of the four directions ([Hash Table]({{< relref "/algorithm/Hash-Table" >}}) Template 3):

- Row `r`, column `c`, diagonal `r - c`, anti-diagonal `r + c`.
- A cell is lit when any of the four counts is `> 0`.
- A set records which lamps are on: a lamp can be listed twice but counts once, and only lamps that are on can be turned off.

After each query, check the cell and its 8 neighbors; turn off any that are on, decrementing all four counters.

## My Attempts

| Version | Problem |
|---|---|
| RE | `if row, col not in active_lamps` was missing parentheses, a syntax error |
| WA | The query used `row_count[col]` instead of `col_count[col]`, and turning off decremented `row_count[nc]` too. For `n = 3`, a lamp at `(0, 2)` and query `(1, 2)`: same column, answer 1, it returned 0 |
| AC | Rewrote the whole thing with all four counters right |
| Two WAs | Went back to the original code and fixed the query first, but turning off still decremented `row_count[nc]`, so column counts never dropped. For `n = 4`, a lamp at `(1, 3)`, queries `(0, 3)` then `(2, 3)`: the first query turns the lamp off, so the second answer is 0; it returned 1 |
| AC | Changed to `col_count[nc] -= 1` |

## Solution

```python
class Solution:
    def gridIllumination(self, n: int, lamps: List[List[int]], queries: List[List[int]]) -> List[int]:
        row, col, diag, anti = Counter(), Counter(), Counter(), Counter()
        on = set()
        for r, c in lamps:
            if (r, c) not in on:
                on.add((r, c))
                row[r] += 1; col[c] += 1; diag[r - c] += 1; anti[r + c] += 1
        res = []
        for r, c in queries:
            res.append(1 if row[r] or col[c] or diag[r - c] or anti[r + c] else 0)
            for nr in (r - 1, r, r + 1):
                for nc in (c - 1, c, c + 1):
                    if (nr, nc) in on:
                        on.remove((nr, nc))
                        row[nr] -= 1; col[nc] -= 1; diag[nr - nc] -= 1; anti[nr + nc] -= 1
        return res
```

## Complexity

Time `O(L + Q)` for `L` lamps and `Q` queries (9 cells per query), space `O(L)`.

## Mistakes to Avoid

- The four counter names look alike; after copy-paste, check each one in both the query and the turn-off.
- A repeated lamp counts once.

## Interview Explanation

The grid is too large to simulate, so I count lamps per row, column, `r - c` diagonal and `r + c` anti-diagonal, with a set of lamps that are on. A query is lit if any of the four counts is positive; afterward I check the 9 surrounding cells and turn off any lit lamp, updating all four counters. Time `O(L + Q)`.
