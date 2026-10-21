---
title: "LeetCode 1137: N-th Tribonacci Number"
summary: "LeetCode 1137 解題筆記：跟 Fibonacci 一樣，用三個變數滾動；小心 T0 = 0、T1 = T2 = 1 的起始值和迴圈範圍"
description: "2022-10-18 的 LeetCode 1137 解題紀錄"
date: 2022-10-18
tags: ["easy", "math", "dynamic-programming", "memoization"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-10-18
- 提交紀錄：Wrong Answer ×3 → Accepted → Wrong Answer ×2 → Runtime Error ×2 → Accepted ×2 → Wrong Answer → Accepted

## 解題思路

`T(n) = T(n - 1) + T(n - 2) + T(n - 3)`，三個變數往前滾動（[Linear DP]({{< relref "/algorithm/Linear-DP" >}}) 模板一）。從 `(T0, T1, T2) = (0, 1, 1)` 開始，每次往前推一步，推 `n` 次之後第一個變數就是 `T(n)`，這樣 `n = 0, 1, 2` 也不用特別處理。

## 我的嘗試

這題寫了四次（2022-10、2022-11 兩次、2024），錯了 8 次，全部都是邊界：

- 2022-10 第一版 `n < 3` 時一律回傳 0，**`T1`、`T2` 是 1**；迴圈寫成 `range(3, n)` 少推一次，就改成回傳 `sum(T)`，等於再多算一項，邊界一直對不齊。
- 2024 年沒有寫 `n < 3` 的特例，迴圈不執行時回傳 `n3 = 1`：`n = 0` 回傳 1，答案 0。

## 正確解法

```python
class Solution:
    def tribonacci(self, n: int) -> int:
        a, b, c = 0, 1, 1
        for _ in range(n):
            a, b, c = b, c, a + b + c
        return a
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- `T1`、`T2` 都是 1，不是 0。
- 迴圈次數差一很容易：讓「推 `n` 次之後回傳第一個」可以避開。

## 面試口說整理

跟 Fibonacci 一樣，我用三個變數從 0、1、1 開始往前推 n 次，第一個變數就是答案，n 很小的情況也自然處理了。時間 `O(n)`。
