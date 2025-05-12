---
title: "LeetCode 1550: Three Consecutive Odds"
summary: "LeetCode 解題紀錄"
description: "LeetCode Daily"
date: 2025-05-11
tags: ["LeetCode", "blog", "array", "easy"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試： 2025-05-11
- 總花費時間：50:00.00

## 解題思路

設定一個計數器來紀錄連續的奇數個數。  
當計數達到 3，就可以提前回傳結果為 True。

## 解法

```python
class Solution:
    def threeConsecutiveOdds(self, arr: List[int]) -> bool:
        
        count = 0
        for num in arr:
            if num%2:
                count+=1
            else:
                count = 0

            if count == 3:
                return True

        return False
```

## 收穫

## 遇到的問題