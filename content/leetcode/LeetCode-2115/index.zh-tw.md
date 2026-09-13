---
title: "LeetCode 2115: Find All Possible Recipes from Given Supplies"
summary: "LeetCode 解題筆記：Find All Possible Recipes from Given Supplies"
description: "2026-04-11 的 LeetCode 學習紀錄"
date: 2026-04-11
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
第一次嘗試：2026-04-11
來源筆記：`notes/day3-topological-sort-tcp-sockets-load-balancer.md`

## 解題思路

這篇整理 Find All Possible Recipes from Given Supplies 的解題筆記，重點放在 Topological Sort / Dependency unlocking、狀態定義、轉移式與容易犯錯的地方。

## 解法

以下內容整理自當天的 learning note，保留英文關鍵句，方便之後直接拿來做面試口說複習。

- **Pattern:** Topological Sort / Dependency unlocking
- **Key insight:** Supplies are initially available nodes. A recipe becomes available when all its required ingredients are available.
- **Approach:** Build graph from `ingredient -> recipes depending on it`. Track each recipe's in-degree as number of missing ingredients. Start BFS queue with all supplies. When an available ingredient unlocks a recipe, decrement that recipe's in-degree. If it becomes 0, add recipe to answer and queue because it can become an ingredient for other recipes.
- **Mental model:** This is like Course Schedule, but starting nodes are supplies instead of zero in-degree recipes only.
- **Cycle behavior:** Recipes in cycles or recipes depending on unavailable ingredients never reach in-degree 0.
- **Complexity:** Time O(total ingredients + recipes), Space O(total ingredients + recipes)
- **Common bugs:** Building edge direction as `recipe -> ingredient`, not adding newly created recipes back into the queue, treating unavailable ingredients as immediate failure instead of simply never unlocking.

## 收穫

- 先講清楚 state meaning，再寫 recurrence。
- base case、迴圈方向、return value 要在 coding 前確認。
- 如果是 DP 壓縮、graph traversal、或 greedy frontier，要能說出 invariant 為什麼成立。

## 遇到的問題

原始筆記沒有另外紀錄失誤點。
