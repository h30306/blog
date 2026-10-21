---
title: "LeetCode 700: Search in a Binary Search Tree"
summary: "LeetCode 700 解題筆記：比目標大就往左、比目標小就往右，找到就回傳那個節點"
description: "2022-08-31 的 LeetCode 700 解題紀錄"
date: 2022-08-31
tags: ["easy", "tree", "binary-search-tree", "binary-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-31
- 提交紀錄：Accepted（一次通過）

## 解題思路

BST 的搜尋（[Tree]({{< relref "/algorithm/Tree" >}}) 模板三）：目前的值比目標大就往左、比目標小就往右，相等就找到了；走到 `None` 代表不存在。

## 我的解法

```python
class Solution:
    def searchBST(self, root: Optional[TreeNode], val: int) -> Optional[TreeNode]:
        while root and root.val != val:
            root = root.left if val < root.val else root.right
        return root
```

## 複雜度

時間 `O(h)`，空間 `O(1)`。

## 要特別避免的錯誤

- 回傳的是節點（整棵子樹），不是值。

## 面試口說整理

我從根往下，比目標大就往左、比目標小就往右，找到或走到 `None` 就回傳。時間 `O(h)`、空間 `O(1)`。
