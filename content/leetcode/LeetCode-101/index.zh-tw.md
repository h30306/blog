---
title: "LeetCode 101: Symmetric Tree"
summary: "LeetCode 101 解題筆記：左子樹跟右子樹互為鏡像：外側跟外側比、內側跟內側比；比的是值，不是節點本身"
description: "2022-08-02 的 LeetCode 101 解題紀錄"
date: 2022-08-02
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
第一次嘗試：2022-08-02
- 提交紀錄：Runtime Error ×2 → Accepted → Wrong Answer → Accepted ×4

## 解題思路

對稱代表左子樹是右子樹的鏡像。寫一個比較兩棵樹是否鏡像的函式（[Tree]({{< relref "/algorithm/Tree" >}}) 模板一）：值一樣，而且 `a.left` 對 `b.right`（外側）、`a.right` 對 `b.left`（內側）也都是鏡像。

## 我的嘗試

前兩版語法錯誤；之後有一版寫成 `left == right`，比的是節點物件而不是值，兩個不同的節點永遠不相等。例如 `[3, 3, 3]`：答案 `True`，回傳 `False`。

## 正確解法

```python
class Solution:
    def isSymmetric(self, root: Optional[TreeNode]) -> bool:
        def mirror(a, b):
            if not a or not b:
                return a is b
            return a.val == b.val and mirror(a.left, b.right) and mirror(a.right, b.left)
        return mirror(root.left, root.right)
```

## 複雜度

時間 `O(n)`，空間 `O(h)`。

## 要特別避免的錯誤

- 比較的是 `a.val == b.val`；`a == b` 比的是兩個節點是不是同一個物件。

## 面試口說整理

我寫一個判斷兩棵樹是否互為鏡像的函式：值相同，外側和外側、內側和內側也互為鏡像，然後拿根的左右子樹去比。時間 `O(n)`。
