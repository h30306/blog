---
title: "LeetCode 137: Single Number II"
summary: "LeetCode 137 解題筆記：其他數都出現三次，逐位元統計 1 的個數取 mod 3，剩下的位元就是答案；注意負數"
description: "2022-11-10 的 LeetCode 137 解題紀錄"
date: 2022-11-10
tags: ["medium", "array", "bit-manipulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-11-10
- 提交紀錄：Accepted（一次通過）

## 解題思路

XOR 只能抵消兩次。改成逐位元統計（[Bit Manipulation]({{< relref "/algorithm/Bit-Manipulation" >}})）：第 `b` 位上所有數的 1 加起來，出現三次的數貢獻 3 的倍數，所以 `count % 3` 就是答案在這一位的值。Python 的整數沒有固定位數，要用 32 位元處理：第 31 位是 1 時代表負數，減掉 `2^32`。

## 我的嘗試

一次 AC，當時是先排序，每三個一組檢查 `nums[i] != nums[i + 2]`，第一個不完整的組就是答案；排序是 `O(n log n)`，不符合線性時間的要求。

## 正確解法

```python
class Solution:
    def singleNumber(self, nums: List[int]) -> int:
        res = 0
        for b in range(32):
            if sum((x >> b) & 1 for x in nums) % 3:
                res |= 1 << b
        return res - (1 << 32) if res >> 31 else res
```

## 複雜度

時間 `O(32n)`，空間 `O(1)`。

## 要特別避免的錯誤

- Python 對負數右移會補 1，`(x >> b) & 1` 在 `b < 32` 時剛好是補數表示的那一位。
- 最後要把第 31 位是 1 的結果轉回負數。

## 面試口說整理

其他數都出現三次，所以我逐位元統計所有數這一位的 1 有幾個，取除以 3 的餘數就是答案這一位的值。Python 的整數沒有固定長度，最後第 31 位是 1 時要轉回負數。時間 `O(32n)`、空間 `O(1)`。
