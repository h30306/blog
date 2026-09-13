---
title: "LeetCode 207: Course Schedule"
summary: "LeetCode 解題筆記：Course Schedule"
description: "2026-04-08 的 LeetCode 學習紀錄"
date: 2026-04-08
tags: ["medium", "graph", "topological-sort"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-04-08
來源筆記：`notes/day1-topological-sort-osi-model.md`

## 解題思路

這篇整理 Course Schedule 的解題筆記，重點放在 Topological Sort (Kahn's BFS)、狀態定義、轉移式與容易犯錯的地方。

## 解法

以下內容整理自當天的 learning note，保留英文關鍵句，方便之後直接拿來做面試口說複習。

- **Pattern:** Topological Sort (Kahn's BFS)
- **Key insight:** If a valid topological ordering exists → no cycle → return true
- **Approach:** Build adjacency list + in-degree array. Add all nodes with in-degree 0 to queue. Process queue — for each node, reduce neighbor's in-degree; if it hits 0, add to queue. If completed == numCourses → no cycle.
- **Complexity:** Time O(V+E), Space O(V+E)
- **Why deque over list:** `list.pop(0)` is O(n) — shifts all elements. `deque.popleft()` is O(1) — moves a pointer.

## 收穫

- 先講清楚 state meaning，再寫 recurrence。
- base case、迴圈方向、return value 要在 coding 前確認。
- 如果是 DP 壓縮、graph traversal、或 greedy frontier，要能說出 invariant 為什麼成立。

## 遇到的問題

原始筆記沒有另外紀錄失誤點。
