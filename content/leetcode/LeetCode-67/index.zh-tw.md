---
title: "LeetCode 67: Add Binary"
summary: "LeetCode 67 解題筆記：從兩個字串的尾巴往前逐位相加，進位是 sum // 2，這一位是 sum % 2"
description: "2022-05-11 的 LeetCode 67 解題紀錄"
date: 2022-05-11
tags: ["easy", "math", "string", "bit-manipulation", "simulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-05-11
- 提交紀錄：Runtime Error ×2 → Wrong Answer ×5 → Accepted → Wrong Answer ×4 → Accepted

## 解題思路

跟十進位的直式加法一樣（[Math]({{< relref "/algorithm/Math" >}}) 模板六），只是基數是 2：從尾巴往前，每一位 `total = a + b + carry`，寫下 `total % 2`、進位 `total // 2`，比較短的那邊走完就當 0，最後還有進位要補上。

## 我的嘗試

這題提交了 13 次：

- 2022-05 的作法很特別：先把兩個字串**當成十進位**加起來，再把每一位的 2、3 轉成進位。但結果是 0 的位元沒有寫進答案：`"0" + "0"` 回傳空字串，`"0" + "10"` 回傳 `"1"`。補上 0 的情況就 AC 了。
- 2022-08 改成逐位相加，先用 `ljust` 在**右邊**補 0，位數對錯了；而且和是 0 的分支也把進位設成 1：`"1" + "1"` 回傳 `"0"`。改成 `rjust`、補上最後的進位才 AC。

## 正確解法

```python
class Solution:
    def addBinary(self, a: str, b: str) -> str:
        i, j, carry, res = len(a) - 1, len(b) - 1, 0, []
        while i >= 0 or j >= 0 or carry:
            total = carry
            if i >= 0:
                total += int(a[i])
                i -= 1
            if j >= 0:
                total += int(b[j])
                j -= 1
            res.append(str(total % 2))
            carry = total // 2
        return "".join(reversed(res))
```

## 複雜度

時間 `O(max(n, m))`，空間 `O(max(n, m))`。

## 要特別避免的錯誤

- 長度不同時要在**左邊**補 0（`rjust`），不是右邊。
- 每一種和（0、1、2、3）都要處理，包括寫下 0 的情況。
- 最後的進位要補上。

## 面試口說整理

跟十進位加法一樣，我從兩個字串的尾巴往前逐位相加，這一位是和除以 2 的餘數，進位是和除以 2，短的那邊走完就當成 0，最後的進位也要補上。時間 `O(max(n, m))`。
