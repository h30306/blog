---
title: "LeetCode 102: Binary Tree Level Order Traversal"
summary: "LeetCode 102 解題筆記：BFS 一次處理一整層，用目前這層的節點產生下一層；空樹回傳空 list"
description: "2022-10-29 的 LeetCode 102 解題紀錄"
date: 2022-10-29
tags: ["medium", "tree", "breadth-first-search", "binary-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-10-29
- 提交紀錄：Wrong Answer → Runtime Error ×2 → Time Limit Exceeded → Wrong Answer → Runtime Error → Wrong Answer → Accepted → Wrong Answer → Accepted ×4

## 解題思路

BFS 天生就是一層一層走（[Tree]({{< relref "/algorithm/Tree" >}}) 模板二）。每一輪拿出目前這層的所有節點，記錄它們的值，同時把它們的小孩收集成下一層。

## 我的嘗試

大部分的錯都在空樹：回傳了 `[[]]`（多了一層空的）、用了沒定義的變數，或迴圈沒有結束條件（TLE）；還有一版回傳的是 `[3]` 而不是 `[[3]]`。

## 正確解法

```python
class Solution:
    def levelOrder(self, root: Optional[TreeNode]) -> List[List[int]]:
        res, level = [], [root] if root else []
        while level:
            res.append([n.val for n in level])
            level = [c for n in level for c in (n.left, n.right) if c]
        return res
```

## 複雜度

時間 `O(n)`，空間 `O(w)`，`w` 是最寬那層的節點數。

## 要特別避免的錯誤

- 空樹要回傳 `[]`，不是 `[[]]`。

## 面試口說整理

我用 BFS，每一輪處理一整層：記錄這層的值，再把所有小孩收集成下一層，直到沒有節點。時間 `O(n)`。
