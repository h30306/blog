---
title: "LeetCode 1372: Longest ZigZag Path in a Binary Tree"
summary: "LeetCode 1372 解題筆記：每個節點回傳兩個值：從這裡先往左、先往右的最長 zigzag；往左走接的是左小孩「先往右」的值"
description: "2026-10-24 的 LeetCode 1372 解題紀錄"
date: 2026-10-24
tags: ["medium", "dynamic-programming", "tree", "depth-first-search", "binary-tree", "dp-on-trees"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-10-24
- 提交紀錄：Wrong Answer → Accepted

## 解題思路

DFS 回傳值（[Tree]({{< relref "/algorithm/Tree" >}}) 模板一），但要回傳兩個值：

- `left`：從這個節點**先往左**走的最長 zigzag（邊數）。往左走到左小孩之後，下一步必須往右，所以 `left = 左小孩的 right + 1`。
- `right`：先往右走，`right = 右小孩的 left + 1`。

空節點回傳 `(-1, -1)`，這樣沒有左小孩時 `left = -1 + 1 = 0`。每個節點都用 `max(left, right)` 更新答案。

## 我的嘗試

1. 照 LC 687（最長同值路徑）的寫法改，多了一個「小孩的值要和自己一樣」的條件，這題根本沒有這個條件：`[2,1,1]` 回傳 0，答案是 1。
2. 拿掉值的條件、空節點改回傳 `-1` 就過了。

## 正確解法

```python
class Solution:
    def longestZigZag(self, root: Optional[TreeNode]) -> int:
        self.longest = 0

        def dfs(node):
            if not node:
                return -1, -1
            _, left_child_right = dfs(node.left)
            right_child_left, _ = dfs(node.right)
            left = left_child_right + 1
            right = right_child_left + 1
            self.longest = max(self.longest, left, right)
            return left, right

        dfs(root)
        return self.longest
```

## 複雜度

時間 `O(n)`，空間 `O(h)`。

## 要特別避免的錯誤

- 往左走之後要接小孩「先往右」的值，左右是交叉的。
- 空節點回傳 -1，不是 0，不然沒有小孩的方向會被算成長度 1。
- 照抄相似題的模板前，先確認條件有沒有一樣。

## 面試口說整理

每個節點回傳兩個值：先往左、先往右的最長 zigzag。往左走到左小孩後下一步要往右，所以 `left` 是左小孩的 `right` 加一，`right` 是右小孩的 `left` 加一。空節點回傳 -1，每個節點都更新答案。時間 `O(n)`。
