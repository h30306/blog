---
title: "LeetCode 450: Delete Node in a BST"
summary: "LeetCode 450 解題筆記：找到節點後分三種情況：沒有小孩、一個小孩直接接上，兩個小孩用右子樹最小值替換再刪掉它"
description: "2026-10-25 的 LeetCode 450 解題紀錄"
date: 2026-10-25
tags: ["medium", "tree", "binary-search-tree", "binary-tree"]
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
- 提交紀錄：Accepted ×2

## 解題思路

遞迴找節點，回傳「刪完之後這棵子樹的根」，讓父節點直接接上（`root.left = self.deleteNode(root.left, key)`）。

找到要刪的節點時：

- 沒有左小孩：回傳右小孩（也涵蓋沒有小孩的情況）。
- 沒有右小孩：回傳左小孩。
- 兩個小孩都有：找右子樹的最小值（中序後繼，一直往左走），把值複製到目前節點，再到右子樹裡把那個後繼刪掉。後繼沒有左小孩，所以刪它一定落在前兩種情況。

## 我的嘗試

一次通過，同一份程式碼加了註解又交一次。

## 正確解法

```python
class Solution:
    def deleteNode(self, root: Optional[TreeNode], key: int) -> Optional[TreeNode]:
        if not root:
            return None
        if key < root.val:
            root.left = self.deleteNode(root.left, key)
        elif key > root.val:
            root.right = self.deleteNode(root.right, key)
        else:
            if not root.left:
                return root.right
            if not root.right:
                return root.left
            succ = root.right
            while succ.left:
                succ = succ.left
            root.val = succ.val
            root.right = self.deleteNode(root.right, succ.val)
        return root
```

## 複雜度

時間 `O(h)`：找節點、找後繼、刪後繼都只沿一條路往下。空間 `O(h)`。

## 要特別避免的錯誤

- 遞迴要回傳新的子樹根，讓父節點重新接上；只改區域變數不會影響樹。
- 兩個小孩的情況，複製值之後要到**右子樹**刪後繼，不是刪原本的 `key`（已經被覆蓋了）。
- `key` 不存在時要原樹回傳。

## 面試口說整理

我遞迴往下找，每次回傳刪完後的子樹根讓父節點接回去。找到時如果少一個小孩就直接回傳另一個；兩個小孩都有就用右子樹最小的節點替換值，再去右子樹把它刪掉，它沒有左小孩所以一定好刪。時間 `O(h)`。
