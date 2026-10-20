---
title: "LeetCode 2401: Longest Nice Subarray"
summary: "LeetCode 2401 解題筆記：兩兩 AND 為 0 ⇔ 每個 bit 最多被一個數用到；用一個 mask 記錄視窗用掉的 bit，衝突就縮左邊並把它的 bit 拿掉"
description: "2026-01-22 的 LeetCode 2401 解題紀錄"
date: 2026-01-22
tags: ["medium", "sliding-window", "bit-manipulation", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-01-22
- 提交紀錄：Accepted（一次通過）

## 解題思路

視窗裡任兩個數 AND 都是 0 ⇔ **每個 bit 最多只被一個數使用**。所以用一個整數 `used` 記錄視窗裡所有數的 OR：

- 新的數 `x` 跟 `used` 有重疊（`used & x != 0`），就縮左邊，直到沒有重疊。
- 移出 `nums[left]` 時，它的 bit 一定只屬於它自己，用 `used ^= nums[left]`（或 `&= ~`）拿掉。
- 加入 `x`：`used |= x`。

數字最多 30 個 bit，所以合法的視窗最長只有 30。

## 我的解法

```python
class Solution:
    def longestNiceSubarray(self, nums: List[int]) -> int:
        used = left = best = 0
        for right, x in enumerate(nums):
            while used & x:                        # 有 bit 衝突
                used ^= nums[left]                 # 它的 bit 只屬於它，XOR 就能拿掉
                left += 1
            used |= x
            best = max(best, right - left + 1)
        return best
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 用 `-=` 或 `^=` 拿掉 bit 之所以正確，是因為視窗裡的 bit 互不重疊；如果重疊就不能這樣做。

## 面試口說整理

兩兩 AND 為 0，代表每個 bit 最多被一個數用到，所以我用一個整數記錄視窗用掉的 bit。新的數跟它有重疊就縮左邊，移出的數 bit 只屬於它自己，XOR 就能拿掉。記錄最長長度，時間 `O(n)`。
