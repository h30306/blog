---
title: "LeetCode 100: Same Tree"
summary: "LeetCode 100 解題筆記：兩邊都是空的才相同；一邊空一邊不空就不同；都不空時比值再遞迴比左右"
description: "2022-08-02 的 LeetCode 100 解題紀錄"
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
- 提交紀錄：Wrong Answer → Accepted → Wrong Answer → Accepted → Wrong Answer → Accepted → Wrong Answer → Runtime Error → Accepted → Wrong Answer → Runtime Error → Wrong Answer → Accepted ×4

## 解題思路

三種情況（[Tree]({{< relref "/algorithm/Tree" >}}) 模板一）：

- 兩個都是空的：相同。
- 只有一個是空的：不同。
- 都不是空的：值一樣，而且左右子樹也分別相同。

## 我的嘗試

錯的版本都在處理空樹：兩個都是空的時候沒有回傳值（`None`）或回傳 `False`；一邊空一邊不空時卻回傳 `True`，例如 `[1]` 和 `[]`。

## 正確解法

```python
class Solution:
    def isSameTree(self, p: Optional[TreeNode], q: Optional[TreeNode]) -> bool:
        if not p or not q:
            return p is q                           # 兩個都是 None 才相同
        return p.val == q.val and self.isSameTree(p.left, q.left) and self.isSameTree(p.right, q.right)
```

## 複雜度

時間 `O(min(m, n))`，空間 `O(h)`。

## 要特別避免的錯誤

- 兩個都是空的要回傳 `True`，不能漏掉回傳值。
- 一邊空一邊不空是 `False`。

## 面試口說整理

我先處理有空樹的情況：兩個都空才相同。都不空時比較值，再遞迴比較左右子樹。時間 `O(n)`。
