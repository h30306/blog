---
title: "LeetCode 230: Kth Smallest Element in a BST"
summary: "LeetCode 230 解題筆記：BST 的中序遍歷是由小到大，迭代中序走到第 k 個就停"
description: "2022-10-29 的 LeetCode 230 解題紀錄"
date: 2022-10-29
tags: ["medium", "tree", "depth-first-search", "binary-search-tree", "binary-tree"]
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
- 提交紀錄：Runtime Error → Wrong Answer ×2 → Accepted ×5 → Wrong Answer ×3 → Accepted ×2

## 解題思路

BST 的中序遍歷會由小到大輸出（[Tree]({{< relref "/algorithm/Tree" >}}) 模板三）。用迭代的中序（同 LC 94），每彈出一個節點就把 `k` 減 1，減到 0 就是答案，不用走完整棵樹。

## 我的嘗試

一版回傳的是節點本身而不是值；之後重寫時有幾版回傳了 `None`。

## 正確解法

```python
class Solution:
    def kthSmallest(self, root: Optional[TreeNode], k: int) -> int:
        stack, cur = [], root
        while True:
            while cur:
                stack.append(cur)
                cur = cur.left
            cur = stack.pop()
            k -= 1
            if k == 0:
                return cur.val
            cur = cur.right
```

## 複雜度

時間 `O(h + k)`，空間 `O(h)`。

## 要特別避免的錯誤

- 回傳的是值，不是節點。

## 面試口說整理

BST 的中序是由小到大，所以我用迭代的中序遍歷，數到第 `k` 個就回傳它的值。時間 `O(h + k)`。
