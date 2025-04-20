---
title: "LeetCode 2843: Count Symmetric Integers"
summary: "LeetCode 解題紀錄"
description: "LeetCode Daily"
date: 2025-04-11
tags: ["LeetCode", "blog", "daily", "easy", "digit DP"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試： 2025-04-11
- 總花費時間：5:00.00

## 解題思路

我原本有考慮使用 Digit DP 來解這題，但注意到題目限制中，最大數字只有到 10^5。

因此，我們其實可以直接用暴力法（brute-force）從 `start` 到 `end` 逐一遍歷所有數字。  
對每個數字來說，如果是奇數就跳過；如果是偶數，則找出中間的索引，接著比較從開頭到中間與從中間到結尾這兩段數位的總和是否相等。

這種解法的時間複雜度是 `O(n)`，空間複雜度是 `O(1)`。


## 解法
```python
class Solution:
    def countSymmetricIntegers(self, low: int, high: int) -> int:
        
        res = 0
        for num in range(low, high+1):
            str_num = str(num)

            if len(str_num)%2:
                continue
            
            half_index = len(str_num)//2
            if sum(map(int, list(str_num[:half_index]))) == sum(map(int, list(str_num[half_index:]))):
                res+=1

        return res
```
## 收穫
N/A

## 遇到的問題
N/A