---
title: "LeetCode 2328: Number of Increasing Paths in a Grid"
summary: "LeetCode 2328 解題筆記：嚴格遞增所以沒有環；dp[cell] = 1 + Σ dp[比它大的鄰居]，依值由大到小處理（或記憶化 DFS），全部加起來"
description: "2026-08-30 的 LeetCode 2328 解題紀錄"
date: 2026-08-30
tags: ["hard", "dynamic-programming", "grid-dp", "memoization", "topological-sort", "matrix"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-08-30
- 提交紀錄：Accepted（一次通過）

## 解題思路

可以往四個方向走，一般的 Grid DP 會有環。但路徑要**嚴格遞增**，只能從小的走到大的，所以沒有環，是一個 DAG。

`dp[cell]` = 從這格出發的遞增路徑數：

```text
dp[cell] = 1（只有自己）+ Σ dp[值比它大的鄰居]
```

依值**由大到小**處理，算到某格時，比它大的鄰居都已經算好了。答案是所有 `dp` 的總和。

## 我的解法

我 AC 的是記憶化 DFS：

```python
from functools import cache

class Solution:
    def countPaths(self, grid: List[List[int]]) -> int:
        MOD = 10 ** 9 + 7
        m, n = len(grid), len(grid[0])

        @cache
        def dfs(r: int, c: int) -> int:            # 從 (r, c) 出發的遞增路徑數
            paths = 1
            for dr, dc in ((0, 1), (1, 0), (0, -1), (-1, 0)):
                nr, nc = r + dr, c + dc
                if 0 <= nr < m and 0 <= nc < n and grid[nr][nc] > grid[r][c]:
                    paths += dfs(nr, nc)
            return paths % MOD

        return sum(dfs(r, c) for r in range(m) for c in range(n)) % MOD
```

格子最多 `10^5` 個，最長的遞增路徑可能很深，遞迴有機會碰到深度上限。依值排序的迴圈版本不會有這個問題：

```python
class Solution:
    def countPaths(self, grid: List[List[int]]) -> int:
        MOD = 10 ** 9 + 7
        m, n = len(grid), len(grid[0])
        dp = [[1] * n for _ in range(m)]
        cells = sorted(((grid[r][c], r, c) for r in range(m) for c in range(n)), reverse=True)
        for val, r, c in cells:                    # 由大到小
            for dr, dc in ((0, 1), (1, 0), (0, -1), (-1, 0)):
                nr, nc = r + dr, c + dc
                if 0 <= nr < m and 0 <= nc < n and grid[nr][nc] > val:
                    dp[r][c] = (dp[r][c] + dp[nr][nc]) % MOD
        return sum(map(sum, dp)) % MOD
```

## 複雜度

時間 `O(mn log(mn))`（排序；記憶化 DFS 是 `O(mn)`），空間 `O(mn)`。

## 要特別避免的錯誤

- 用一般的右 / 下 DP：四個方向都可以走。
- 每個格子自己就是一條路徑，`dp` 初始值是 1。

## 面試口說整理

雖然四個方向都能走，但路徑嚴格遞增，所以沒有環。`dp` 是從這格出發的遞增路徑數，等於 1 加上所有比它大的鄰居的 `dp`。我用記憶化 DFS，或依值由大到小排序後依序算，最後全部加起來。時間 `O(mn)` 到 `O(mn log(mn))`。
