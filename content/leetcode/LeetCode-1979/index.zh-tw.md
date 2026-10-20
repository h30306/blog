---
title: "LeetCode 1979: Find Greatest Common Divisor of Array"
summary: "LeetCode 1979 解題筆記：找出最小值和最大值，用輾轉相除法算 GCD"
description: "2025-05-17 的 LeetCode 1979 解題紀錄"
date: 2025-05-17
tags: ["easy", "math", "number-theory", "gcd", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2025-05-17
- 提交紀錄：Accepted ×3

## 解題思路

只要最小值和最大值的 GCD。輾轉相除法：`gcd(a, b) = gcd(b, a % b)`，直到 `b == 0`，答案是 `a`。

## 我的解法

```python
class Solution:
    def findGCD(self, nums: List[int]) -> int:
        a, b = max(nums), min(nums)
        while b:
            a, b = b, a % b
        return a
```

第三次提交改成一次掃描同時找最小和最大值，省一次走訪；也可以直接 `math.gcd(min(nums), max(nums))`。

## 複雜度

時間 `O(n + log M)`，空間 `O(1)`。

## 要特別避免的錯誤

- 輾轉相除的迴圈條件是 `b != 0`，最後回傳 `a`。

## 面試口說整理

我先找出最小值和最大值，再用輾轉相除法：每次把 `(a, b)` 換成 `(b, a % b)`，`b` 變成 0 時 `a` 就是 GCD。時間 `O(n + log M)`。
