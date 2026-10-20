---
title: "LeetCode 3750: Minimum Number of Flips to Reverse Binary String"
summary: "LeetCode 3750 解題筆記：把二進位字串跟它的反轉逐位比較，不同的位數就是答案"
description: "2025-11-22 的 LeetCode 3750 解題紀錄"
date: 2025-11-22
tags: ["easy", "two-pointers", "bit-manipulation", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2025-11-22
- 提交紀錄：Accepted（一次通過）

## 解題思路

把 `n` 轉成不含前導零的二進位字串 `s`，要變成 `s` 的反轉，每次翻一位。

位置 `i` 要變成 `s[len - 1 - i]`，兩者不同就要翻一次，所以答案就是 `s` 和它的反轉有幾個位置不同。

用對撞指針看的話：位置 `i` 和 `len - 1 - i` 這一對，如果兩個字元不同，兩邊都要翻，所以每一對不同就貢獻 2。

## 我的解法

```python
class Solution:
    def minimumFlips(self, n: int) -> int:
        s = bin(n)[2:]
        return sum(a != b for a, b in zip(s, reversed(s)))
```

原本的版本先建一個反轉後的字串，再用迴圈逐位比較，邏輯一樣。

## 複雜度

時間 `O(log n)`，空間 `O(log n)`。

## 要特別避免的錯誤

- 用 `bin(n)` 沒有去掉開頭的 `0b`。
- 誤以為要反轉成「另一個數字」再比較數值：比的是每一個位元。

## 面試口說整理

我把 `n` 轉成二進位字串，跟它的反轉逐位比較，不同的位數就是要翻的次數，因為每一位只要翻一次就會變成目標。時間跟位元數成正比，也就是 `O(log n)`。
