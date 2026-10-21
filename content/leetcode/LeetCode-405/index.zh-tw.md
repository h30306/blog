---
title: "LeetCode 405: Convert a Number to Hexadecimal"
summary: "LeetCode 405 解題筆記：負數先加上 2^32 變成補數，再每次取 4 個位元（% 16）轉成十六進位；0 要特別處理"
description: "2022-08-23 的 LeetCode 405 解題紀錄"
date: 2022-08-23
tags: ["easy", "math", "string", "bit-manipulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-23
- 提交紀錄：Runtime Error ×2 → Wrong Answer ×2 → Accepted

## 解題思路

十六進位每一位就是 4 個位元（[Bit Manipulation]({{< relref "/algorithm/Bit-Manipulation" >}})，也是 [Math]({{< relref "/algorithm/Math" >}}) 模板七的進位轉換）。負數用 32 位元補數表示，`num & 0xffffffff`（等於加上 `2^32`）就是對應的正數。接著每次取 `num & 15` 查表、`num >>= 4`，直到 0。`num = 0` 時迴圈不會執行，要回傳 `"0"`。

## 我的嘗試

- 第一版迴圈條件寫成 `num > 15`，**最後一位沒有寫進去**，`num = 0` 時也回傳空字串。
- 補上 `0` 的特例後，**負數沒有處理**：`-9` 回傳空字串，答案 `"fffffff7"`。加上 `num += 2**32` 就 AC 了。

## 正確解法

```python
class Solution:
    def toHex(self, num: int) -> str:
        if num == 0:
            return "0"
        num &= 0xFFFFFFFF
        digits = "0123456789abcdef"
        res = []
        while num:
            res.append(digits[num & 15])
            num >>= 4
        return "".join(reversed(res))
```

## 複雜度

時間 `O(8)`，空間 `O(1)`。

## 要特別避免的錯誤

- 負數要先轉成 32 位元的補數。
- 迴圈條件是 `num > 0`，`num > 15` 會少最後一位。
- `0` 要回傳 `"0"`。

## 面試口說整理

負數先跟 0xffffffff 做 AND 變成 32 位元補數對應的正數，之後每次取最低的 4 個位元查表、右移 4 位，最後反轉；0 直接回傳。最多 8 位。
