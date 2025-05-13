---
title: "LeetCode 724: Find Pivot Index"
summary: "LeetCode 解題紀錄"
description: "LeetCode Daily"
date: 2025-04-19
tags: ["LeetCode", "daily", "easy", "prefix sum"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試： 2025-04-19
- 總花費時間：20:00.00

## 解題思路

一開始我使用了兩個 prefix sum 陣列 —— 一個從左到右，一個從右到左。

接著我從左側的索引開始遍歷到陣列末尾，當左側 prefix sum 的值和右側 prefix sum 的值相等時，就回傳該索引。

但後來我發現，其實不需要兩個 prefix sum 陣列。只要有從右到左的 prefix sum 就夠了。

至於左側的累加值，我可以只用一個變數來動態累加左半部的總和，這樣就能省下一個額外的陣列空間。


## 解法

```python
class Solution:
    def pivotIndex(self, nums: List[int]) -> int:
        n = len(nums)

        ps = [0] * (n + 1)

        for i in range(n-1, -1, -1):
            ps[i] = ps[i+1] + nums[i]
        
        
        count = 0
        for i in range(0, n):
            if ps[i+1] == count:
                return i
            count += nums[i]

        return -1
```

## 收穫

## 遇到的問題
在處理 prefix sum 時，陣列索引會是一個容易出錯的地方。

當我們從左到右遍歷時，需要使用 `ps[i + 1]` 來查對應的總和。這是因為 `ps` 陣列的第一個元素（`ps[0]`）代表的是「空的前綴」（也就是加總 0 個元素的結果）。

因此，若我們想要比較 `nums` 陣列中索引 `0` 的總和，就必須使用 `ps[1]` 才是正確的比較值。

如果誤用了 `ps[0]`，那就相當於在比較一個不存在的索引 `-1`，這會導致邏輯錯誤。因此，在使用 prefix sum 比較原陣列的區間總和時，要記得使用 `ps[i + 1]` 才能正確對應到索引 `i`。
