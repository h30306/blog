---
title: "LeetCode 64: Minimum Path Sum"
summary: "LeetCode 解題筆記：Minimum Path Sum"
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
來源筆記：`notes/day30-week6-day2-min-path-sum-triangle-oracle-plan-reading.md`

## 解題思路

這篇整理 Minimum Path Sum 的解題筆記，重點放在 2D optimization DP on a grid、狀態定義、轉移式與容易犯錯的地方。

## 解法

以下內容整理自當天的 learning note，保留英文關鍵句，方便之後直接拿來做面試口說複習。

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

## 收穫

- 先講清楚 state meaning，再寫 recurrence。
- base case、迴圈方向、return value 要在 coding 前確認。
- 如果是 DP 壓縮、graph traversal、或 greedy frontier，要能說出 invariant 為什麼成立。

## 遇到的問題

原始筆記沒有另外紀錄失誤點。
