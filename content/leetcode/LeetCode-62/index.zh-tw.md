---
title: "LeetCode 62: Unique Paths"
summary: "LeetCode 解題筆記：Unique Paths"
description: "2026-06-27 的 LeetCode 學習紀錄"
date: 2026-06-27
tags: ["medium", "dynamic-programming", "grid-dp"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-06-27
來源筆記：`notes/day29-week6-day1-unique-paths-composite-index-order.md`

## 解題思路

這篇整理 Unique Paths 的解題筆記，重點放在 2D counting DP on a grid、狀態定義、轉移式與容易犯錯的地方。

## 解法

以下內容整理自當天的 learning note，保留英文關鍵句，方便之後直接拿來做面試口說複習。

- **Pattern:** 2D counting DP on a grid.

## Why This Fits
From any cell, the robot can only arrive from:
- the cell above
- the cell to the left

So the number of ways to reach one cell depends only on smaller subproblems directly adjacent to it.

## Core State / Invariant
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

## Base Cases
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

## Transition
For every interior cell:
```text
dp[r][c] = dp[r - 1][c] + dp[r][c - 1]
```

Why:
- every valid path into `(r, c)` must come from exactly one of those two predecessor cells
- the two predecessor sets are disjoint

## Complexity
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

## Common Mistakes
- writing the recurrence before defining what `dp[r][c]` means
- mixing `m/n` dimensions and indexing incorrectly
- forgetting why the first row and first column are all `1`
- jumping to combinatorics instead of showing the DP state first

## Strong Spoken Explanation
I define `dp[r][c]` as the number of valid paths from the start to cell `(r, c)`. That state fits because the robot can only move right or down, so every path into a cell must come from the cell above or the cell to the left. The start cell has one way to be reached, and every boundary cell in the obstacle-free grid also has only one path. For interior cells, I add the ways from above and from the left. The time complexity is `O(m * n)`, and the space can be either `O(m * n)` or compressed to `O(n)`.

## 收穫

- 先講清楚 state meaning，再寫 recurrence。
- base case、迴圈方向、return value 要在 coding 前確認。
- 如果是 DP 壓縮、graph traversal、或 greedy frontier，要能說出 invariant 為什麼成立。

## 遇到的問題

原始筆記沒有另外紀錄失誤點。
