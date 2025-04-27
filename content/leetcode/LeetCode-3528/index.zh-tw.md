---
title: "LeetCode 3528: Unit Conversion I"
summary: "LeetCode 解題紀錄"
description: "LeetCode Bi-Weekly Contest 155"
date: 2025-04-26
series: ["LeetCode Bi-Weekly Contest 155"]
series_order: 2
tags: ["LeetCode", "blog", "bi-weekly", "medium"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試： 2025-04-26
- 總花費時間：10:00.00

## 解題思路

暴力解法：  
直接遍歷 `conversions` 陣列並統計結果。

## 解法

```python
class Solution:
    def baseUnitConversions(self, conversions: List[List[int]]) -> List[int]:
        n = len(conversions)+1
        base = [1]*n
        
        for (start, end, times) in conversions:
            base[end] = (base[start]*times)%(10**9 + 7)
            
        
        return base
```

## 收穫

NA

## 遇到的問題

NA