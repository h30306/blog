---
title: "LeetCode 3708: Longest Fibonacci Subarray"
summary: "LeetCode 3708 解題筆記：長度 1、2 一定成立；從第三個開始，nums[i] == nums[i-1] + nums[i-2] 就延長，否則長度回到 2"
description: "2025-10-11 的 LeetCode 3708 解題紀錄"
date: 2025-10-11
tags: ["medium", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2025-10-11
- 提交紀錄：Accepted（一次通過）

## 解題思路

連續的一段，只要記目前這段的長度（[Array]({{< relref "/algorithm/Array" >}}) 模板一）。任兩個相鄰的數都能開始一段新的費氏子陣列，所以斷掉時長度回到 2，不是 1。

## 我的解法

```python
class Solution:
    def longestSubarray(self, nums: List[int]) -> int:
        n = len(nums)
        if n <= 2:
            return n
        cur = best = 2
        for i in range(2, n):
            cur = cur + 1 if nums[i] == nums[i - 1] + nums[i - 2] else 2
            best = max(best, cur)
        return best
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 斷掉時長度是 2，因為最後兩個數可以當新的開頭。
- 長度不到 3 時直接回傳長度。

## 面試口說整理

我從第三個數開始掃，符合前兩個相加就延長目前長度，否則從最後兩個數重新開始，長度變成 2。時間 `O(n)`。
