---
title: "LeetCode 104: Maximum Depth of Binary Tree"
summary: "LeetCode 104 解題筆記：深度等於 1 加上左右子樹深度的較大值；空樹是 0"
description: "2022-08-02 的 LeetCode 104 解題紀錄"
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
- 提交紀錄：Accepted → Runtime Error → Accepted ×2 → Wrong Answer ×2 → Accepted → Runtime Error → Accepted ×3

## 解題思路

後序的回傳值（[Tree]({{< relref "/algorithm/Tree" >}}) 模板一）：空樹深度 0，否則是 `1 + max(左深度, 右深度)`。

## 我的嘗試

第一次就 AC 了。之後改寫成帶 `depth` 參數的 DFS 時，葉子節點回傳的是 0 而不是目前的 `depth`，例如 `[5]` 回傳 0；也有一版空樹時回傳 `None`。

## 正確解法

```python
class Solution:
    def maxDepth(self, root: Optional[TreeNode]) -> int:
        if not root:
            return 0
        return 1 + max(self.maxDepth(root.left), self.maxDepth(root.right))
```

## 複雜度

時間 `O(n)`，空間 `O(h)`。

## 要特別避免的錯誤

- 遞迴函式每一條路徑都要有回傳值。

## 面試口說整理

空樹深度是 0，否則是 1 加上左右子樹深度的較大值，用遞迴後序計算。時間 `O(n)`、空間 `O(h)`。
