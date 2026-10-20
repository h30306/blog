---
title: "LeetCode 3627: Maximum Median Sum of Subsequences of Size 3"
summary: "LeetCode 3627 解題筆記：排序後每次拿最大的兩個和最小的一個，中位數是第二大的；答案是從尾端往前每隔一個取，共 n / 3 個"
description: "2025-07-27 的 LeetCode 3627 解題紀錄"
date: 2025-07-27
tags: ["medium", "math", "greedy", "sorting", "game-theory", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2025-07-27
- 提交紀錄：Time Limit Exceeded → Accepted

## 解題思路

每次選三個數，得到的是中位數。最大的數永遠不可能是中位數，所以：

- 每一組都拿**目前最大的兩個**，再配**目前最小的一個**當墊底。中位數是那兩個大的裡面比較小的。
- 最小的 `n / 3` 個數全部拿去墊底。

排序後，答案是 `nums[-2] + nums[-4] + ... `，從尾端往前每隔一個取，取 `n / 3` 個。

## 我的嘗試

第一版直接模擬：排序後每次 `pop()` 兩次、`pop(0)` 一次。`pop(0)` 要把整個陣列往前移，是 `O(n)`，總共 `O(n^2)`，TLE。改成直接算 index 就 AC 了。

## 正確解法

```python
class Solution:
    def maximumMedianSum(self, nums: List[int]) -> int:
        nums.sort()
        n = len(nums)
        return sum(nums[n - 2 - 2 * i] for i in range(n // 3))
```

## 複雜度

時間 `O(n log n)`，空間 `O(1)`（不算排序）。

## 要特別避免的錯誤

- `list.pop(0)` 是 `O(n)`。
- 最大的數只能當最大值，不能當中位數，所以每組要「浪費」一個大的。

## 面試口說整理

最大的數不可能是中位數，所以每一組拿目前最大的兩個和最小的一個，中位數是第二大的。排序後答案就是從尾端往前每隔一個取，取 `n / 3` 個。時間 `O(n log n)`。
