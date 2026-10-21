---
title: "LeetCode 136: Single Number"
summary: "LeetCode 136 解題筆記：x ^ x = 0、x ^ 0 = x，把所有數 XOR 起來，出現兩次的互相抵消，剩下的就是答案"
description: "2022-08-16 的 LeetCode 136 解題紀錄"
date: 2022-08-16
tags: ["easy", "array", "bit-manipulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-16
- 提交紀錄：Accepted ×3

## 解題思路

XOR 有交換律和結合律，而且 `x ^ x = 0`、`x ^ 0 = x`（[Bit Manipulation]({{< relref "/algorithm/Bit-Manipulation" >}})）。把所有數 XOR 起來，出現兩次的兩兩抵消成 0，最後剩下只出現一次的數。`O(1)` 額外空間。

## 我的解法

```python
class Solution:
    def singleNumber(self, nums: List[int]) -> int:
        res = 0
        for x in nums:
            res ^= x
        return res
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 用雜湊表計數也可以，但題目要求 `O(1)` 空間。

## 面試口說整理

XOR 有交換律，相同的數 XOR 會變成 0，所以我把所有數 XOR 起來，出現兩次的都抵消了，剩下的就是答案。時間 `O(n)`、空間 `O(1)`。
