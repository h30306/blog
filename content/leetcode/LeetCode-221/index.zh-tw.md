---
title: "LeetCode 221: Maximal Square"
summary: "LeetCode 解題筆記：Maximal Square"
description: "2026-06-30 的 LeetCode 學習紀錄"
date: 2026-06-30
tags: ["leetcode", "medium", "dynamic-programming", "grid-dp"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-06-30
來源筆記：`notes/day31-week6-day3-maximal-square-dungeon-game-covering-index-full-scan.md`

## 解題思路

這篇整理 Maximal Square 的解題筆記，重點放在 2D DP on local square geometry、狀態定義、轉移式與容易犯錯的地方。

## 解法

以下內容整理自當天的 learning note，保留英文關鍵句，方便之後直接拿來做面試口說複習。

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

## 收穫

- 先講清楚 state meaning，再寫 recurrence。
- base case、迴圈方向、return value 要在 coding 前確認。
- 如果是 DP 壓縮、graph traversal、或 greedy frontier，要能說出 invariant 為什麼成立。

## 遇到的問題

原始筆記沒有另外紀錄失誤點。
