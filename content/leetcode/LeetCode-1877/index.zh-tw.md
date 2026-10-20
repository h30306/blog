---
title: "LeetCode 1877: Minimize Maximum Pair Sum in Array"
summary: "LeetCode 1877 解題筆記：排序後最小配最大、次小配次大，對撞指針取配對和的最大值"
description: "2026-01-24 的 LeetCode 1877 解題紀錄"
date: 2026-01-24
tags: ["medium", "two-pointers", "greedy", "sorting", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-01-24
- 提交紀錄：Accepted（一次通過）

## 解題思路

貪心：**最大的數一定要配最小的數**。如果最大的數配了別人 `x`，把 `x` 換成最小的數，最大配對和不會變大（交換論證）。

排序後用對撞指針，`nums[left] + nums[right]` 就是每一組，答案是這些和的最大值。

## 我的解法

```python
class Solution:
    def minPairSum(self, nums: List[int]) -> int:
        nums.sort()
        left, right = 0, len(nums) - 1
        best = 0
        while left < right:
            best = max(best, nums[left] + nums[right])
            left += 1
            right -= 1
        return best
```

## 複雜度

時間 `O(n log n)`，空間 `O(1)`（不算排序）。

## 要特別避免的錯誤

- 相鄰的兩個配在一起：最大的兩個會加在一起，配對和反而最大。

## 面試口說整理

最大的數不管配誰都會出現在某一組，配最小的才能讓這組最小，交換論證可以證明這樣不會更差。排序後最小配最大、往內收，取所有配對和的最大值。時間 `O(n log n)`。
