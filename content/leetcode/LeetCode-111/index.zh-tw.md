---
title: "LeetCode 111: Minimum Depth of Binary Tree"
summary: "LeetCode 111 解題筆記：最小深度要到葉子才算；只有一邊有小孩時不能拿空的那邊（深度 0）當最小值"
description: "2022-08-16 的 LeetCode 111 解題紀錄"
date: 2022-08-16
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
第一次嘗試：2022-08-16
- 提交紀錄：Wrong Answer → Accepted ×3 → Runtime Error → Accepted ×2

## 解題思路

跟最大深度不同，**只有一邊有小孩**時，空的那一邊不是葉子，不能拿來算（[Tree]({{< relref "/algorithm/Tree" >}}) 模板一）：

- 空樹：0。
- 葉子：1。
- 只有一邊：1 + 那一邊的最小深度。
- 兩邊都有：1 + 兩邊的較小值。

## 我的嘗試

第一版直接寫 `min(左, 右) + 1`，只有一邊有小孩時把空的那邊（深度 0）當成最小值。例如 `[3, 3]`（只有左小孩）：答案 2，回傳 1。

## 正確解法

```python
class Solution:
    def minDepth(self, root: Optional[TreeNode]) -> int:
        if not root:
            return 0
        if not root.left or not root.right:
            return 1 + self.minDepth(root.left or root.right)
        return 1 + min(self.minDepth(root.left), self.minDepth(root.right))
```

## 複雜度

時間 `O(n)`，空間 `O(h)`。用 BFS 找到第一個葉子就停會更快。

## 要特別避免的錯誤

- 缺一邊的小孩時，空的那邊深度是 0，但它不是葉子。

## 面試口說整理

最小深度要算到葉子。只有一邊有小孩時只能走那一邊，兩邊都有才取較小值，我用遞迴處理這三種情況。時間 `O(n)`。
