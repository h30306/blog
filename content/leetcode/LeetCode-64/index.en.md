---
title: "LeetCode 64: Minimum Path Sum"
summary: "LeetCode Problem Solving - 2D optimization DP on a grid"
description: "LeetCode study note from 2026-06-27"
date: 2026-06-27
tags: ["leetcode", "medium", "dynamic-programming", "grid-dp"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-06-27
Source Note: `notes/day30-week6-day2-min-path-sum-triangle-oracle-plan-reading.md`

## Intuition

I define dp[r][c] as the minimum path sum to reach cell (r, c). The start cell is grid[0][0]. The first row and first column are accumulated sums because each boundary cell has only one legal incoming direction. For inte

Pattern: 2D optimization DP on a grid

## Approach

- **Pattern:** 2D optimization DP on a grid.

## Why This Fits
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

## Core State / Invariant
```text
dp[r][c] = minimum path sum from the top-left corner to cell (r, c)
```

## Base Cases
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

## Transition
For interior cells:
```text
dp[r][c] = min(dp[r - 1][c], dp[r][c - 1]) + grid[r][c]
```

## Why This Differs From LC 62
- `LC 62` counts valid paths:
  - add paths from up and left
- `LC 64` optimizes path cost:
  - choose the cheaper predecessor and add current cell cost

## Complexity
```text
Time: O(m * n)
Space: O(m * n)
```

Can be compressed to:
```text
Space: O(n)
```

## Common Mistakes
- mixing invalid directions into the recurrence with `0`
- forgetting explicit first-row / first-column initialization
- saying it is "same as LC 62" without noting count-vs-cost difference
- using `inf` in Python without importing it

## Strong Spoken Explanation
I define `dp[r][c]` as the minimum path sum to reach cell `(r, c)`. The start cell is `grid[0][0]`. The first row and first column are accumulated sums because each boundary cell has only one legal incoming direction. For interior cells, the path must come from either above or left, so I take the smaller predecessor sum and add the current cell value. This is optimization DP, not counting DP, so the recurrence is `min(...) + grid[r][c]`.

## Findings

- Keep the state meaning explicit before writing the transition.
- Check base cases and return value before trusting the recurrence.
- Explain why the iteration order or traversal order preserves the intended invariant.

## Encountered Problems

Captured from the learning note; no separate failure note was recorded.
