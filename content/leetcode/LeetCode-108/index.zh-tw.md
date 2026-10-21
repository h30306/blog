---
title: "LeetCode 108: Convert Sorted Array to Binary Search Tree"
summary: "LeetCode 108 解題筆記：中間的元素當根，左右兩半遞迴；左右大小最多差 1，自然是平衡的"
description: "2022-08-16 的 LeetCode 108 解題紀錄"
date: 2022-08-16
tags: ["easy", "array", "divide-and-conquer", "tree", "binary-search-tree"]
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
- 提交紀錄：Runtime Error ×5 → Accepted → Runtime Error ×2 → Accepted → Runtime Error → Accepted ×2

## 解題思路

陣列已排序，所以中間的元素左邊都比它小、右邊都比它大，剛好當根（[Tree]({{< relref "/algorithm/Tree" >}}) 模板三）。左右兩半各自遞迴，每次都從中間切，兩邊大小最多差 1，高度平衡。用 index 傳範圍，避免每次切片複製。

## 我的嘗試

前面幾版右半邊切成 `nums[mid:]`，**把中間的元素也包含進去**，只有一個元素時一直切出同一段，無限遞迴（RecursionError）；也有幾版對 `None` 取屬性。

## 正確解法

```python
class Solution:
    def sortedArrayToBST(self, nums: List[int]) -> Optional[TreeNode]:
        def build(lo, hi):
            if lo > hi:
                return None
            mid = (lo + hi) // 2
            return TreeNode(nums[mid], build(lo, mid - 1), build(mid + 1, hi))
        return build(0, len(nums) - 1)
```

## 複雜度

時間 `O(n)`，空間 `O(log n)`。

## 要特別避免的錯誤

- 遞迴的範圍要排除 `mid` 自己，不然會無限遞迴。

## 面試口說整理

排序陣列的中間元素當根，左右兩半遞迴建子樹，兩邊大小最多差一，所以高度平衡。用 index 傳範圍，時間 `O(n)`。
