---
title: "LeetCode 2331: Evaluate Boolean Binary Tree"
summary: "LeetCode 2331 解題筆記：葉子是 0 或 1，內部節點 2 是 OR、3 是 AND，後序遞迴計算"
description: "2022-11-18 的 LeetCode 2331 解題紀錄"
date: 2022-11-18
tags: ["easy", "tree", "depth-first-search", "binary-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-11-18
- 提交紀錄：Accepted（一次通過）

## 解題思路

後序：先算左右子樹，再依照節點的值做 OR 或 AND（[Tree]({{< relref "/algorithm/Tree" >}}) 模板一）。題目保證是完整的二元樹（每個內部節點都有兩個小孩），葉子的值就是結果。

## 我的解法

```python
class Solution:
    def evaluateTree(self, root: Optional[TreeNode]) -> bool:
        if not root.left:
            return bool(root.val)
        l, r = self.evaluateTree(root.left), self.evaluateTree(root.right)
        return l or r if root.val == 2 else l and r
```

## 複雜度

時間 `O(n)`，空間 `O(h)`。

## 要特別避免的錯誤

- 判斷葉子只要看有沒有左小孩，因為內部節點一定有兩個小孩。

## 面試口說整理

葉子直接回傳自己的布林值，內部節點先算左右再做 OR 或 AND，用遞迴後序計算。時間 `O(n)`。
