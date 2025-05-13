---
title: "LeetCode 3512: Minimum Operations to Make Array Sum Divisible by K"
summary: "LeetCode 解題紀錄"
description: "LeetCode 雙周賽 154"
date: 2025-04-12
series: ["LeetCode Bi-Weekly Contest 154"]
series_order: 1
tags: ["LeetCode", "bi-weekly", "easy"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試： 2025-04-12
- 總花費時間：01:00.00

## 解題思路

這題的目的是要計算最少需要幾次操作，才能讓陣列的總和可以被 K 整除，因此我們只需要找出要做多少次調整，也就是計算陣列中數字對 K 的餘數。

## 解法
```python
class Solution:
    def minOperations(self, nums: List[int], k: int) -> int:
        return sum(nums)%k
```

## 收穫
NA

## 遇到的問題
NA