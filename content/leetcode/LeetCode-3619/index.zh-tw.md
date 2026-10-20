---
title: "LeetCode 3619: Count Islands With Total Value Divisible by K"
summary: "LeetCode 3619 解題筆記：網格 flood fill 加總每座島的值；格子到 10^5，用迭代避免遞迴太深"
description: "2025-07-19 的 LeetCode 3619 解題紀錄"
date: 2025-07-19
tags: ["medium", "dfs", "bfs", "matrix", "graph"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2025-07-19
- 提交紀錄：Accepted（一次通過）

## 解題思路

找出每座島（上下左右相連的正數格子），把島上的值加起來，數有幾座島的總和能被 `k` 整除。

就是 LC 200 Number of Islands，只是每座島除了計數，還要加總。

## 我的解法

原本是遞迴的 DFS，走過的格子改成 `-1`：

```python
def search(i, j):
    if i < 0 or i >= n or j >= m or j < 0 or grid[i][j] == -1:
        return 0
    value = grid[i][j]
    if grid[i][j] == 0:
        grid[i][j] = -1
        return 0
    grid[i][j] = -1
    return value + search(i + 1, j) + search(i, j + 1) + search(i - 1, j) + search(i, j - 1)
```

可以 AC，但網格最多 `10^5` 格，一座很長的島會讓遞迴超過 Python 預設的上限。改成 stack 迭代比較安全：

```python
class Solution:
    def countIslands(self, grid: List[List[int]], k: int) -> int:
        m, n = len(grid), len(grid[0])
        res = 0
        for i in range(m):
            for j in range(n):
                if grid[i][j] <= 0:
                    continue
                total = grid[i][j]
                grid[i][j] = 0                     # 標記走過
                stack = [(i, j)]
                while stack:
                    r, c = stack.pop()
                    for nr, nc in ((r + 1, c), (r - 1, c), (r, c + 1), (r, c - 1)):
                        if 0 <= nr < m and 0 <= nc < n and grid[nr][nc] > 0:
                            total += grid[nr][nc]
                            grid[nr][nc] = 0
                            stack.append((nr, nc))
                if total % k == 0:
                    res += 1
        return res
```

把走過的格子直接改成 0，就不需要另外一個 `-1` 狀態，也不用區分「水」和「走過的陸地」。

## 複雜度

時間 `O(mn)`，空間 `O(mn)`（stack 最壞情況）。

## 要特別避免的錯誤

- 遞迴 DFS 在大網格上超過遞迴上限。
- 推進 stack 之前沒有標記：同一格會被推好幾次、重複加總。

## 面試口說整理

這是 Number of Islands 加上加總。我掃過每個格子，遇到還沒走過的陸地就用 stack 做 flood fill，邊走邊加總並把格子改成 0 當作標記。整座島走完後檢查總和能不能被 `k` 整除。每格只處理一次，時間 `O(mn)`，用迭代避免大網格的遞迴深度問題。
