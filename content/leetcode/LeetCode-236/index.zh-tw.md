---
title: "LeetCode 236: Lowest Common Ancestor of a Binary Tree"
summary: "LeetCode 236 解題筆記：遞迴回傳子樹裡找到的 p 或 q；左右都找到代表在這裡分岔，這個節點就是 LCA"
description: "2022-11-18 的 LeetCode 236 解題紀錄"
date: 2022-11-18
tags: ["medium", "tree", "depth-first-search", "binary-tree", "binary-lifting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-11-18
- 提交紀錄：Runtime Error → Wrong Answer → Accepted ×6

## 解題思路

一般二元樹沒有大小關係，要用遞迴的回傳值（[Tree]({{< relref "/algorithm/Tree" >}}) 模板四）：

- 走到 `None`、`p` 或 `q` 就回傳自己。
- 左右子樹都回傳非空：`p`、`q` 分在兩邊，目前節點就是 LCA。
- 只有一邊非空：答案在那一邊，往上傳。

## 我的嘗試

前兩版直接套用 LC 235 的 BST 寫法，用大小決定往左或往右，但**一般二元樹沒有大小關係**。例如 `[8, 45, 61]` 裡 `p = 61`、`q = 45`：答案是根 8，這版因為 8 比兩個都小，往右走了。改成遞迴回傳值的寫法就 AC 了。

## 正確解法

```python
class Solution:
    def lowestCommonAncestor(self, root: 'TreeNode', p: 'TreeNode', q: 'TreeNode') -> 'TreeNode':
        if not root or root is p or root is q:
            return root
        left = self.lowestCommonAncestor(root.left, p, q)
        right = self.lowestCommonAncestor(root.right, p, q)
        if left and right:
            return root
        return left or right
```

## 複雜度

時間 `O(n)`，空間 `O(h)`。

## 要特別避免的錯誤

- 遇到 `p` 或 `q` 就可以直接回傳，不用再往下找：另一個如果在它下面，它本身就是 LCA。

## 面試口說整理

我用遞迴，遇到空節點、`p` 或 `q` 就回傳自己。左右兩邊都有回傳，代表在這裡分岔，目前節點就是 LCA；否則把有回傳的那一邊往上傳。時間 `O(n)`。
