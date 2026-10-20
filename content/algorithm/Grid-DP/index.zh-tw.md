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

## Grid DP + 額外狀態

格子座標不夠描述狀態時，多加一維：

- **最多傳送 k 次**（LC 3651）：一層一層算，第 `t` 層是用了 `t` 次傳送。傳送到某格的成本是「值 `>=` 它的所有格子在上一層的最小值」，把格子依值由大到小排序、維護前綴最小值，再跑一次一般的右 / 下 DP。
- **括號路徑**（LC 2267）：狀態是 `(r, c, 目前的左括號餘額)`。餘額不能是負的，也不能超過剩下的步數（不然關不完）。
- **嚴格遞增的路徑數**（LC 2328）：可以往四個方向走，但值嚴格遞增，所以沒有環。依值由大到小處理，`dp[cell] = 1 + Σ dp[比它大的鄰居]`，或用記憶化 DFS。

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
- `LC 3651` Minimum Cost Path with Teleportations
- `LC 2267` Check if There Is a Valid Parentheses String Path
- `LC 2328` Number of Increasing Paths in a Grid
