---
title: "LeetCode 802: Find Eventual Safe States"
summary: "LeetCode 解題筆記：Find Eventual Safe States"
description: "2026-04-13 的 LeetCode 學習紀錄"
date: 2026-04-13
tags: ["leetcode", "medium", "graph", "topological-sort"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-04-13
來源筆記：`notes/day4-tcp-production-behavior.md`

## 解題思路

這篇整理 Find Eventual Safe States 的解題筆記，重點放在 Reverse graph + remaining outdegree topo、狀態定義、轉移式與容易犯錯的地方。

## 解法

以下內容整理自當天的 learning note，保留英文關鍵句，方便之後直接拿來做面試口說複習。

- **Pattern:** Reverse graph + remaining outdegree topo.
- **Key correction:** This is not a DAG problem. The input may contain cycles; the goal is to find nodes that are not in a cycle and cannot reach a cycle.
- **Correct model:** Build `reverse_graph[v] = predecessors that point to v`. Track `outdegree[u] = len(graph[u])`.
- **Queue initialization:** Start with terminal nodes where `outdegree == 0`.
- **Propagation:** When a safe node is processed, decrement the remaining outdegree of its predecessors. If a predecessor reaches 0, all of its outgoing paths lead to safe nodes, so it is safe.
- **Naming issue fixed:** The counter is `outdegree`, not `in_degree`. Calling it `in_degree` is misleading even if the code passes.
- **Complexity:** O(V + E) if returning by final scan; O(V + E + V log V) if sorting result.

## 收穫

- 先講清楚 state meaning，再寫 recurrence。
- base case、迴圈方向、return value 要在 coding 前確認。
- 如果是 DP 壓縮、graph traversal、或 greedy frontier，要能說出 invariant 為什麼成立。

## 遇到的問題

Completed.
