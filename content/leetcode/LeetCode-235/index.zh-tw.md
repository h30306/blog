---
title: "LeetCode 235: Lowest Common Ancestor of a Binary Search Tree"
summary: "LeetCode 235 解題筆記：p、q 都比節點小就往左，都比節點大就往右，否則（一邊一個或其中一個就是自己）這個節點就是 LCA"
description: "2022-08-22 的 LeetCode 235 解題紀錄"
date: 2022-08-22
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
第一次嘗試：2022-08-22
- 提交紀錄：Runtime Error → Accepted ×2 → Wrong Answer → Runtime Error → Accepted → Runtime Error → Wrong Answer → Runtime Error → Accepted → Runtime Error → Accepted

## 解題思路

利用 BST 的大小關係，不用搜尋整棵樹（[Tree]({{< relref "/algorithm/Tree" >}}) 模板四）：

- `p`、`q` 都比目前節點小：LCA 在左子樹。
- 都比目前節點大：LCA 在右子樹。
- 否則它們分在兩邊、或其中一個就是目前節點：目前節點就是 LCA。

## 我的嘗試

遞迴版本很快就 AC 了。之後想改成迭代，第一版**忘了寫 `while` 迴圈**，只往下走一步就結束、沒有回傳值；第二版少了冒號。11 月重寫時又出現變數沒定義和取 `None` 屬性的錯。

## 正確解法

```python
class Solution:
    def lowestCommonAncestor(self, root: 'TreeNode', p: 'TreeNode', q: 'TreeNode') -> 'TreeNode':
        node = root
        while True:
            if p.val < node.val and q.val < node.val:
                node = node.left
            elif p.val > node.val and q.val > node.val:
                node = node.right
            else:
                return node
```

## 複雜度

時間 `O(h)`，空間 `O(1)`。

## 要特別避免的錯誤

- 其中一個節點就是另一個的祖先時，答案是那個祖先自己，條件要包含等於。

## 面試口說整理

我從根往下走：兩個都比較小就往左，都比較大就往右，其他情況代表在這裡分岔或其中一個就是自己，回傳目前節點。時間 `O(h)`、空間 `O(1)`。
