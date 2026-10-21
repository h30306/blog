---
title: "LeetCode 171: Excel Sheet Column Number"
summary: "LeetCode 171 解題筆記：從左到右 res = res × 26 + 字母的值（A = 1）"
description: "2022-08-21 的 LeetCode 171 解題紀錄"
date: 2022-08-21
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
第一次嘗試：2022-08-21
- 提交紀錄：Runtime Error → Accepted ×7

## 解題思路

LC 168 的反方向（[Math]({{< relref "/algorithm/Math" >}}) 模板七）：每一位的值是 `ord(c) - ord("A") + 1`，從左到右 `res = res * 26 + 值`，跟把十進位字串轉成整數一樣。

## 我的嘗試

第一版寫成 `for i, n in columnTitle[::-1]`，**少了 `enumerate`**，拆不出兩個值（ValueError）。補上就 AC 了。

## 正確解法

```python
class Solution:
    def titleToNumber(self, columnTitle: str) -> int:
        res = 0
        for c in columnTitle:
            res = res * 26 + ord(c) - ord("A") + 1
        return res
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- `A` 是 1，不是 0。
- 要同時拿 index 和字元時用 `enumerate`。

## 面試口說整理

我從左到右掃，每次把目前的結果乘 26 再加上這個字母的值，A 是 1。時間 `O(n)`。
