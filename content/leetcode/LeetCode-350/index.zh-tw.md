---
title: "LeetCode 350: Intersection of Two Arrays II"
summary: "LeetCode 350 解題筆記：保留重複次數的交集，Counter 相交（&）取兩邊次數的較小值"
description: "2022-08-23 的 LeetCode 350 解題紀錄"
date: 2022-08-23
tags: ["easy", "array", "hash-table", "two-pointers", "binary-search"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-23
- 提交紀錄：Accepted ×4

## 解題思路

每個值出現的次數是兩邊次數的較小值。`Counter` 的 `&` 就是「每個 key 取較小的次數」（[Hash Table]({{< relref "/algorithm/Hash-Table" >}})）。陣列已排序的話也可以用雙指針。

## 我的解法

```python
class Solution:
    def intersect(self, nums1: List[int], nums2: List[int]) -> List[int]:
        return list((Counter(nums1) & Counter(nums2)).elements())
```

## 複雜度

時間 `O(m + n)`，空間 `O(min(m, n))`。

## 要特別避免的錯誤

- 跟 LC 349 不同，這題要保留重複。

## 面試口說整理

每個值的次數是兩邊次數的較小值，所以我用 `Counter` 的交集再展開成 list。時間 `O(m + n)`。
