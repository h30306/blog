---
title: "LeetCode 1289: Minimum Falling Path Sum II"
summary: "LeetCode 解題筆記：Minimum Falling Path Sum II"
description: "2026-07-05 的 LeetCode 學習紀錄"
date: 2026-07-05
tags: ["hard", "dynamic-programming", "grid-dp"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-07-05
來源筆記：`notes/day34-week6-weekend-day1-min-falling-path-sum-ii-out-of-boundary-paths-query-triage.md`

## 解題思路

這篇整理 Minimum Falling Path Sum II 的解題筆記，重點放在 row-by-row optimization DP with forbidden same-column reuse、狀態定義、轉移式與容易犯錯的地方。

## 解法

以下內容整理自當天的 learning note，保留英文關鍵句，方便之後直接拿來做面試口說複習。

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

## 收穫

- 先講清楚 state meaning，再寫 recurrence。
- base case、迴圈方向、return value 要在 coding 前確認。
- 如果是 DP 壓縮、graph traversal、或 greedy frontier，要能說出 invariant 為什麼成立。

## 遇到的問題

原始筆記沒有另外紀錄失誤點。
