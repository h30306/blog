---
title: "LeetCode 581: Shortest Unsorted Continuous Subarray"
summary: "LeetCode 581 解題筆記：從左往右記最大值，最後一個比最大值小的位置是右界；從右往左記最小值，最後一個比最小值大的位置是左界"
description: "2026-01-29 的 LeetCode 581 解題紀錄"
date: 2026-01-29
tags: ["medium", "two-pointers", "greedy", "sorting", "array", "monotonic-stack"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-01-29
- 提交紀錄：Accepted ×2

## 解題思路

要排序的範圍 `[start, end]` 是：

- **右界 `end`**：從左往右掃、記錄目前最大值 `max_seen`。如果 `nums[i] < max_seen`，代表 `nums[i]` 左邊有比它大的數，它一定要被排序，所以 `end = i`。最後一個這樣的 `i` 就是右界。
- **左界 `start`**：對稱地從右往左掃、記錄最小值 `min_seen`，最後一個 `nums[i] > min_seen` 的 `i` 就是左界。

右界右邊的每個數都 `>=` 前面所有數，而且本身遞增，所以已經在正確位置；左界同理。

這兩次掃描就像從兩端往內找第一個「放錯位置」的數，只是比較對象是「另一側的最值」而不是相鄰元素。

## 我的解法

```python
class Solution:
    def findUnsortedSubarray(self, nums: List[int]) -> int:
        n = len(nums)
        max_seen, end = float("-inf"), -1
        for i in range(n):
            if nums[i] < max_seen:
                end = i                            # 左邊有比它大的數
            else:
                max_seen = nums[i]
        if end == -1:
            return 0                               # 已經排好

        min_seen, start = float("inf"), -1
        for i in range(n - 1, -1, -1):
            if nums[i] > min_seen:
                start = i                          # 右邊有比它小的數
            else:
                min_seen = nums[i]
        return end - start + 1
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。另一種直覺解法是複製一份排序後比對兩端第一個不同的位置，`O(n log n)`。

## 要特別避免的錯誤

- 只比較相鄰元素找第一個下降的位置：例如 `[1, 3, 2, 0]`，範圍要延伸到 `0` 前面所有比它大的數，答案是整個陣列 4。
- 已經排好時要回傳 0，不是 `end - start + 1`。

## 面試口說整理

我從左往右記錄最大值，最後一個比目前最大值小的位置就是右界，因為它左邊有更大的數；再從右往左記錄最小值，最後一個比目前最小值大的位置就是左界。兩次線性掃描，時間 `O(n)`，空間 `O(1)`。
