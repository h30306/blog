---
title: "LeetCode 64: Minimum Path Sum"
summary: "LeetCode note for Minimum Path Sum, rebuilt from the original learning note"
description: "Cleaned LeetCode 64 article from 2026-06-27 with note repair points and final solution"
date: 2026-06-27
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
First Attempt: 2026-06-27
Source: Day 30 learning note

## Study Context

This article is rebuilt from the exact LeetCode section in the learning note. I kept the note's repair points, comparison points, and common mistakes, while removing unrelated non-LeetCode material from the same day.

## Learning Note Extract

#### Problem 1 - LC 64 Minimum Path Sum
- **Pattern:** 2D optimization DP on a grid.

#### Why This Fits
From each cell, you can still only arrive from:
- up
- left

But the question changed from:
```text
how many ways?
```

to:
```text
what is the minimum cost?
```

So the DP state now stores best cost, not count.

#### Core State / Invariant
```text
dp[r][c] = minimum path sum from the top-left corner to cell (r, c)
```

#### Base Cases
Start cell:
```text
dp[0][0] = grid[0][0]
```

First row:
- can only be reached from the left

So:
```text
dp[0][c] = dp[0][c - 1] + grid[0][c]
```

First column:
- can only be reached from above

So:
```text
dp[r][0] = dp[r - 1][0] + grid[r][0]
```

#### Transition
For interior cells:
```text
dp[r][c] = min(dp[r - 1][c], dp[r][c - 1]) + grid[r][c]
```

#### Why This Differs From LC 62
- `LC 62` counts valid paths:
  - add paths from up and left
- `LC 64` optimizes path cost:
  - choose the cheaper predecessor and add current cell cost

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
- mixing invalid directions into the recurrence with `0`
- forgetting explicit first-row / first-column initialization
- saying it is "same as LC 62" without noting count-vs-cost difference
- using `inf` in Python without importing it

#### Strong Spoken Explanation
I define `dp[r][c]` as the minimum path sum to reach cell `(r, c)`. The start cell is `grid[0][0]`. The first row and first column are accumulated sums because each boundary cell has only one legal incoming direction. For interior cells, the path must come from either above or left, so I take the smaller predecessor sum and add the current cell value. This is optimization DP, not counting DP, so the recurrence is `min(...) + grid[r][c]`.

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

```python
from typing import List

class Solution:
    def minPathSum(self, grid: List[List[int]]) -> int:
        m, n = len(grid), len(grid[0])
        dp = [float('inf')] * n
        dp[0] = 0

        for r in range(m):
            for c in range(n):
                if c == 0:
                    dp[c] += grid[r][c]
                else:
                    dp[c] = grid[r][c] + min(dp[c], dp[c - 1])

        return dp[-1]
```

## Complexity

Time O(mn), Space O(n).

## Mistakes To Watch

- Using count-path recurrence instead of min-cost recurrence.
- Bad first row/column initialization.

## Final Interview Explanation

Start from the state definition, then explain why the transition preserves that state. If there is a loop direction, state compression, or a similar-looking problem with a different answer shape, call that out explicitly because that is where this problem family usually breaks down.
