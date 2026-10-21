---
title: "LeetCode 43: Multiply Strings"
summary: "LeetCode 43 解題筆記：num1[i] × num2[j] 的結果落在第 i + j + 1 位，用一個長度 n + m 的陣列累加後再統一進位"
description: "2022-10-21 的 LeetCode 43 解題紀錄"
date: 2022-10-21
tags: ["medium", "math", "string", "simulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-10-21
- 提交紀錄：Runtime Error ×2 → Wrong Answer ×5 → Accepted

## 解題思路

直式乘法（[Math]({{< relref "/algorithm/Math" >}}) 模板六）：長度 `n` 和 `m` 的數相乘最多 `n + m` 位。`num1[i] * num2[j]` 加到 `res[i + j + 1]`（從左邊數的位置），**每一對位數都要乘到**，總共 `n × m` 次。全部加完後從右往左統一進位，最後去掉開頭的 0（全部是 0 時保留一個）。

## 我的嘗試

這題提交了 8 次：

- 2022-10 的幾版用 `zip(num1, num2)` **只把同一個位置的位數兩兩相乘**，這根本不是乘法：`"4" × "12"` 只算了 `4 × 1`（或反轉後的 `4 × 2`），回傳 `"4"`、`"8"`，答案 `"48"`。另外前幾版把整數接到字串上（TypeError）、回傳了整數 `0` 而不是 `"0"`。
- 2022-11 重寫成正確的直式乘法：每一位乘出一個部分積，往左補 0 再相加。第一次還是回傳整數，改成 `str` 就 AC 了。**不過這版是把每個部分積轉成 Python 的 `int` 相加**，嚴格來說繞過了「不能轉成整數」的限制；上面的陣列寫法完全不需要。

## 正確解法

```python
class Solution:
    def multiply(self, num1: str, num2: str) -> str:
        n, m = len(num1), len(num2)
        res = [0] * (n + m)
        for i in range(n - 1, -1, -1):
            for j in range(m - 1, -1, -1):
                res[i + j + 1] += int(num1[i]) * int(num2[j])
        for k in range(n + m - 1, 0, -1):
            res[k - 1] += res[k] // 10
            res[k] %= 10
        s = "".join(map(str, res)).lstrip("0")
        return s or "0"
```

## 複雜度

時間 `O(nm)`，空間 `O(n + m)`。

## 要特別避免的錯誤

- 不能只把同一個位置的位數兩兩相乘，每一位都要跟另一個數的每一位相乘。
- 回傳字串，不是整數。
- 題目不允許直接轉成整數；把部分積轉成 `int` 相加也是在繞過限制。
- 開頭的 0 要去掉，但 `"0"` 要保留。

## 面試口說整理

我開一個長度 n + m 的陣列，num1 的第 i 位乘 num2 的第 j 位加到第 i + j + 1 格，全部乘完後從右往左統一進位，再去掉開頭的 0。時間 `O(nm)`，沒有轉成整數。
