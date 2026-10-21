---
title: "LeetCode 3131: Find the Integer Added to Array I"
summary: "LeetCode 3131 解題筆記：每個數都加上同一個 x，所以 x 就是兩個陣列最小值的差（或總和的差除以長度）"
description: "2024-04-28 的 LeetCode 3131 解題紀錄"
date: 2024-04-28
tags: ["easy", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2024-04-28
- 提交紀錄：Runtime Error → Wrong Answer → Accepted

## 解題思路

`nums1` 每個元素都加上同一個 `x` 得到 `nums2`（順序可能打亂），所以兩邊的最小值也差 `x`：`x = min(nums2) - min(nums1)`。用總和的差除以長度也可以，但要用整數除法。

## 我的嘗試

第一版變數名稱錯誤（NameError）；第二版用總和的差除以長度，但用了 `/`，**回傳浮點數** `5.0`，被判 WA。包上 `int` 就 AC 了。

## 正確解法

```python
class Solution:
    def addedInteger(self, nums1: List[int], nums2: List[int]) -> int:
        return min(nums2) - min(nums1)
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- `/` 會得到浮點數，答案要整數。

## 面試口說整理

每個數都加上同一個 x，所以兩個陣列的最小值也剛好差 x，我直接回傳最小值的差。時間 `O(n)`。
