---
title: "LeetCode 576: Out of Boundary Paths"
summary: "LeetCode note for Out of Boundary Paths, rebuilt from the original learning note"
description: "Cleaned LeetCode 576 article from 2026-07-05 with note repair points and final solution"
date: 2026-07-05
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
First Attempt: 2026-07-05
Source: Day 34 learning note

## Study Context

This article is rebuilt from the exact LeetCode section in the learning note. I kept the note's repair points, comparison points, and common mistakes, while removing unrelated non-LeetCode material from the same day.

## Related Reminders From The Note

- `LC 576`: pass after base-case precision repair
- explain `LC 576` with the exact `(moves_left, row, col)` state and why leaving the grid returns `1`

## Learning Note Extract

#### Problem 2 - LC 576 Out of Boundary Paths
- **Pattern:** DP / memoization on position plus remaining moves.

#### Why This Fits
The target is not a destination cell.

The real question is:
```text
how many ways can I leave the grid if I start here with k moves remaining?
```

That makes the stable state:
- current position
- moves remaining

#### Core State / Invariant
For memo DFS:
```text
dp(moves_left, r, c) = number of ways to move out of the grid
starting from (r, c) with moves_left remaining
```

#### Base Cases
If already out of bounds:
```text
return 1
```

Reason:
```text
this path has successfully left the grid
```

If no moves remain and still in bounds:
```text
return 0
```

#### Transition
Try all four directions:
```text
up, down, left, right
```

So:
```text
dp(moves_left, r, c) =
    dp(moves_left - 1, r - 1, c) +
    dp(moves_left - 1, r + 1, c) +
    dp(moves_left - 1, r, c - 1) +
    dp(moves_left - 1, r, c + 1)
```

Take modulo at each step.

#### Complexity
With memo:
```text
Time: O(maxMove * m * n)
Space: O(maxMove * m * n)
```

#### Common Mistakes
- using a destination-style grid DP state
- forgetting that leaving the grid is a success state
- not memoizing and blowing up exponentially
- forgetting modulo

#### Strong Spoken Explanation
I model the state as `(moves_left, row, col)` because the number of valid ways depends on both the current position and how many moves I still have. If I step out of bounds, that contributes one successful path. If I run out of moves while still inside the grid, that contributes zero. From each in-bounds state, I try the four directions and sum the number of ways from the smaller subproblems. With memoization, each `(moves_left, row, col)` state is solved once, so the complexity becomes `O(maxMove * m * n)`.

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

```python
from typing import List

class Solution:
    def findPaths(self, m: int, n: int, maxMove: int, startRow: int, startColumn: int) -> int:
        mod = 10 ** 9 + 7
        dp = [[0] * n for _ in range(m)]
        dp[startRow][startColumn] = 1
        ans = 0
        dirs = [(1,0), (-1,0), (0,1), (0,-1)]

        for _ in range(maxMove):
            ndp = [[0] * n for _ in range(m)]
            for r in range(m):
                for c in range(n):
                    if dp[r][c] == 0:
                        continue
                    for dr, dc in dirs:
                        nr, nc = r + dr, c + dc
                        if 0 <= nr < m and 0 <= nc < n:
                            ndp[nr][nc] = (ndp[nr][nc] + dp[r][c]) % mod
                        else:
                            ans = (ans + dp[r][c]) % mod
            dp = ndp

        return ans
```

## Complexity

Time O(maxMove * m * n), Space O(mn).

## Mistakes To Watch

- Returning ways to reach a boundary cell instead of leaving the grid.
- Missing modulo.

## Final Interview Explanation

Start from the state definition, then explain why the transition preserves that state. If there is a loop direction, state compression, or a similar-looking problem with a different answer shape, call that out explicitly because that is where this problem family usually breaks down.
