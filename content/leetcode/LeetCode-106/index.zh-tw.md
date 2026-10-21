---
title: "LeetCode 106: Construct Binary Tree from Inorder and Postorder Traversal"
summary: "LeetCode 106 解題筆記：後序的最後一個是根；從後序尾巴往前取根時，要先建右子樹再建左子樹"
description: "2022-11-10 的 LeetCode 106 解題紀錄"
date: 2022-11-10
tags: ["medium", "array", "hash-table", "divide-and-conquer", "tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-11-10
- 提交紀錄：Accepted ×2 → Runtime Error → Accepted

## 解題思路

跟 LC 105 一樣的想法，只是根在後序的**最後**（[Tree]({{< relref "/algorithm/Tree" >}})）。從後序的尾巴往前取，順序是「根、右、左」，所以**要先建右子樹**，指標才會對。

## 我的嘗試

做完 LC 105 之後很快就寫出來了，只有一版切片的範圍算錯（ValueError）。

## 正確解法

```python
class Solution:
    def buildTree(self, inorder: List[int], postorder: List[int]) -> Optional[TreeNode]:
        pos = {v: i for i, v in enumerate(inorder)}
        it = reversed(postorder)
        def build(lo, hi):
            if lo > hi:
                return None
            val = next(it)
            root = TreeNode(val)
            root.right = build(pos[val] + 1, hi)         # 先建右子樹
            root.left = build(lo, pos[val] - 1)
            return root
        return build(0, len(inorder) - 1)
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 從後序尾巴往前取時是「根、右、左」，先建右子樹。

## 面試口說整理

後序的最後一個是根，它在中序的位置切出左右子樹。我從後序的尾巴往前取根，所以先遞迴建右子樹再建左子樹，用字典查中序位置。時間 `O(n)`。
