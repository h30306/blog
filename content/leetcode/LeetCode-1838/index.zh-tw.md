---
title: "LeetCode 1838: Frequency of the Most Frequent Element"
summary: "LeetCode 1838 解題筆記：排序後，把視窗裡的數都加到 nums[right] 的花費是 nums[right] × 長度 − 視窗總和；花費 > k 就縮左邊"
description: "2026-01-11 的 LeetCode 1838 解題紀錄"
date: 2026-01-11
tags: ["medium", "sliding-window", "sorting", "greedy", "prefix-sum", "binary-search", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-01-11
- 提交紀錄：Accepted（一次通過）

## 解題思路

只能加不能減，所以目標值一定是某個原本就有的數 `nums[right]`，而要變成它的，應該是**比它小、而且最接近它的那些數**（加的次數最少）。

排序後，視窗 `[left, right]` 全部加到 `nums[right]` 的花費：

```text
cost = nums[right] × (right - left + 1) − sum(nums[left..right])
```

`right` 固定時，視窗越大花費越大；`left` 固定時 `right` 往右，花費也只會變大。條件單調，用「求最長」的滑動視窗。

## 我的解法

```python
class Solution:
    def maxFrequency(self, nums: List[int], k: int) -> int:
        nums.sort()
        left = total = best = 0
        for right, x in enumerate(nums):
            total += x
            while x * (right - left + 1) - total > k:
                total -= nums[left]
                left += 1
            best = max(best, right - left + 1)
        return best
```

我第一次 AC 的寫法是自己維護一個「目前的目標值」和累計花費，目標值變大時再補上差額，邏輯比較繞。用「目標值 × 長度 − 總和」直接算花費比較清楚。

## 複雜度

時間 `O(n log n)`，空間 `O(1)`（不算排序）。

## 要特別避免的錯誤

- 目標值不是任意值：一定是視窗最右邊（最大）的那個數。
- 花費會很大，Python 沒問題，其他語言要用 64 位元整數。

## 面試口說整理

只能加，所以目標一定是某個原本的數，而且要從比它小、最接近它的數加上去。我排序後用滑動視窗，以右端為目標，花費是右端乘長度減掉總和，超過 `k` 就縮左邊，記錄最長長度。時間 `O(n log n)`。
