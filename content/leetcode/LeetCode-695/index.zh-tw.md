---
title: "LeetCode 695: Max Area of Island"
summary: "LeetCode 695 解題筆記：每遇到一個沒走過的 1 就 DFS 整座島，數格子數，取最大值；格子是整數 1，不是字串"
description: "2022-10-30 的 LeetCode 695 解題紀錄"
date: 2022-10-30
tags: ["medium", "array", "depth-first-search", "breadth-first-search", "union-find"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-10-30
- 提交紀錄：Wrong Answer → Accepted

## 解題思路

連通塊（[BFS]({{< relref "/algorithm/BFS" >}}) 模板二）：掃過每一格，遇到 `1` 就從它開始 DFS，把走過的格子改成 0（原地標記），數這座島有幾格，取最大值。這題的格子是**整數** `0`、`1`，跟 LC 200 的字串 `"1"` 不一樣。

## 我的嘗試

第一版從 LC 200 改過來，**比較的還是字串 `'1'`**，但這題的格子是整數，永遠不相等：`[[1]]` 回傳 0。改成 `1` 就 AC 了。

## 正確解法

```python
class Solution:
    def maxAreaOfIsland(self, grid: List[List[int]]) -> int:
        m, n = len(grid), len(grid[0])
        def dfs(i, j):
            if i < 0 or j < 0 or i >= m or j >= n or grid[i][j] != 1:
                return 0
            grid[i][j] = 0
            return 1 + dfs(i + 1, j) + dfs(i - 1, j) + dfs(i, j + 1) + dfs(i, j - 1)
        return max((dfs(i, j) for i in range(m) for j in range(n)), default=0)
```

## 複雜度

時間 `O(mn)`，空間 `O(mn)`（遞迴深度）。

## 要特別避免的錯誤

- 格子是整數，不要跟 `'1'` 比。

## 面試口說整理

我掃過每一格，遇到 1 就 DFS 整座島，把走過的格子改成 0 並數格子數，取最大值。每格只走一次，時間 `O(mn)`。
