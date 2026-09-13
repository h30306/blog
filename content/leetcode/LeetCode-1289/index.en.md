---
title: "LeetCode 1289: Minimum Falling Path Sum II"
summary: "LeetCode Problem Solving - row-by-row optimization DP with forbidden same-column reuse"
description: "LeetCode study note from 2026-07-05"
date: 2026-07-05
tags: ["leetcode", "hard", "dynamic-programming", "grid-dp"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-07-05
Source Note: `notes/day34-week6-weekend-day1-min-falling-path-sum-ii-out-of-boundary-paths-query-triage.md`

## Intuition

I still define dp[r][c] as the minimum valid falling path sum ending at (r, c), but the constraint is that adjacent rows cannot use the same column. The naive transition checks every previousrow column except c, which is

Pattern: row-by-row optimization DP with forbidden same-column reuse

## Approach

- **Pattern:** row-by-row optimization DP with forbidden same-column reuse.

## Why This Fits
This is still DP because:
- the path is built one row at a time
- the best answer for the current row depends only on the previous row

But the rule changed:
```text
the next row cannot choose the same column as the previous row
```

The naive recurrence is still correct:
```text
dp[r][c] = grid[r][c] + min(dp[r - 1][prev_c] for all prev_c != c)
```

But that costs `O(n)` per cell and becomes:
```text
O(n^3)
```

## Core State / Invariant
```text
dp[r][c] = minimum falling path sum ending at row r, column c,
subject to not using the same column in adjacent rows
```

## Key Optimization
For the previous row, track:
- smallest value
- column of that smallest value
- second-smallest value

Then for current column `c`:
- if `c` is not the min column from the previous row, use previous-row min
- otherwise use previous-row second min

## Optimized Transition
```text
dp[r][c] = grid[r][c] + (
    prev_min if c != prev_min_col else prev_second_min
)
```

## Base Case
First row:
```text
dp[0][c] = grid[0][c]
```

## Final Answer
```text
min(dp[last_row][c] for all c)
```

## Complexity
Naive:
```text
Time: O(n^3)
Space: O(n^2)
```

Optimized:
```text
Time: O(n^2)
Space: O(n^2)
```

Can be compressed to:
```text
Space: O(n)
```

## Common Mistakes
- giving the naive recurrence but not noticing it is too slow
- forgetting why second-minimum is needed
- mixing up min value with min column
- returning one fixed cell instead of the min of the last row

## Strong Spoken Explanation
I still define `dp[r][c]` as the minimum valid falling path sum ending at `(r, c)`, but the constraint is that adjacent rows cannot use the same column. The naive transition checks every previous-row column except `c`, which is correct but too slow. The optimization is to keep the smallest and second-smallest DP values from the previous row. Then for each current column, I use the previous-row minimum unless it came from the same column, in which case I use the second minimum. That reduces the time from `O(n^3)` to `O(n^2)`.

## Findings

- Keep the state meaning explicit before writing the transition.
- Check base cases and return value before trusting the recurrence.
- Explain why the iteration order or traversal order preserves the intended invariant.

## Encountered Problems

Captured from the learning note; no separate failure note was recorded.
