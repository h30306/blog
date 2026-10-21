---
title: "LeetCode 112: Path Sum"
summary: "LeetCode 112 解題筆記：往下走時把 targetSum 減掉目前的值，到葉子時剛好是 0（或等於葉子的值）就成立"
description: "2022-08-16 的 LeetCode 112 解題紀錄"
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
- 提交紀錄：Runtime Error → Accepted → Wrong Answer → Runtime Error → Accepted

## 解題思路

往下走的時候把目標減掉目前的值（[Tree]({{< relref "/algorithm/Tree" >}}) 模板一）。到了**葉子**，剩下的目標剛好等於葉子的值就找到了。一定要到葉子才算，路過中間的節點時剛好湊到不算。

## 我的嘗試

一版寫成 `root == targetSum`，拿**節點本身**跟整數比，永遠不相等，例如 `[5]`、`targetSum = 5` 回傳 `False`。另外兩版是變數沒定義、型別錯誤。

## 正確解法

```python
class Solution:
    def hasPathSum(self, root: Optional[TreeNode], targetSum: int) -> bool:
        if not root:
            return False
        if not root.left and not root.right:
            return root.val == targetSum
        rest = targetSum - root.val
        return self.hasPathSum(root.left, rest) or self.hasPathSum(root.right, rest)
```

## 複雜度

時間 `O(n)`，空間 `O(h)`。

## 要特別避免的錯誤

- 比較的是 `root.val`，不是節點本身。
- 只在葉子判斷。

## 面試口說整理

我往下遞迴時把目標減掉目前的值，到葉子時檢查剩下的是否等於葉子的值，左右任一邊成立就回傳 `True`。時間 `O(n)`。
