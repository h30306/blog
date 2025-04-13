---
title: "LeetCode 556: Next Greater Element III"
summary: "LeetCode 解題紀錄"
description: "LeetCode"
date: 2025-04-13
tags: ["LeetCode", "blog", "medium"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試： 2025-04-13
- 總花費時間：5:00.00

## 解題思路

這是一個經典的 Next Permutation 問題，但額外多了一個限制條件：  
最終結果必須符合 32 位元有號整數的範圍。  
因此，在演算法的最後，我們需要額外進行一次判斷，以確保結果是有效的。

## 解法
```
class Solution:
    def nextGreaterElement(self, n: int) -> int:
        digits = list(str(n))

        i = len(digits)-2
        while i != -1 and digits[i]>=digits[i+1]:
            i -= 1

        if i == -1:
            return -1

        j = len(digits)-1
        while digits[i]>=digits[j]: 
            j -=1

        digits[i], digits[j] = digits[j], digits[i]
        digits[i+1:] = reversed(digits[i+1:])
        res = int("".join(digits))

        return res if res < 1<<31 else -1
```
## 學習
1. `1 << 32` 表示將數字 1 左移到第 32 個位元位置，等價於計算 2 的 32 次方。


## 遇到的問題
NA