---
title: "LeetCode 36: Valid Sudoku"
summary: "LeetCode 36 note: each digit may appear once per row, column and 3 × 3 box; put (digit, row), (digit, column) and (digit, box) keys into one set"
description: "LeetCode 36 record from 2022-10-21"
date: 2022-10-21
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
First Attempt: 2022-10-21
- Submissions: Runtime Error ×5 → Accepted → Wrong Answer ×3 → Accepted → Runtime Error ×3 → Accepted ×3

## Approach

Only the filled cells are checked; solvability does not matter. Each digit yields three keys, `(d, 'r', i)`, `(d, 'c', j)` and `(d, 'b', i // 3, j // 3)`, and any repeat makes the board invalid ([Hash Table]({{< relref "/algorithm/Hash-Table" >}})). A box is identified by `(i // 3, j // 3)`.

## My Attempts

I wrote this in 2022-10 and 2022-11 and failed 11 times:

- First, three helpers checking rows, columns and boxes passed after several REs.
- Then I tried "put keys into one set" but **added only rows and columns, forgetting the 3 × 3 boxes**: two equal digits in one box, in different rows and columns, went undetected and it returned `True`.
- The 2022-11 rewrite added the `(digit, (i // 3, j // 3))` key and passed.

## Solution

```python
class Solution:
    def isValidSudoku(self, board: List[List[str]]) -> bool:
        seen = set()
        for i in range(9):
            for j in range(9):
                d = board[i][j]
                if d == ".":
                    continue
                for key in ((d, "r", i), (d, "c", j), (d, "b", i // 3, j // 3)):
                    if key in seen:
                        return False
                    seen.add(key)
        return True
```

## Complexity

Time `O(81)`, space `O(81)`.

## Mistakes to Avoid

- Check the 3 × 3 boxes too.
- Row and column keys must be distinguishable; swapping positions like `(d, i)` versus `(i, d)` works, but an explicit tag is clearer.

## Interview Explanation

Each filled digit may appear once per row, column and box, so I put three keys combining it with its row, column and box index into one set and fail on any repeat; the box index is i // 3, j // 3.
