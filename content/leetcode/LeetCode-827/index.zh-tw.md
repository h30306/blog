---
title: "LeetCode 827: Making A Large Island"
summary: "LeetCode 827 解題筆記：先幫每座島編號並記大小，再對每個 0 看四周有哪些不同的島，大小相加再加 1"
description: "2026-10-17 的 LeetCode 827 解題紀錄"
date: 2026-10-17
tags: ["hard", "dfs", "bfs", "matrix", "union-find"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-10-17
- 提交紀錄：Accepted ×2（遞迴 DFS）→ Accepted（改成迭代）

## 解題思路

最多把一個 0 變成 1，問最大的島有多大。

暴力做法是每個 0 都試著翻成 1，再重新算一次最大的島，`O(n^4)` 太慢。

**先把島的資訊算好**：

1. 第一次掃描：幫每座島編號（從 2 開始，避免跟 0、1 混淆），把島上的格子改成編號，同時用 dict 記錄每個編號的大小。
2. 第二次掃描：對每個 0，看上下左右的鄰居屬於哪些島，**用 set 去重**後把大小加總，再加上自己這格。

如果整個網格都是 1，沒有 0 可以翻，答案就是那座島的大小。

## 我的解法

```python
class Solution:
    def largestIsland(self, grid: List[List[int]]) -> int:
        n = len(grid)
        size = {}
        label = 2
        dirs = ((1, 0), (-1, 0), (0, 1), (0, -1))

        for r in range(n):
            for c in range(n):
                if grid[r][c] != 1:
                    continue
                grid[r][c] = label
                stack, count = [(r, c)], 1
                while stack:
                    x, y = stack.pop()
                    for dx, dy in dirs:
                        nx, ny = x + dx, y + dy
                        if 0 <= nx < n and 0 <= ny < n and grid[nx][ny] == 1:
                            grid[nx][ny] = label
                            count += 1
                            stack.append((nx, ny))
                size[label] = count
                label += 1

        best = max(size.values(), default=0)
        for r in range(n):
            for c in range(n):
                if grid[r][c] == 0:
                    labels = {grid[r + dr][c + dc] for dr, dc in dirs
                              if 0 <= r + dr < n and 0 <= c + dc < n and grid[r + dr][c + dc] > 1}
                    best = max(best, 1 + sum(size[l] for l in labels))
        return best
```

第一版用遞迴 DFS 標記島，`n = 500` 時一座島最多 `2.5 * 10^5` 格，遞迴可能太深；第三版改成用 stack 迭代。

## 複雜度

時間 `O(n^2)`，空間 `O(n^2)`。

## 要特別避免的錯誤

- 鄰居屬於同一座島卻重複相加：一定要用 set 去重編號。
- 島的編號從 1 開始：會跟原本的陸地 1 混在一起，分不清楚哪些已經標記過。
- 忘記全部都是 1 的情況：沒有 0 可以翻，答案是整座島的大小。

## 面試口說整理

我先掃一遍，把每座島標上從 2 開始的編號，並記下每個編號的大小。接著對每個 0，收集上下左右鄰居的島編號，用 set 去重後把大小加總再加 1，就是把這格翻成 1 之後的島。答案取所有 0 的最大值，也要考慮全部都是陸地的情況。兩次掃描，時間 `O(n^2)`。
