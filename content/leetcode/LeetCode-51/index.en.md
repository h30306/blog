---
title: "LeetCode 51: N-Queens"
summary: "LeetCode 51 note: one queen per row, with three sets tracking occupied columns and both diagonals"
description: "LeetCode 51 record from 2026-07-08"
date: 2026-07-08
tags: ["hard", "backtracking"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-07-08
- Submissions: Accepted → Accepted (retyped once)

## Approach

Each row holds exactly one queen, so decide the column row by row. Before placing, check three things:

| Conflict | Check |
|---|---|
| Same column | `col` is already used |
| Same "/" diagonal | same `row + col` |
| Same "\" diagonal | same `row - col` |

Three sets track them, so each check is `O(1)`.

## My Solution

```python
class Solution:
    def solveNQueens(self, n: int) -> List[List[str]]:
        res = []
        board = [["."] * n for _ in range(n)]
        cols, diag1, diag2 = set(), set(), set()

        def backtrack(row: int) -> None:
            if row == n:
                res.append(["".join(r) for r in board])
                return
            for col in range(n):
                if col in cols or row + col in diag1 or row - col in diag2:
                    continue
                board[row][col] = "Q"
                cols.add(col)
                diag1.add(row + col)
                diag2.add(row - col)

                backtrack(row + 1)

                board[row][col] = "."
                cols.remove(col)
                diag1.remove(row + col)
                diag2.remove(row - col)

        backtrack(0)
        return res
```

My original code had `["".join(row) for row in board]`, where the comprehension's `row` shared its name with the parameter `row`. Python 3 comprehensions have their own scope, so it worked, but it is easy to misread; here it is `r`.

## Complexity

Time `O(n!)`: `n` choices for the first row, at most `n - 1` for the second, and so on; pruning cuts this down a lot in practice. Space `O(n^2)` for the board.

## Mistakes to Avoid

- Mixing up the diagonals: "/" is `row + col`, "\" is `row - col`.
- Forgetting one of the sets when undoing.
- Storing `board` itself as an answer: convert it to strings, or later changes overwrite stored answers.

## Interview Explanation

Each row has exactly one queen, so I backtrack row by row over the column choice. Three sets track used columns and the `row + col` and `row - col` diagonals, and conflicts are skipped. After placing a queen I recurse into the next row and restore the sets and board on return. At row `n`, I store the board as strings.
