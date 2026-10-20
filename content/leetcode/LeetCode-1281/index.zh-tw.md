---
title: "LeetCode 1281: Subtract the Product and Sum of Digits of an Integer"
summary: "LeetCode 1281 解題筆記：一次走過所有位數，同時累積積與和，回傳積減和"
description: "2025-12-23 的 LeetCode 1281 解題紀錄"
date: 2025-12-23
tags: ["easy", "math"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2025-12-23
- 提交紀錄：Accepted（C++，一次通過）

## 解題思路

走過每個位數，積從 1 開始乘、和從 0 開始加，回傳 `積 - 和`。

## 我的解法

我當時用 C++ 的 `to_string` 走位數，這裡放等價的 Python：

```python
class Solution:
    def subtractProductAndSum(self, n: int) -> int:
        product, total = 1, 0
        while n:
            d = n % 10
            product *= d
            total += d
            n //= 10
        return product - total
```

## 複雜度

時間 `O(d)`，空間 `O(1)`。

## 要特別避免的錯誤

- 積的初始值是 1，不是 0。

## 面試口說整理

用 `% 10` 一位一位拿出來，同時累積積和和，最後相減。時間 `O(d)`。
