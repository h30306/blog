---
title: "LeetCode 144: Binary Tree Preorder Traversal"
summary: "LeetCode 144 解題筆記：迭代的前序遍歷，彈出就記錄，先推右小孩再推左小孩，左邊才會先處理"
description: "2022-07-20 的 LeetCode 144 解題紀錄"
date: 2022-07-20
tags: ["easy", "stack", "tree", "depth-first-search", "binary-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-07-20
- 提交紀錄：Runtime Error → Wrong Answer ×2 → Runtime Error → Accepted ×4

## 解題思路

前序是「根、左、右」，彈出的時候就記錄（[Tree]({{< relref "/algorithm/Tree" >}})）。stack 是後進先出，所以**先推右小孩、再推左小孩**，左邊才會先被彈出來。

## 我的嘗試

大部分的 RE 都是同一個原因：**空樹**時直接取 `root.left` / `root.val`（`root` 是 `None`）。

## 正確解法

```python
class Solution:
    def preorderTraversal(self, root: Optional[TreeNode]) -> List[int]:
        res, stack = [], [root] if root else []
        while stack:
            node = stack.pop()
            res.append(node.val)
            if node.right:
                stack.append(node.right)
            if node.left:
                stack.append(node.left)
        return res
```

## 複雜度

時間 `O(n)`，空間 `O(h)`。

## 要特別避免的錯誤

- 推進 stack 的順序跟想處理的順序相反。

## 面試口說整理

前序是根、左、右，我用 stack，彈出就記錄，先推右再推左，左子樹就會先處理。時間 `O(n)`。
