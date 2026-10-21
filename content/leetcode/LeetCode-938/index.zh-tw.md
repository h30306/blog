---
title: "LeetCode 938: Range Sum of BST"
summary: "LeetCode 938 解題筆記：利用 BST 剪枝，節點比 low 小就只往右，比 high 大就只往左，在範圍內才加"
description: "2022-09-26 的 LeetCode 938 解題紀錄"
date: 2022-09-26
tags: ["easy", "tree", "depth-first-search", "binary-search-tree", "binary-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-09-26
- 提交紀錄：Accepted ×3 → Wrong Answer → Runtime Error → Accepted ×2 → Wrong Answer → Accepted

## 解題思路

BST 的性質可以跳過不可能的子樹（[Tree]({{< relref "/algorithm/Tree" >}}) 模板三）：

- 節點 `< low`：它和整個左子樹都太小，只看右子樹。
- 節點 `> high`：只看左子樹。
- 在範圍內：加上自己，兩邊都要看。

## 我的嘗試

2022 年 9 月有一版定義了遞迴函式卻**沒有呼叫它**（裡面修改外層的 `sum_` 也少了 `nonlocal`），直接回傳 0。11 月重寫的版本把 `low + high` 當初始值，等於**假設 `low`、`high` 一定是樹裡的節點**；它通過了測資，但題目沒有這個保證，例如 `[9]`、`low = high = 5` 會回傳 10，答案是 0。

## 正確解法

```python
class Solution:
    def rangeSumBST(self, root: Optional[TreeNode], low: int, high: int) -> int:
        if not root:
            return 0
        if root.val < low:
            return self.rangeSumBST(root.right, low, high)
        if root.val > high:
            return self.rangeSumBST(root.left, low, high)
        return root.val + self.rangeSumBST(root.left, low, high) + self.rangeSumBST(root.right, low, high)
```

## 複雜度

時間 `O(n)`（最壞），空間 `O(h)`。

## 要特別避免的錯誤

- 範圍兩端是包含的。
- 不要假設 `low`、`high` 一定是樹裡的節點。

## 面試口說整理

我利用 BST 的大小關係剪枝：比 `low` 小只往右找，比 `high` 大只往左找，在範圍內就加上自己再往兩邊找。時間最壞 `O(n)`。
