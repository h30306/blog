---
title: "LeetCode 221: Maximal Square"
summary: "LeetCode Problem Solving - 2D DP on local square geometry"
description: "LeetCode study note from 2026-06-30"
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
Source Note: `notes/day31-week6-day3-maximal-square-dungeon-game-covering-index-full-scan.md`

## Intuition

I define dp[r][c] as the side length of the largest all1 square ending at cell (r, c). If the current cell is 0, no square can end here. If it is 1, the square can only grow if the top, left, and topleft neighbors can al

Pattern: 2D DP on local square geometry

## Approach

- **Pattern:** 2D DP on local square geometry.

## Why This Fits
To know the largest all-`1` square ending at `(r, c)`, it is not enough to know one direction.

The cell can only extend a larger square if:
- the current cell is `1`
- the top cell can support a square
- the left cell can support a square
- the top-left diagonal can support the smaller inner square

This is a clean local-structure DP.

## Core State / Invariant
```text
dp[r][c] = side length of the largest all-1 square whose bottom-right corner is (r, c)
```

That state is exact enough because the question asks for:
```text
the largest square area anywhere in the matrix
```

If we know the best square ending at every cell, the global maximum is easy to track.

## Transition
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

## Why The `min(...)` Is Correct
The new square can only be as large as its weakest supporting side:
- top limits vertical extension
- left limits horizontal extension
- top-left limits the inner square

If any one of those is smaller, the larger square is impossible.

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
- using `max(...)` instead of `min(...)`
- forgetting the state is side length, not area
- failing to special-case first row / first column
- saying the diagonal is optional
- returning the max side length instead of squaring it for area

## Strong Spoken Explanation
I define `dp[r][c]` as the side length of the largest all-1 square ending at cell `(r, c)`. If the current cell is `0`, no square can end here. If it is `1`, the square can only grow if the top, left, and top-left neighbors can all support a square of the smaller size. That is why the recurrence is `1 + min(top, left, diagonal)`. I track the largest side seen and square it at the end to get the area.

## Findings

- Keep the state meaning explicit before writing the transition.
- Check base cases and return value before trusting the recurrence.
- Explain why the iteration order or traversal order preserves the intended invariant.

## Encountered Problems

Captured from the learning note; no separate failure note was recorded.
