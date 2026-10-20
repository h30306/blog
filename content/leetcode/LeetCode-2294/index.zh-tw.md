---
title: "LeetCode 2294: Partition Array Such That Maximum Difference Is K"
summary: "LeetCode 2294 解題筆記：子序列不在乎順序，排序後從最小的開始，每組盡量往右延伸到超過 min + k 為止"
description: "2025-09-03 的 LeetCode 2294 解題紀錄"
date: 2025-09-03
tags: ["medium", "greedy", "sorting", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2025-09-03
- 提交紀錄：Accepted（一次通過）

## 解題思路

每組只在乎最大值減最小值，跟順序無關，所以可以先排序。排序後從最小的數開始開一組，所有 `<= start + k` 的數都放進來；遇到第一個超過的，就開新的一組。

為什麼盡量往右延伸是對的：最小的數一定在某一組裡，那組最多只能裝到 `start + k`；多裝一些只會讓後面剩下的數更少，不會變差。這是 [Greedy]({{< relref "/algorithm/Greedy" >}}) 模板一。

## 我的解法

```python
class Solution:
    def partitionArray(self, nums: List[int], k: int) -> int:
        nums.sort()
        groups = 1
        start = nums[0]
        for x in nums[1:]:
            if x - start > k:
                groups += 1
                start = x
        return groups
```

## 複雜度

時間 `O(n log n)`，空間 `O(1)`（不算排序）。

## 要特別避免的錯誤

- 比較的是跟這組**最小值**的差，不是跟前一個數的差。

## 面試口說整理

子序列不在乎順序，所以我先排序。從最小的數開一組，往右把所有差距 `<= k` 的都放進去，超過就開新組。最小的數所在的那組本來就只能延伸到這裡，所以盡量延伸不會變差。時間 `O(n log n)`。
