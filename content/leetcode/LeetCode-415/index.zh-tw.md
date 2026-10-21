---
title: "LeetCode 415: Add Strings"
summary: "LeetCode 415 解題筆記：兩個指標從尾巴往前逐位相加，記錄進位，迴圈結束後還有進位要補上"
description: "2022-08-24 的 LeetCode 415 解題紀錄"
date: 2022-08-24
tags: ["easy", "math", "string", "simulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-24
- 提交紀錄：Runtime Error ×4 → Wrong Answer ×2 → Accepted

## 解題思路

直式加法（[Math]({{< relref "/algorithm/Math" >}}) 模板六）：`i`、`j` 從兩個字串的尾巴往前，比較短的那個走完就當成 0。每一位 `total = a + b + carry`，寫下 `total % 10`，進位是 `total // 10`。**迴圈結束時如果還有進位**，要再補一位。最後把結果反轉。

## 我的嘗試

這題提交了 7 次：

- 第一版語法錯誤，接著寫成 `i = j = len(num1) - 1, len(num2) - 1`，**兩個變數都變成同一個 tuple**（TypeError）；之後兩版忘了把字元轉成 `int`。
- 修好之後**忘了最後的進位**：`"8" + "6"` 回傳 `"4"`。下一版補的是 `total` 而不是進位 `temp`，回傳 `"44"`。改成補 `temp` 就 AC 了。

## 正確解法

```python
class Solution:
    def addStrings(self, num1: str, num2: str) -> str:
        i, j, carry = len(num1) - 1, len(num2) - 1, 0
        res = []
        while i >= 0 or j >= 0 or carry:
            a = int(num1[i]) if i >= 0 else 0
            b = int(num2[j]) if j >= 0 else 0
            carry, d = divmod(a + b + carry, 10)
            res.append(str(d))
            i, j = i - 1, j - 1
        return "".join(reversed(res))
```

## 複雜度

時間 `O(max(n, m))`，空間 `O(max(n, m))`。

## 要特別避免的錯誤

- 最後的進位要補上：`"8" + "6"` 是 `"14"`。
- 補的是進位 `carry`，不是最後一位的 `total`。
- `i = j = a, b` 會讓兩個變數都變成 tuple。

## 面試口說整理

我用兩個指標從尾巴往前逐位相加，短的那邊走完就當成 0，記錄進位，把進位也放進迴圈條件，這樣最後的進位不會漏掉，最後把結果反轉。時間 `O(max(n, m))`。
