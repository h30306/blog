---
title: "LeetCode 168: Excel Sheet Column Title"
summary: "LeetCode 168 解題筆記：Excel 欄名是沒有 0 的 26 進位，每一位用 (n - 1) % 26 取字母，再 n = (n - 1) // 26"
description: "2022-08-20 的 LeetCode 168 解題紀錄"
date: 2022-08-20
tags: ["easy", "math", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-20
- 提交紀錄：Internal Error → Wrong Answer ×3 → Runtime Error ×3 → Wrong Answer → Accepted

## 解題思路

一般的進位制每一位是 `0..25`，但欄名每一位是 `1..26`（`A..Z`），**沒有 0**。所以每一步先 `n -= 1`，把 `1..26` 平移成 `0..25`，再用 `% 26` 取最後一位的字母、`// 26` 往前（[Math]({{< relref "/algorithm/Math" >}}) 模板七）。最後把字母反轉。

## 我的嘗試

這題提交了 9 次：

- 前四版假設**最多兩個字母**，寫成 `capitals[n // 26] + capitals[n % 26]`：`1` 回傳 `"AB"`，答案 `"A"`。
- 改成遞迴之後，一版參數名稱打錯（NameError），一版只有字母那邊減 1，**遞迴往前的那邊沒有減**：`52` 回傳 `"BZ"`，答案 `"AZ"`。兩邊都用 `n - 1` 才 AC。

## 正確解法

```python
class Solution:
    def convertToTitle(self, columnNumber: int) -> str:
        res = []
        n = columnNumber
        while n:
            n, r = divmod(n - 1, 26)
            res.append(chr(ord("A") + r))
        return "".join(reversed(res))
```

## 複雜度

時間 `O(log n)`，空間 `O(log n)`。

## 要特別避免的錯誤

- 每一步都要先減 1，不是只有最後一位：`52` 是 `"AZ"`，不是 `"BZ"`。
- 位數不固定，不能假設最多兩個字母。

## 面試口說整理

欄名是沒有 0 的 26 進位，每一位是 1 到 26，所以我每一步先減一變成 0 到 25，取餘數當字母、整除後繼續，最後反轉。時間 `O(log n)`。
