---
title: "LeetCode 221: Maximal Square"
summary: "LeetCode note for Maximal Square, rebuilt from the original learning note"
description: "Cleaned LeetCode 221 article from 2026-06-30 with note repair points and final solution"
date: 2026-06-30
tags: ["medium", "dynamic-programming", "grid-dp"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-06-30
Source: Day 31 learning note

## Study Context

This article is rebuilt from the exact LeetCode section in the learning note. I kept the note's repair points, comparison points, and common mistakes, while removing unrelated non-LeetCode material from the same day.

## Related Reminders From The Note

- `LC 221`: pass after wording repair
- `LC 221` and `LC 174` are both 2D DP, but they are not the same recurrence family as the earlier grid problems.
- explain `LC 221` with the exact state, why the diagonal matters, and why the recurrence uses `min`

## Learning Note Extract

#### Problem 1 - LC 221 Maximal Square
- **Pattern:** 2D DP on local square geometry.

#### Why This Fits
To know the largest all-`1` square ending at `(r, c)`, it is not enough to know one direction.

The cell can only extend a larger square if:
- the current cell is `1`
- the top cell can support a square
- the left cell can support a square
- the top-left diagonal can support the smaller inner square

This is a clean local-structure DP.

#### Core State / Invariant
```text
dp[r][c] = side length of the largest all-1 square whose bottom-right corner is (r, c)
```

That state is exact enough because the question asks for:
```text
the largest square area anywhere in the matrix
```

If we know the best square ending at every cell, the global maximum is easy to track.

#### Transition
If `matrix[r][c] == '0'`:
```text
dp[r][c] = 0
```

If `matrix[r][c] == '1'` and the cell is not on the top row or left column:
```text
dp[r][c] = 1 + min(dp[r - 1][c], dp[r][c - 1], dp[r - 1][c - 1])
```

Boundary cells with `1` have:
```text
dp[r][c] = 1
```

#### Why The `min(...)` Is Correct
The new square can only be as large as its weakest supporting side:
- top limits vertical extension
- left limits horizontal extension
- top-left limits the inner square

If any one of those is smaller, the larger square is impossible.

#### Complexity
```text
Time: O(m * n)
Space: O(m * n)
```

Can be compressed to:
```text
Space: O(n)
```

#### Common Mistakes
- using `max(...)` instead of `min(...)`
- forgetting the state is side length, not area
- failing to special-case first row / first column
- saying the diagonal is optional
- returning the max side length instead of squaring it for area

#### Strong Spoken Explanation
I define `dp[r][c]` as the side length of the largest all-1 square ending at cell `(r, c)`. If the current cell is `0`, no square can end here. If it is `1`, the square can only grow if the top, left, and top-left neighbors can all support a square of the smaller size. That is why the recurrence is `1 + min(top, left, diagonal)`. I track the largest side seen and square it at the end to get the area.

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

```python
from typing import List

class Solution:
    def maximalSquare(self, matrix: List[List[str]]) -> int:
        m, n = len(matrix), len(matrix[0])
        dp = [0] * (n + 1)
        best = 0

        for r in range(1, m + 1):
            prev_diag = 0
            for c in range(1, n + 1):
                old = dp[c]
                if matrix[r - 1][c - 1] == '1':
                    dp[c] = 1 + min(dp[c], dp[c - 1], prev_diag)
                    best = max(best, dp[c])
                else:
                    dp[c] = 0
                prev_diag = old

        return best * best
```

## Complexity

Time O(mn), Space O(n).

## Mistakes To Watch

- Returning side length instead of area.
- Ignoring the diagonal dependency.

## Final Interview Explanation

Start from the state definition, then explain why the transition preserves that state. If there is a loop direction, state compression, or a similar-looking problem with a different answer shape, call that out explicitly because that is where this problem family usually breaks down.
