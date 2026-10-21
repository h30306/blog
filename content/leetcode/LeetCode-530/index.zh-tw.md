---
title: "LeetCode 530: Minimum Absolute Difference in BST"
summary: "LeetCode 530 解題筆記：BST 的中序是由小到大，最小差一定出現在中序相鄰的兩個值之間；記住前一個值逐一比較"
description: "2022-08-25 的 LeetCode 530 解題紀錄"
date: 2022-08-25
tags: ["easy", "tree", "depth-first-search", "breadth-first-search", "binary-search-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-25
- 提交紀錄：Accepted ×2

## 解題思路

BST 的中序遍歷是排序好的序列，排序後最接近的兩個數一定相鄰（[Tree]({{< relref "/algorithm/Tree" >}}) 模板三）。中序走的時候記住前一個值，跟目前的值相減更新答案。這題和 LC 783 是同一題。

## 我的解法

```python
class Solution:
    def getMinimumDifference(self, root: Optional[TreeNode]) -> int:
        best, prev = float("inf"), None
        stack, cur = [], root
        while cur or stack:
            while cur:
                stack.append(cur)
                cur = cur.left
            cur = stack.pop()
            if prev is not None:
                best = min(best, cur.val - prev)
            prev = cur.val
            cur = cur.right
        return best
```

## 複雜度

時間 `O(n)`，空間 `O(h)`。

## 要特別避免的錯誤

- 最接近的兩個值不一定是父子，要比中序相鄰的值。

## 面試口說整理

BST 中序是排序的，最小差一定在相鄰的兩個值之間，所以我中序遍歷時記住前一個值，每次相減更新最小值。時間 `O(n)`。
