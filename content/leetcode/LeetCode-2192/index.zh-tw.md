---
title: "LeetCode 2192: All Ancestors of a Node in a DAG"
summary: "LeetCode 解題筆記：All Ancestors of a Node in a DAG"
description: "2026-04-08 的 LeetCode 學習紀錄"
date: 2026-04-08
tags: ["leetcode", "medium", "graph", "topological-sort"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-04-08
來源筆記：`notes/day2-topological-sort-dag-union-find-dns-http.md`

## 解題思路

這篇整理 All Ancestors of a Node in a DAG 的解題筆記，重點放在 Graph traversal — DFS from each source OR BFS (Kahn's) with set propagation、狀態定義、轉移式與容易犯錯的地方。

## 解法

以下內容整理自當天的 learning note，保留英文關鍵句，方便之後直接拿來做面試口說複習。

- **Pattern:** Graph traversal — DFS from each source OR BFS (Kahn's) with set propagation
- **Key insight:** Ancestors are transitive — if 0→1→3, then 0 is an ancestor of 3
- **DFS approach:** For each `src` node (0 to n-1), run DFS and add `src` to every reachable node's ancestor list. Use a fresh `visited` set per DFS to prevent duplicates. Result is auto-sorted because src iterates in order.
- **Common bugs:**
  1. Shared `visited` set across DFS calls — resets nothing, later sources find all nodes already visited
  2. Appending current `node` instead of `src` — only adds direct parent, not transitive ancestors
  3. Appending before visited check — causes duplicate ancestors in diamond-shaped paths

- **BFS approach (optimal):** Use Kahn's topological sort. For each node, `ancestors[neighbor] |= ancestors[node]`. Topological ordering guarantees all ancestors are fully computed before propagating. Uses sets to handle duplicates automatically.
- **Why BFS is faster:** DFS runs V separate traversals = O(V×(V+E)). BFS processes each node once = O(V+E) traversal + set union cost. Single pass, no redundant traversals.
- **Time complexity (BFS):** O(V² log V) — set union O(V²) + final sort O(V² log V)

## 收穫

- 先講清楚 state meaning，再寫 recurrence。
- base case、迴圈方向、return value 要在 coding 前確認。
- 如果是 DP 壓縮、graph traversal、或 greedy frontier，要能說出 invariant 為什麼成立。

## 遇到的問題

原始筆記沒有另外紀錄失誤點。
