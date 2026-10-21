---
title: "LeetCode 872: Leaf-Similar Trees"
summary: "LeetCode 872 解題筆記：用 DFS 由左到右收集葉子；BFS 收集的順序是一層一層，不是由左到右"
description: "2022-09-17 的 LeetCode 872 解題紀錄"
date: 2022-09-17
tags: ["easy", "tree", "depth-first-search", "binary-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-09-17
- 提交紀錄：Wrong Answer ×2 → Accepted ×7 → Runtime Error → Accepted

## 解題思路

葉子序列是**由左到右**的順序。DFS（先左後右）收集到的葉子剛好就是這個順序（[Tree]({{< relref "/algorithm/Tree" >}}) 模板一）。兩棵樹各收集一次再比較。

## 我的嘗試

前兩版用 queue 做 BFS 收集葉子，順序是一層一層的。例如 `[4, None, 3, 2, 2, 8, None, 1]` 和 `[3, 5, None, 4, 8, None, 1]`：由左到右的葉子分別是 `[8, 1]` 和 `[1, 8]`，答案 `False`；BFS 收集到的兩邊都是 `[8, 1]`，回傳 `True`。

## 正確解法

```python
class Solution:
    def leafSimilar(self, root1: Optional[TreeNode], root2: Optional[TreeNode]) -> bool:
        def leaves(node):
            if not node:
                return []
            if not node.left and not node.right:
                return [node.val]
            return leaves(node.left) + leaves(node.right)
        return leaves(root1) == leaves(root2)
```

## 複雜度

時間 `O(n + m)`，空間 `O(n + m)`。

## 要特別避免的錯誤

- 用 BFS 收集時，較淺的葉子會排在較深但比較左邊的葉子前面，順序就錯了。

## 面試口說整理

我用 DFS 先左後右收集兩棵樹的葉子，這樣得到的就是由左到右的順序，再比較兩個序列。時間 `O(n + m)`。
