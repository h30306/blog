---
title: "Grid DP"
summary: "路徑計數、成本最佳化、反向資源 DP 與局部幾何"
description: "演算法學習"
date: 2026-09-13
tags: ["dynamic-programming", "grid-dp"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 介紹

Grid DP 用在 movement rules 讓 cell 之間產生 local dependencies 的題目。最重要的一步是先定義每個 cell 的意義：

- 到達這格有幾種方法
- 到達這格的最低成本
- 進入這格前至少需要多少 health
- 以這格為右下角的最大正方形邊長

state 一變，recurrence 就會跟著變。

## Counting Paths

如果只能往右或往下，且沒有障礙物：

```text
dp[r][c] = 從起點走到 (r, c) 的 path 數量
dp[r][c] = dp[r - 1][c] + dp[r][c - 1]
```

有障礙物時，blocked cells 貢獻 `0` paths。

## Minimum Cost Paths

Minimum path sum 的 state 是：

```text
dp[r][c] = 到達 (r, c) 的最低成本
dp[r][c] = grid[r][c] + min(up, left)
```

這和 counting paths 不同。Counting 是把 predecessor 相加；optimization 是選較便宜的 predecessor。

## Reverse DP

有些 grid 題要反著做。Dungeon Game 的 state 是：

```text
dp[r][c] = 進入 (r, c) 時至少需要多少 health
```

recurrence 會看未來較便宜的 next state，然後把 health clamp 到至少 `1`。

## Local Geometry DP

正方形題目的 state 是：

```text
dp[r][c] = 以 (r, c) 為右下角的最大 all-1 square 邊長
```

如果目前 cell 是 `1`：

```text
dp[r][c] = 1 + min(top, left, diagonal)
```

diagonal 不能省，因為更大的 square 需要合法的 inner square。

## 常見錯誤

- 還沒定義 `dp[r][c]` 就先寫 recurrence。
- path 可以在最後一列任何位置結束，卻只回傳 bottom-right。
- min-cost 題誤用 count-path 的加法。
- 忘記 first row / first column 的 boundary behavior。
- 題目其實需要 future survival constraints，卻硬做 forward DP。

## 相關 LeetCode

- `LC 62` Unique Paths
- `LC 63` Unique Paths II
- `LC 64` Minimum Path Sum
- `LC 120` Triangle
- `LC 174` Dungeon Game
- `LC 221` Maximal Square
- `LC 576` Out of Boundary Paths
- `LC 931` Minimum Falling Path Sum
- `LC 1277` Count Square Submatrices With All Ones
- `LC 1289` Minimum Falling Path Sum II
