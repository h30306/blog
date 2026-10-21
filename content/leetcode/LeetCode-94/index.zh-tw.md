---
title: "LeetCode 94: Binary Tree Inorder Traversal"
summary: "LeetCode 94 解題筆記：迭代的中序遍歷，一路往左把節點推進 stack，彈出時記錄，再轉向右子樹"
description: "2022-07-20 的 LeetCode 94 解題紀錄"
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
- 提交紀錄：Wrong Answer ×2 → Runtime Error ×2 → Accepted → Runtime Error ×2 → Accepted → Runtime Error → Accepted ×3

## 解題思路

中序是「左、根、右」。遞迴寫法很直接；迭代寫法要自己模擬呼叫堆疊（[Tree]({{< relref "/algorithm/Tree" >}})）：

1. 從目前節點一路往左走，經過的節點都推進 stack。
2. 走到底後彈出一個節點，記錄它的值（左邊已經處理完了）。
3. 轉到它的右子樹，重複。

## 我的嘗試

大部分的 RE 都是同一個原因：**空樹**時直接取 `root.left` / `root.val`（`root` 是 `None`）。另外有一版用了沒定義的變數（NameError）。

## 正確解法

```python
class Solution:
    def inorderTraversal(self, root: Optional[TreeNode]) -> List[int]:
        res, stack, cur = [], [], root
        while cur or stack:
            while cur:
                stack.append(cur)
                cur = cur.left
            cur = stack.pop()
            res.append(cur.val)
            cur = cur.right
        return res
```

## 複雜度

時間 `O(n)`，空間 `O(h)`，`h` 是樹高。

## 要特別避免的錯誤

- 外層條件是 `cur or stack`，兩個都空了才結束。

## 面試口說整理

我用 stack 模擬遞迴：一路往左推進 stack，走到底就彈出一個節點記錄，再轉向它的右子樹。每個節點進出 stack 各一次，時間 `O(n)`、空間 `O(h)`。
