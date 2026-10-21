---
title: "LeetCode 563: Binary Tree Tilt"
summary: "LeetCode 563 解題筆記：後序回傳子樹的總和，每個節點的 tilt 是左右子樹總和的差，加進答案"
description: "2022-08-27 的 LeetCode 563 解題紀錄"
date: 2022-08-27
tags: ["easy", "tree", "depth-first-search", "binary-tree", "dp-on-trees"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-27
- 提交紀錄：Time Limit Exceeded ×2 → Wrong Answer → Runtime Error ×2 → Wrong Answer ×3 → Accepted

## 解題思路

一個節點的 tilt 是「左子樹**所有節點**的總和」和「右子樹所有節點的總和」的差（[Tree]({{< relref "/algorithm/Tree" >}}) 模板一）。後序遞迴回傳整棵子樹的總和，同時把每個節點的 tilt 加進答案。

## 我的嘗試

前幾版空樹沒處理或用迴圈重複計算（TLE）。之後的錯都在回傳值：遞迴回傳的是**小孩的值**而不是整棵子樹的總和，例如 `[4, 6]`：答案 6，回傳 0；改成加上自己的值之後，回傳的還是 `root.val + 左小孩的值 + 右小孩的值`，更深的節點沒算進去。

## 正確解法

```python
class Solution:
    def findTilt(self, root: Optional[TreeNode]) -> int:
        total = 0
        def subtree_sum(node):
            nonlocal total
            if not node:
                return 0
            l, r = subtree_sum(node.left), subtree_sum(node.right)
            total += abs(l - r)
            return node.val + l + r
        subtree_sum(root)
        return total
```

## 複雜度

時間 `O(n)`，空間 `O(h)`。

## 要特別避免的錯誤

- 回傳的是整棵子樹的總和，不是小孩的值。

## 面試口說整理

我用後序回傳每棵子樹的總和，同時在每個節點把左右總和的差加進答案。只走一次，時間 `O(n)`。
