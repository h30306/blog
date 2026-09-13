---
title: "LeetCode 931: Minimum Falling Path Sum"
summary: "LeetCode 解題筆記：Minimum Falling Path Sum"
description: "2026-07-04 的 LeetCode 學習紀錄"
date: 2026-07-04
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
第一次嘗試：2026-07-04
來源筆記：`notes/day32-week6-day4-min-falling-path-sum-count-squares-query-vs-index-vs-schema.md`

## 解題思路

這篇整理 Minimum Falling Path Sum 的解題筆記，重點放在 2D optimization DP with three incoming directions、狀態定義、轉移式與容易犯錯的地方。

## 解法

以下內容整理自當天的 learning note，保留英文關鍵句，方便之後直接拿來做面試口說複習。

- **Pattern:** 2D optimization DP with three incoming directions.

## Why This Fits
Each cell in row `r` can be reached from exactly one of 3 cells in row `r - 1`:
- up-left
- up
- up-right

The graph is still acyclic and local, so DP fits cleanly.

## Core State / Invariant
```text
dp[r][c] = minimum falling path sum that ends at cell (r, c)
```

That state is exact because the question asks for:
```text
the minimum sum of any valid falling path from the first row to the last row
```

## Base Case
First row:
```text
dp[0][c] = matrix[0][c]
```

Reason:
- a falling path can start at any cell in the first row

## Transition
For each lower-row cell:
```text
dp[r][c] = matrix[r][c] + min(
    dp[r - 1][c],
    dp[r - 1][c - 1] if valid,
    dp[r - 1][c + 1] if valid
)
```

## Final Answer
```text
answer = min(dp[last_row][c] for all c)
```

Because the path may end at any column in the last row.

## Complexity
```text
Time: O(n^2)
Space: O(n^2)
```

Can be compressed to:
```text
Space: O(n)
```

## Common Mistakes
- returning `dp[last_row][last_col]` instead of the min over the last row
- forgetting diagonal parents
- mixing invalid columns into the recurrence without guarding them
- saying it is the same as `LC 64` when the predecessor set and answer shape are different

## Strong Spoken Explanation
I define `dp[r][c]` as the minimum falling path sum ending at cell `(r, c)`. The first row is the base case because a path can start at any top-row cell. For each later cell, I take the minimum among the legal parents from the previous row: up-left, up, and up-right, then add the current cell value. The final answer is the minimum value in the last row because a falling path can end in any column there.

## 收穫

- 先講清楚 state meaning，再寫 recurrence。
- base case、迴圈方向、return value 要在 coding 前確認。
- 如果是 DP 壓縮、graph traversal、或 greedy frontier，要能說出 invariant 為什麼成立。

## 遇到的問題

原始筆記沒有另外紀錄失誤點。
