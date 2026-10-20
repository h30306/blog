---
title: "LeetCode 3689: Maximum Total Subarray Value I"
summary: "LeetCode 3689 解題筆記：同一個子陣列可以重複選，整個陣列的最大減最小就是單一子陣列的最大值，選 k 次"
description: "2025-09-21 的 LeetCode 3689 解題紀錄"
date: 2025-09-21
tags: ["medium", "greedy", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2025-09-21
- 提交紀錄：Accepted（一次通過）

## 解題思路

一個子陣列的值是裡面的最大值減最小值。任何子陣列的最大值都 `<=` 整個陣列的最大值，最小值都 `>=` 整個陣列的最小值，所以**整個陣列的值最大**。題目允許同一個子陣列重複選，選它 `k` 次就好。

## 我的解法

```python
class Solution:
    def maxTotalValue(self, nums: List[int], k: int) -> int:
        return (max(nums) - min(nums)) * k
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 注意「可以重複選同一個子陣列」這個條件；如果每個子陣列只能選一次，就不能這樣做，要另外挑出值最大的 `k` 個。

## 面試口說整理

任何子陣列的最大減最小都不會超過整個陣列的最大減最小，而且同一個子陣列可以重複選，所以答案是整個陣列的值乘上 `k`。時間 `O(n)`。
