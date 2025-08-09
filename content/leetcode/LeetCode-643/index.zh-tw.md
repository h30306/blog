---
title: "LeetCode 643: Maximum Average Subarray I"
summary: "LeetCode 解題紀錄"
description: "LeetCode Daily"
date: 2025-08-02
tags: ["LeetCode", "daily", "easy", "Sliding Window"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試： 2025-08-02
- 總花費時間：00:00.00

## 解題思路

這是一個固定窗口大小的滑動窗口問題。根據題目要求，我們需要找到子數組的最大平均值。我們可以將其理解為找到子數組的最大和，然後除以窗口大小得到平均值。因此，目標可以簡化為最大子數組和問題。

## 解法

```python
class Solution:
    def findMaxAverage(self, nums: List[int], k: int) -> float:
        max_sum = 0
        for i in range(k):
            max_sum += nums[i]

        sum_now = max_sum
        for i in range(k, len(nums)):
            sum_now += nums[i]
            sum_now -= nums[i - k]

            max_sum = max(max_sum, sum_now)

        return max_sum / k
```

## 收穫

這是一個固定窗口問題。我們可以先累積第一個窗口，然後滑動窗口直到結束。

## 遇到的問題