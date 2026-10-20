---
title: "LeetCode 2469: Convert the Temperature"
summary: "LeetCode 2469 解題筆記：直接套公式，Kelvin = C + 273.15，Fahrenheit = C × 1.8 + 32"
description: "2025-12-17 的 LeetCode 2469 解題紀錄"
date: 2025-12-17
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
第一次嘗試：2025-12-17
- 提交紀錄：Accepted（C++，一次通過）

## 解題思路

題目給了兩個轉換公式，直接套用，依序回傳 `[Kelvin, Fahrenheit]`。允許 `1e-5` 的誤差，所以浮點數運算沒問題。

## 我的解法

我當時用 C++ 寫，這裡放等價的 Python：

```python
class Solution:
    def convertTemperature(self, celsius: float) -> List[float]:
        return [celsius + 273.15, celsius * 1.8 + 32]
```

## 複雜度

時間 `O(1)`，空間 `O(1)`。

## 要特別避免的錯誤

- 回傳順序是 Kelvin 在前、Fahrenheit 在後。

## 面試口說整理

直接套兩個公式回傳。題目允許 `1e-5` 的誤差，所以浮點數誤差不影響。時間 `O(1)`。
