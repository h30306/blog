---
title: "LeetCode 1464: Maximum Product of Two Elements in an Array"
summary: "LeetCode 1464 解題筆記：值都是正數，取最大的兩個數 a、b，答案是 (a - 1)(b - 1)"
description: "2022-11-21 的 LeetCode 1464 解題紀錄"
date: 2022-11-21
tags: ["easy", "array", "sorting", "heap-priority-queue"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-11-21
- 提交紀錄：Accepted（一次通過）

## 解題思路

`nums[i] >= 1`，所以 `(x - 1) >= 0`，乘積最大就是兩個最大的數。掃一次記錄最大和第二大（或用 heap 拿兩次，[Heap]({{< relref "/algorithm/Heap" >}})）。

## 我的嘗試

一次 AC，當時是把所有數變成負的放進 heap，彈出兩次取最大的兩個。

## 正確解法

```python
class Solution:
    def maxProduct(self, nums: List[int]) -> int:
        a = b = 0
        for x in nums:
            if x > a:
                a, b = x, a
            elif x > b:
                b = x
        return (a - 1) * (b - 1)
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 更新最大值時，舊的最大值要移到第二大。

## 面試口說整理

值都是正數，乘積最大就是兩個最大的數各減一相乘，我掃一次記錄最大和第二大。時間 `O(n)`、空間 `O(1)`。
