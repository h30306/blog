---
title: "LeetCode 965: Univalued Binary Tree"
summary: "LeetCode 965 解題筆記：每個節點的值都要等於根的值；遞迴時比的是值，不是遞迴回傳的布林值"
description: "2022-09-26 的 LeetCode 965 解題紀錄"
date: 2022-09-26
tags: ["easy", "tree", "depth-first-search", "breadth-first-search", "binary-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-09-26
- 提交紀錄：Wrong Answer ×3 → Runtime Error ×2 → Wrong Answer ×2 → Runtime Error → Wrong Answer ×2 → Accepted → Runtime Error → Wrong Answer → Runtime Error → Accepted → Runtime Error → Accepted ×2

## 解題思路

所有節點都跟根的值一樣（[Tree]({{< relref "/algorithm/Tree" >}}) 模板一）。遞迴檢查：這個節點的值等於目標，而且左右子樹也都是。空的子樹不違反條件，回傳 `True`。

## 我的嘗試

這題提交了 18 次，前面大部分是同一個錯：寫成 `node.val == self.isUnivalTree(node.left) == self.isUnivalTree(node.right)`，**拿節點的值跟遞迴回傳的布林值比**。例如只有一個節點 `[2]`：兩邊回傳 `True`，`2 == True` 不成立，回傳 `False`。之後改成傳入目標值，又有幾次變數沒定義。

## 正確解法

```python
class Solution:
    def isUnivalTree(self, root: Optional[TreeNode]) -> bool:
        def same(node):
            return not node or (node.val == root.val and same(node.left) and same(node.right))
        return same(root)
```

## 複雜度

時間 `O(n)`，空間 `O(h)`。

## 要特別避免的錯誤

- 遞迴函式回傳的是布林值，不能拿它跟節點的值比。

## 面試口說整理

我遞迴檢查每個節點的值是否等於根的值，空的子樹算成立，全部成立才回傳 `True`。時間 `O(n)`。
