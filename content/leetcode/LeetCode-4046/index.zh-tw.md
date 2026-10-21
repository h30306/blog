---
title: "LeetCode 4046: Minimum Cost Path With At Most K Turns"
summary: "LeetCode 4046 解題筆記：Dijkstra 的狀態加上「上一步方向」和「已轉彎數」；同一格同方向時，先處理的成本較低，轉彎數也較少的話就支配後面的狀態"
description: "2026-09-11 的 LeetCode 4046 解題紀錄"
date: 2026-09-11
tags: ["hard", "graph", "shortest-path", "heap", "matrix"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-09-11
- 提交紀錄：Wrong Answer ×2 → Accepted

## 解題思路

格子的成本都 `>= 0`，可以重複走，求最小總成本，是 Dijkstra。但限制「最多轉 `k` 次彎」不是距離本身，要放進狀態（[Shortest Path]({{< relref "/algorithm/Shortest-Path" >}}) 的「把限制放進狀態」）：`(row, col, 上一步方向, 已轉彎數)`。

- 換方向時轉彎數加 1；第一步沒有上一步方向，不算轉彎。
- 轉彎數超過 `k` 的狀態不要。
- 同一個 `(row, col, 方向)`，先從 heap 拿出來的成本一定比較低；如果它的轉彎數也比較少（或一樣），後面的狀態就被支配了，直接跳過。

## 我的嘗試

前兩版把轉彎數寫成 `turns + 1 if 轉彎 else 0`。Python 的條件運算式優先順序最低，這是在 `turns + 1` 和 `0` 之間二選一，**直走時轉彎數被歸零**。例如 `grid = [[6, 6, 3], [4, 1, 1], [3, 2, 2]]`、`k = 1`：答案是 17，這版回傳 14，用的是轉兩次彎的路線。加上括號 `turns + (1 if ... else 0)` 就 AC 了。

## 正確解法

```python
class Solution:
    def minCost(self, grid: List[List[int]], k: int) -> int:
        m, n = len(grid), len(grid[0])
        dirs = ((0, 1), (1, 0), (0, -1), (-1, 0))
        best_turns = {}                            # (r, c, d) -> 處理過的最少轉彎數
        pq = [(grid[0][0], 0, 0, 0, -1)]           # cost, turns, r, c, 上一步方向
        while pq:
            cost, t, r, c, d = heapq.heappop(pq)
            if (r, c) == (m - 1, n - 1):
                return cost
            if best_turns.get((r, c, d), k + 1) <= t:
                continue
            best_turns[(r, c, d)] = t
            for nd, (dr, dc) in enumerate(dirs):
                nr, nc = r + dr, c + dc
                nt = t + (d != -1 and nd != d)
                if 0 <= nr < m and 0 <= nc < n and nt <= k:
                    heapq.heappush(pq, (cost + grid[nr][nc], nt, nr, nc, nd))
        return -1
```

## 複雜度

狀態最多 `m · n · 4 · (k + 1)` 個，時間 `O(S log S)`，`S` 是狀態數，空間 `O(S)`。

## 要特別避免的錯誤

- `a + 1 if cond else 0` 是 `(a + 1) if cond else 0`，要加括號。
- 只用 `(row, col)` 當 visited 不夠，方向和轉彎數都會影響之後能走的路。

## 面試口說整理

成本非負、要最小總和，所以用 Dijkstra，但狀態要包含上一步方向和已轉彎數，換方向就加 1，超過 `k` 就不走。同一格同方向時，先拿出來的成本較低，如果轉彎也比較少，後面的狀態就沒有意義，可以跳過。第一次拿到終點時就是答案。
