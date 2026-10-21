---
title: "LeetCode 50: Pow(x, n)"
summary: "LeetCode 50 解題筆記：快速冪，x^n = (x²)^(n/2)，n 是奇數時多乘一個 x；n 是負數時算 1 / x^(-n)"
description: "2022-11-14 的 LeetCode 50 解題紀錄"
date: 2022-11-14
tags: ["medium", "math", "recursion"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-11-14
- 提交紀錄：Accepted（一次通過）

## 解題思路

快速冪（[Math]({{< relref "/algorithm/Math" >}}) 模板八）：`n` 是偶數時 `x^n = (x²)^(n/2)`，奇數時再多乘一個 `x`，每次 `n` 減半，只要 `O(log n)` 次乘法。`n < 0` 時先把 `x` 換成 `1 / x`、`n` 換成 `-n`。迭代版本是看 `n` 的二進位：哪一位是 1，就把目前的 `x^(2^k)` 乘進答案。

## 我的嘗試

一次 AC，當時用的是遞迴版：`n < 0` 回傳 `1 / myPow(x, -n)`，奇數 `x * myPow(x, n - 1)`，偶數 `myPow(x * x, n // 2)`。

## 正確解法

```python
class Solution:
    def myPow(self, x: float, n: int) -> float:
        if n < 0:
            x, n = 1 / x, -n
        res = 1.0
        while n:
            if n & 1:
                res *= x
            x *= x
            n >>= 1
        return res
```

## 複雜度

時間 `O(log n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 一次乘一個 `x` 是 `O(n)`，`n` 到 `2^31` 會超時。
- 負的指數要取倒數。
- `n = 0` 時答案是 1。

## 面試口說整理

我用快速冪，看 n 的二進位，每一位是 1 就把目前的 x 乘進答案，x 每次平方、n 每次右移一位；n 是負數時先換成 1 / x 和 -n。時間 `O(log n)`。
