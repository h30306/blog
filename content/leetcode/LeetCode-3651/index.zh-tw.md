---
title: "LeetCode 3651: Minimum Cost Path with Teleportations"
summary: "LeetCode 3651 解題筆記：一層一層算傳送次數；傳送到某格的成本是上一層「值 >= 它的格子」的最小值，排序後用前綴最小值求，再跑一次右 / 下的 Grid DP"
description: "2026-06-26 的 LeetCode 3651 解題紀錄"
date: 2026-06-26
tags: ["hard", "dynamic-programming", "grid-dp", "matrix", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-06-26
- 提交紀錄：Accepted ×3

## 解題思路

`dp_t[r][c]` = 最多傳送 `t` 次、走到 `(r, c)` 的最小成本。

- **`t = 0`**：一般的右 / 下 Grid DP。
- **從第 `t - 1` 層到第 `t` 層**：
  1. 傳送：可以從任何值 `>=` `grid[r][c]` 的格子傳過來，成本 0。所以「傳送到 `(r, c)` 的起始成本」= 上一層所有值 `>= grid[r][c]` 的格子的最小 `dp`。把格子依值**由大到小**排序，掃過去維護前綴最小值。
  2. 傳送之後還可以往右 / 下走，再跑一次 Grid DP。

每一層的終點都更新答案，最多 `k` 層。

## 我的解法

```python
class Solution:
    def minCost(self, grid: List[List[int]], k: int) -> int:
        m, n = len(grid), len(grid[0])
        INF = float("inf")
        cells = sorted(((grid[r][c], r, c) for r in range(m) for c in range(n)), reverse=True)

        def walk(dp: List[List[float]]) -> None:     # 一般的右 / 下 DP
            for r in range(m):
                for c in range(n):
                    if r > 0:
                        dp[r][c] = min(dp[r][c], dp[r - 1][c] + grid[r][c])
                    if c > 0:
                        dp[r][c] = min(dp[r][c], dp[r][c - 1] + grid[r][c])

        dp = [[INF] * n for _ in range(m)]
        dp[0][0] = 0
        walk(dp)
        ans = dp[m - 1][n - 1]

        for _ in range(k):
            best_from = {}                           # 值 -> 上一層「值 >= 它」的最小成本
            running = INF
            for val, r, c in cells:                  # 由大到小
                running = min(running, dp[r][c])
                best_from[val] = running
            dp = [[best_from[grid[r][c]] for c in range(n)] for r in range(m)]
            walk(dp)
            ans = min(ans, dp[m - 1][n - 1])
        return ans
```

同樣的值會連續出現，`best_from[val]` 會被覆蓋成「包含所有同值格子」的最小值，所以同值的格子之間也能互相傳送。

## 複雜度

時間 `O(mn log(mn) + k · mn)`，空間 `O(mn)`。

## 要特別避免的錯誤

- 傳送的方向：從**值大的**傳到值小的，所以到 `(r, c)` 要看值 `>=` 它的格子。
- 傳送完要再跑一次一般的 DP，傳送後可以繼續走。

## 面試口說整理

我一層一層算傳送次數。每一層先處理傳送：到某格的成本是上一層所有值不小於它的格子的最小成本，把格子依值由大到小排序、維護前綴最小值就能一次算完；再跑一次右 / 下的 Grid DP。每一層都更新終點的答案。時間 `O(mn log(mn) + k · mn)`。
