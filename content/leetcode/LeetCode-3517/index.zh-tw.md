---
title: "LeetCode 3517: Smallest Palindromic Rearrangement I"
summary: "LeetCode 解題紀錄"
description: "LeetCode Weekly Contest 445"
date: 2025-04-13
series: ["LeetCode Weekly Contest 445"]
series_order: 2
tags: ["LeetCode", "weekly", "medium"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試： 2025-04-13
- 總花費時間：05:00.00

## 解題思路

我們需要先判斷字串的長度是奇數還是偶數，以確認是否有中間的字元需要額外處理。  
接著，根據 `ord()` 對字串的前半部分進行排序，最後將排序後的左半部分、中間字元（如果有的話），以及左半部分的反轉結果串接起來，組合成最終的結果。


## 解法
```
class Solution:
    def smallestPalindrome(self, s: str) -> str:
        odd = len(s)%2
        helf_index = len(s)//2
        left = list(s[:helf_index])
        
        middle_str = s[helf_index] if odd else ""
        
        left_sorted = "".join(sorted(left, key=ord))
        
        return left_sorted+middle_str+left_sorted[::-1]
```

## 收穫
NA

## 遇到的問題
NA