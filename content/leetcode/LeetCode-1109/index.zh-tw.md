---
title: "LeetCode 1109: Corporate Flight Bookings"
summary: "LeetCode 解題紀錄"
description: "LeetCode Daily"
date: 2025-04-27
tags: ["LeetCode", "blog", "difference array", "medium"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試： 2025-04-27
- 總花費時間：5:00.00

## 解題思路

這是一題經典的**差分陣列**問題，且已知陣列大小 `n`。  
因此可以直接初始化長度為 `n+1` 的差分陣列。  
接著，遍歷 `bookings` 陣列，對應起飛與降落的位置更新差分值。  
最後，透過前綴和累加，還原每個航班最終預訂的座位數量。

## 解法


```python
class Solution:
    def corpFlightBookings(self, bookings: List[List[int]], n: int) -> List[int]:
        diff_array = [0] * (n + 1)

        for start, end, seat in bookings:
            diff_array[start - 1] += seat
            diff_array[end] -= seat

        res = []
        diff = 0
        for seat in diff_array[:-1]:
            diff += seat
            res.append(diff)

        return res
```

- `start - 1` 是因為航班編號是從 1 開始，但陣列是從 0 開始。
- 在 `end` 處減去座位數，代表航班結束後不再計算這次預訂。
- 最後透過前綴和還原各航班的最終座位數。

## 收穫

## 遇到的問題

我第一次遇到索引錯誤（index not found），  
因為一開始沒有意識到航班編號是從 1 開始（1-indexed）。  
這導致在更新差分陣列時出現了 off-by-one 的錯誤。  
後來把 `start` 調整成 `start - 1`，問題就解決了。