---
title: "LeetCode 62: Unique Paths"
summary: "LeetCode note for Unique Paths, rebuilt from the original learning note"
description: "Cleaned LeetCode 62 article from 2026-06-27 with note repair points and final solution"
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
Source: Day 29 learning note

## Study Context

This article is rebuilt from the exact LeetCode section in the learning note. I kept the note's repair points, comparison points, and common mistakes, while removing unrelated non-LeetCode material from the same day.

## Learning Note Extract

#### Problem 1 - LC 62 Unique Paths
- **Pattern:** 2D counting DP on a grid.

#### Why This Fits
From any cell, the robot can only arrive from:
- the cell above
- the cell to the left

So the number of ways to reach one cell depends only on smaller subproblems directly adjacent to it.

#### Core State / Invariant
```text
dp[r][c] = number of valid paths from the start to cell (r, c)
```

This is the right state because the question asks for:
```text
how many ways to reach the bottom-right corner
```

So every cell should mean:
```text
answer for this prefix of the grid
```

#### Base Cases
Start cell:
```text
dp[0][0] = 1
```

First row:
- every cell has only one way to be reached:
  - keep moving right

First column:
- every cell has only one way to be reached:
  - keep moving down

So for the obstacle-free version:
```text
dp[0][c] = 1
dp[r][0] = 1
```

#### Transition
For every interior cell:
```text
dp[r][c] = dp[r - 1][c] + dp[r][c - 1]
```

Why:
- every valid path into `(r, c)` must come from exactly one of those two predecessor cells
- the two predecessor sets are disjoint

#### Complexity
```text
Time: O(m * n)
Space: O(m * n)
```

1D compression is possible:
```text
Space: O(n)
```

But the Week 6 interview bar is:
```text
draw or define the 2D table first, then compress only if you still preserve the invariant cleanly
```

#### Common Mistakes
- writing the recurrence before defining what `dp[r][c]` means
- mixing `m/n` dimensions and indexing incorrectly
- forgetting why the first row and first column are all `1`
- jumping to combinatorics instead of showing the DP state first

#### Strong Spoken Explanation
I define `dp[r][c]` as the number of valid paths from the start to cell `(r, c)`. That state fits because the robot can only move right or down, so every path into a cell must come from the cell above or the cell to the left. The start cell has one way to be reached, and every boundary cell in the obstacle-free grid also has only one path. For interior cells, I add the ways from above and from the left. The time complexity is `O(m * n)`, and the space can be either `O(m * n)` or compressed to `O(n)`.

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

```python
class Solution:
    def uniquePaths(self, m: int, n: int) -> int:
        dp = [1] * n
        for _ in range(1, m):
            for c in range(1, n):
                dp[c] += dp[c - 1]
        return dp[-1]
```

## Complexity

Time O(mn), Space O(n).

## Mistakes To Watch

- Confusing this with weighted min path sum.
- Forgetting first row/column base cases.

## Final Interview Explanation

Start from the state definition, then explain why the transition preserves that state. If there is a loop direction, state compression, or a similar-looking problem with a different answer shape, call that out explicitly because that is where this problem family usually breaks down.
