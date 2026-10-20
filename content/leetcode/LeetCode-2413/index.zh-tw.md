---
title: "LeetCode 2413: Smallest Even Multiple"
summary: "LeetCode 2413 解題筆記：lcm(2, n)；n 是偶數就是 n，奇數就是 2n"
description: "2025-12-17 的 LeetCode 2413 解題紀錄"
date: 2025-12-17
tags: ["easy", "math", "number-theory"]
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
- 提交紀錄：Accepted（Python）→ Wrong Answer（C++）→ Accepted（C++）

## 解題思路

同時是 2 和 `n` 的倍數的最小正整數就是 `lcm(2, n)`：

- `n` 是偶數：`n` 本身就是 2 的倍數，答案是 `n`。
- `n` 是奇數：`gcd(2, n) = 1`，答案是 `2n`。

## 我的嘗試

Python 一次 AC。改用 C++ 練習時，三元運算子的兩個分支寫反了：`(n % 2) ? n : n * 2`，`n % 2` 是 1（奇數）時回傳 `n`。例如 `n = 5`：答案是 10，回傳 5。

## 正確解法

```python
class Solution:
    def smallestEvenMultiple(self, n: int) -> int:
        return n if n % 2 == 0 else 2 * n
```

## 複雜度

時間 `O(1)`，空間 `O(1)`。

## 要特別避免的錯誤

- `n % 2` 在奇數時是真值（1），條件寫成 `n % 2 == 0` 比較不會搞反。

## 面試口說整理

答案是 2 和 `n` 的最小公倍數：`n` 是偶數時就是 `n`，奇數時 2 和 `n` 互質，答案是 `2n`。時間 `O(1)`。
