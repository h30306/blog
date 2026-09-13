---
title: "LeetCode 851: Loud and Rich"
summary: "LeetCode 解題筆記：Loud and Rich"
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

這篇整理 Loud and Rich 的解題筆記，重點放在 Topological BFS propagation、狀態定義、轉移式與容易犯錯的地方。

## 解法

以下內容整理自當天的 learning note，保留英文關鍵句，方便之後直接拿來做面試口說複習。

- **Reason for replacement:** `LC 1203 Sort Items by Groups Respecting Dependencies` is too difficult for the current point in the topo sequence and should be treated as a capstone problem.
- **Target:** Practice topo propagation on a medium-level dependency graph before attempting LC 1203.
- **Interview focus:** Choose correct graph direction and propagate the quietest richer person from richer nodes to poorer nodes.
- **Pattern:** Topological BFS propagation.
- **Graph direction:** `richer -> poorer`.
- **Why this direction:** The quietest person known for a richer node can affect every poorer node reachable from it.
- **State meaning:** `answer[i]` stores the person index of the quietest known person among people at least as rich as `i`, not the quiet value itself.
- **Update rule:** When processing `rich -> poor`, if `quiet[answer[rich]] < quiet[answer[poor]]`, set `answer[poor] = answer[rich]`.
- **Queue initialization:** Start from people with indegree 0, meaning nobody is richer than them.
- **Complexity:** O(n + richer.length), Space O(n + richer.length).

## 收穫

- 先講清楚 state meaning，再寫 recurrence。
- base case、迴圈方向、return value 要在 coding 前確認。
- 如果是 DP 壓縮、graph traversal、或 greedy frontier，要能說出 invariant 為什麼成立。

## 遇到的問題

Completed.
