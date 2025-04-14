---
title: "LeetCode 1534: Count Good Triplets"
summary: "LeetCode 解題紀錄"
description: "LeetCode Daily"
date: 2025-04-14
tags: ["LeetCode", "blog", "daily", "easy"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試： 2025-04-14
- 總花費時間：2:00.00

## 解題思路

我們很容易會想到用暴力解法來處理這題。  
由於 `nums` 的範圍相對較小，一個 `O(n^3)` 的解法是可以接受的，不會導致 TLE（Time Limit Exceeded）。

## 解法

```python
class Solution:
    def countGoodTriplets(self, arr: List[int], a: int, b: int, c: int) -> int:
        res = 0
        n = len(arr)
        for i in range(n):
            for j in range(i+1, n):
                for k in range(j+1, n):
                    if abs(arr[i]-arr[j]) <= a and abs(arr[j]-arr[k]) <= b and abs(arr[i]-arr[k]) <= c:
                        res +=1

        return res
```

## 學習
NA

## 遇到的問題
NA