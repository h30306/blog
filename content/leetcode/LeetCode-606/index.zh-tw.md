---
title: "LeetCode 606: Construct String from Binary Tree"
summary: "LeetCode 606 解題筆記：前序輸出，左子樹空但右子樹不空時要留一個空括號 ()，右子樹空時可以省略"
description: "2022-08-28 的 LeetCode 606 解題紀錄"
date: 2022-08-28
tags: ["medium", "string", "tree", "depth-first-search", "binary-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-08-28
- 提交紀錄：Wrong Answer → Accepted ×4

## 解題思路

前序：先寫自己的值，再寫左右子樹（[Tree]({{< relref "/algorithm/Tree" >}}) 模板一）。括號的規則：

- 葉子：只有值。
- 右子樹是空的：右邊的括號可以省略。
- 左子樹是空的、右子樹不是：**左邊要留一個 `()`**，不然分不出那是右小孩。

## 我的嘗試

第一版回傳的是一個 list，而且根也被包了括號，例如 `[1]` 回傳 `['(', '1', ')']`，答案是 `"1"`。

## 正確解法

```python
class Solution:
    def tree2str(self, root: Optional[TreeNode]) -> str:
        if not root:
            return ""
        s = str(root.val)
        if root.left or root.right:
            s += f"({self.tree2str(root.left)})"
        if root.right:
            s += f"({self.tree2str(root.right)})"
        return s
```

## 複雜度

時間 `O(n²)`（字串串接），用 list 收集再 `join` 可以到 `O(n)`。

## 要特別避免的錯誤

- 只有左子樹空時才需要 `()`。
- 根本身不加括號。

## 面試口說整理

我用前序遞迴輸出：先寫值，有任何小孩就寫左子樹的括號（左邊是空的也要寫 `()`），有右小孩才寫右子樹的括號。時間 `O(n)` 到 `O(n²)`。
