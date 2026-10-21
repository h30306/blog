---
title: "LeetCode 1448: Count Good Nodes in Binary Tree"
summary: "LeetCode 1448 解題筆記：DFS 往下傳路徑上的最大值，節點的值大於等於它就是好節點"
description: "2022-10-29 的 LeetCode 1448 解題紀錄"
date: 2022-10-29
tags: ["medium", "tree", "depth-first-search", "breadth-first-search", "binary-tree"]
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
- 提交紀錄：Runtime Error ×2 → Accepted

## 解題思路

好節點是「從根到它的路徑上沒有比它大的」。往下走時傳目前路徑的最大值（[Tree]({{< relref "/algorithm/Tree" >}}) 模板一），節點的值 `>=` 最大值就算一個，再用新的最大值往下。

## 我的嘗試

前兩版一版取了 `None` 的屬性，一版用了沒定義的變數；第三版就 AC 了。

## 正確解法

```python
class Solution:
    def goodNodes(self, root: TreeNode) -> int:
        def dfs(node, mx):
            if not node:
                return 0
            good = node.val >= mx
            mx = max(mx, node.val)
            return good + dfs(node.left, mx) + dfs(node.right, mx)
        return dfs(root, root.val)
```

## 複雜度

時間 `O(n)`，空間 `O(h)`。

## 要特別避免的錯誤

- 是 `>=`，跟最大值一樣也算好節點（根本身一定是）。

## 面試口說整理

我用 DFS 往下傳目前路徑上的最大值，節點的值不小於它就是好節點，再用更新後的最大值往下走。時間 `O(n)`。
