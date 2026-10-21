---
title: "LeetCode 559: Maximum Depth of N-ary Tree"
summary: "LeetCode 559 解題筆記：深度等於 1 加上所有小孩深度的最大值；沒有小孩時是 1"
description: "2022-08-27 的 LeetCode 559 解題紀錄"
date: 2022-08-27
tags: ["easy", "tree", "depth-first-search", "breadth-first-search"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-27
- 提交紀錄：Runtime Error ×3 → Wrong Answer → Runtime Error → Accepted → Runtime Error → Accepted

## 解題思路

跟二元樹一樣是後序回傳值（[Tree]({{< relref "/algorithm/Tree" >}}) 模板一），只是小孩變成一個 list：`1 + max(每個小孩的深度)`。沒有小孩時 `max` 對空的序列要給預設值 0。

## 我的嘗試

前幾版都是空樹或沒有小孩的節點沒處理好：取 `None.children`、或對空的 list 取 `max`。

## 正確解法

```python
class Solution:
    def maxDepth(self, root: 'Node') -> int:
        if not root:
            return 0
        return 1 + max((self.maxDepth(c) for c in root.children), default=0)
```

## 複雜度

時間 `O(n)`，空間 `O(h)`。

## 要特別避免的錯誤

- 空樹回傳 0。
- 沒有小孩時 `max` 要有 `default`。

## 面試口說整理

N 叉樹的深度是 1 加上所有小孩深度的最大值，我用遞迴計算，沒有小孩時預設是 0。時間 `O(n)`。
