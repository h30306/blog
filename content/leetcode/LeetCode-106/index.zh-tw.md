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
- 2026-10-29 重寫：Accepted ×3

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

## 2026-10 重寫

三次都一次通過：

1. 遞迴版：和上面一樣用字典記中序位置，用 `postorder.pop()` 從尾巴取根，先建右子樹再建左子樹。
2. 兩次 stack 版本：把 LC 105 的 stack 寫法左右對調。從後序尾巴往前讀（根、右、左），中序也從尾巴往前比；堆頂不等於中序目前的值就接成**右**小孩，相等就一直 pop，再把新節點接成最後 pop 出來那個的**左**小孩。

`postorder.pop()` 會改到輸入陣列，面試時最好先說一聲，或像上面一樣用 `reversed` 迭代器。

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 從後序尾巴往前取時是「根、右、左」，先建右子樹。

## 面試口說整理

後序的最後一個是根，它在中序的位置切出左右子樹。我從後序的尾巴往前取根，所以先遞迴建右子樹再建左子樹，用字典查中序位置。時間 `O(n)`。
