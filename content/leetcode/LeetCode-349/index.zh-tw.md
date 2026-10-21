---
title: "LeetCode 349: Intersection of Two Arrays"
summary: "LeetCode 349 解題筆記：兩個陣列各轉成集合取交集"
description: "2022-08-23 的 LeetCode 349 解題紀錄"
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
- 提交紀錄：Accepted（一次通過）

## 解題思路

結果的每個值只出現一次，用集合取交集就好（[Hash Table]({{< relref "/algorithm/Hash-Table" >}})）。也可以把一個陣列排序，另一個陣列的每個值用二分搜尋檢查。

## 我的解法

```python
class Solution:
    def intersection(self, nums1: List[int], nums2: List[int]) -> List[int]:
        return list(set(nums1) & set(nums2))
```

## 複雜度

時間 `O(m + n)`，空間 `O(m + n)`。

## 要特別避免的錯誤

- 結果不能有重複；要保留重複次數的是 LC 350。

## 面試口說整理

我把兩個陣列轉成集合取交集，結果自然沒有重複。時間 `O(m + n)`。
