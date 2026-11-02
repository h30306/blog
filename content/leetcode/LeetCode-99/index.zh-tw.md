---
title: "LeetCode 99: Recover Binary Search Tree"
summary: "LeetCode 99 解題筆記：中序遍歷找逆序：第一次逆序的前一個、最後一次逆序的後一個，就是被交換的兩個節點"
description: "2026-10-25 的 LeetCode 99 解題紀錄"
date: 2026-10-25
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
第一次嘗試：2026-10-25
- 提交紀錄：Accepted（一次通過）

## 解題思路

BST 的中序遍歷是嚴格遞增的（[Tree]({{< relref "/algorithm/Tree" >}}) 模板三）。兩個節點的值被交換之後，中序序列會出現「前一個比現在大」的逆序：

- 交換的兩個節點在中序裡**不相鄰**：會有兩次逆序。例如 `1 5 3 4 2 6`，逆序是 `5 > 3` 和 `4 > 2`。被交換的是第一次逆序的**前一個**（5），和最後一次逆序的**後一個**（2）。
- 兩個節點**相鄰**：只有一次逆序。例如 `1 3 2 4`，兩個節點都在這一次逆序裡。

所以中序走一遍，用 `prev` 記住上一個節點：

- 第一次碰到 `prev.val > node.val`，記 `first = prev`。
- 每次碰到逆序都更新 `second = node`。

最後交換 `first` 和 `second` 的值。兩種情況都會得到正確的兩個節點。

## 我的嘗試

一次通過。

## 正確解法

```python
class Solution:
    def recoverTree(self, root: Optional[TreeNode]) -> None:
        self.first = None
        self.second = None
        self.prev = TreeNode(-inf)

        def inorder(node):
            if not node:
                return
            inorder(node.left)
            if self.prev.val > node.val:
                if not self.first:
                    self.first = self.prev
                self.second = node
            self.prev = node
            inorder(node.right)

        inorder(root)
        self.first.val, self.second.val = self.second.val, self.first.val
```

## 複雜度

時間 `O(n)`，空間 `O(h)`（遞迴深度）。題目的 follow-up 要求 `O(1)` 空間，要用 Morris traversal 做中序。

## 要特別避免的錯誤

- `second` 要在**每一次**逆序都更新。只在第一次逆序時記兩個節點，不相鄰的情況會換錯。
- `first` 只記第一次，之後不能覆蓋。
- `prev` 用值是 `-inf` 的哨兵節點，第一個節點就不會被當成逆序。
- 只要交換值，不用改指標。

## 面試口說整理

BST 的中序是遞增的，兩個節點被交換後會出現逆序。不相鄰時有兩次逆序，錯的是第一次的前一個和最後一次的後一個；相鄰時只有一次，兩個都在裡面。所以我中序走一遍，第一次逆序記 `first = prev`，每次逆序都更新 `second = node`，最後交換兩個值。時間 `O(n)`，空間 `O(h)`；要 `O(1)` 空間可以改用 Morris traversal。
