---
title: "LeetCode 509: Fibonacci Number"
summary: "LeetCode 509 解題筆記：一維 DP 的起點：只需要前兩項，用兩個變數滾動"
description: "2022-08-25 的 LeetCode 509 解題紀錄"
date: 2022-08-25
tags: ["easy", "math", "dynamic-programming", "recursion", "memoization"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-25
- 提交紀錄：Accepted → Runtime Error → Accepted ×2

## 解題思路

`F(n) = F(n - 1) + F(n - 2)`，每一項只依賴前兩項，所以不用開陣列，用兩個變數往前滾動（[Linear DP]({{< relref "/algorithm/Linear-DP" >}}) 模板一）。直接遞迴不加記憶化是 `O(2^n)`。

## 我的嘗試

2022-11 重寫時寫成 `for _ in n`，**整數不能迭代**（TypeError），改成 `range(n)` 就 AC 了。

## 正確解法

```python
class Solution:
    def fib(self, n: int) -> int:
        a, b = 0, 1
        for _ in range(n):
            a, b = b, a + b
        return a
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 迴圈要寫 `range(n)`，不能 `for _ in n`。
- 沒有記憶化的遞迴是指數時間。

## 面試口說整理

每一項只依賴前兩項，我用兩個變數往前滾動 n 次，時間 `O(n)`、空間 `O(1)`。
