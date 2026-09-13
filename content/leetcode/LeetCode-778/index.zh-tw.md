---
title: "LeetCode 778: Swim in Rising Water"
summary: "LeetCode 778 解題筆記，依照原始 learning note 重新整理"
description: "2026-04-18 的 LeetCode 778 學習紀錄，包含筆記修正點與正確解法"
date: 2026-04-18
tags: ["hard", "graph", "dijkstra", "binary-search"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-04-18
來源：Day 7 learning note

## 學習脈絡

這篇是從 learning note 裡該 LeetCode 題目的段落重新整理出來的版本。我保留當天筆記中的修正點、比較點、容易犯錯的地方，並移除同一天其他非 LeetCode 主題，避免文章內容混題。

## 筆記中提到的相關提醒

- 1. Explain why LC 778 is a Dijkstra variant.

## 當天筆記摘錄

#### Problem 1 - LC 778 Swim in Rising Water
- **Status:** Completed; prefer direct Dijkstra wording in interviews.
- **Pattern:** Dijkstra variant on grid.
- **Graph type:** Grid graph; each cell is a node.
- **Path cost:** Maximum elevation value along the path.
- **State in heap:** `(time_required, row, col)`.
- **Return condition:** Return when bottom-right cell is popped from heap.

#### Interview-Ready Explanation
This is a shortest-path problem on a grid graph. The cost of a path is the maximum elevation value of any cell on that path, because at time `t`, I can only enter cells with elevation `<= t`. Dijkstra works because when I extend a path to a neighbor, the new cost is `max(current_time, grid[nr][nc])`, so the path cost never decreases. I store `(time_required, row, col)` in a min-heap. When a cell is popped for the first time, its minimum required time is finalized. When the destination is popped, I return that time.

#### Preferred Implementation Detail
Prefer pushing the full path cost:
```python
new_time = max(time, grid[nr][nc])
heappush(heap, (new_time, nr, nc))
```

This matches the Dijkstra explanation directly.

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
from heapq import heappop, heappush
from typing import List

class Solution:
    def swimInWater(self, grid: List[List[int]]) -> int:
        n = len(grid)
        seen = [[False] * n for _ in range(n)]
        heap = [(grid[0][0], 0, 0)]
        dirs = [(1,0), (-1,0), (0,1), (0,-1)]

        while heap:
            time, r, c = heappop(heap)
            if seen[r][c]:
                continue
            seen[r][c] = True
            if (r, c) == (n - 1, n - 1):
                return time
            for dr, dc in dirs:
                nr, nc = r + dr, c + dc
                if 0 <= nr < n and 0 <= nc < n and not seen[nr][nc]:
                    heappush(heap, (max(time, grid[nr][nc]), nr, nc))
        return -1
```

## 複雜度

Time O(n^2 log n), Space O(n^2).

## 要特別避免的錯誤

- Summing elevations.
- Using plain BFS despite different required times.

## 面試口說整理

先講清楚 state definition，再說 transition 為什麼維持這個 state。只要這題有 loop direction、狀態壓縮、或題型相似但 answer shape 不同的地方，就要主動講出來，因為那通常就是這類題最容易出錯的點。
