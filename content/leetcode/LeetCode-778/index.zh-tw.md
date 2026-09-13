---
title: "LeetCode 778: Swim in Rising Water"
summary: "LeetCode 解題筆記：Swim in Rising Water"
description: "2026-04-18 的 LeetCode 學習紀錄"
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
來源筆記：`notes/day7-week2-dijkstra-http.md`

## 解題思路

這篇整理 Swim in Rising Water 的解題筆記，重點放在 Dijkstra variant on grid、狀態定義、轉移式與容易犯錯的地方。

## 解法

以下內容整理自當天的 learning note，保留英文關鍵句，方便之後直接拿來做面試口說複習。

- **Pattern:** Dijkstra variant on grid.
- **Graph type:** Grid graph; each cell is a node.
- **Path cost:** Maximum elevation value along the path.
- **State in heap:** `(time_required, row, col)`.
- **Return condition:** Return when bottom-right cell is popped from heap.

## Interview-Ready Explanation
This is a shortest-path problem on a grid graph. The cost of a path is the maximum elevation value of any cell on that path, because at time `t`, I can only enter cells with elevation `<= t`. Dijkstra works because when I extend a path to a neighbor, the new cost is `max(current_time, grid[nr][nc])`, so the path cost never decreases. I store `(time_required, row, col)` in a min-heap. When a cell is popped for the first time, its minimum required time is finalized. When the destination is popped, I return that time.

## Preferred Implementation Detail
Prefer pushing the full path cost:
```python
new_time = max(time, grid[nr][nc])
heappush(heap, (new_time, nr, nc))
```

This matches the Dijkstra explanation directly.

## 收穫

- 先講清楚 state meaning，再寫 recurrence。
- base case、迴圈方向、return value 要在 coding 前確認。
- 如果是 DP 壓縮、graph traversal、或 greedy frontier，要能說出 invariant 為什麼成立。

## 遇到的問題

Completed; prefer direct Dijkstra wording in interviews.
