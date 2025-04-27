---
title: "LeetCode 1094: Car Pooling"
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
- 總花費時間：10:00.00

## 解題思路

這是一題典型的**差分陣列**問題。  
但由於一開始不知道陣列最大範圍，有兩種處理方式：
- **方法 1**：預先初始化一個固定長度的陣列（例如長度 1001）。
- **方法 2**：使用**哈希表（hash map）**記錄每個時間點的人數變化，  
  最後將索引排序並累加還原人數狀態。

使用 hash map 寫法更乾淨，且能避免浪費空間。

## 解法

因為使用了 hash map 並且要對鍵進行排序，  
所以時間複雜度是 **O(n log n)**。  
如果改用初始化好的固定長度陣列，則可以做到 **O(n)** 的時間複雜度。

```python
class Solution:
    def carPooling(self, trips: List[List[int]], capacity: int) -> bool:
        diff_map = {}
        
        for num, start, end in trips:
            diff_map[start] = diff_map.get(start, 0) + num
            diff_map[end] = diff_map.get(end, 0) - num

        start = 0

        for position in sorted(diff_map.keys()):
            start += diff_map[position]
            if start > capacity:
                return False

        return True
```

- 在上車地點 `start` 加上乘客數 `num`。
- 在下車地點 `end` 減去乘客數 `num`。
- 把所有時間點排序，並進行前綴累加模擬乘客人數變化。
- 如果任何時刻乘客人數超過 `capacity`，則回傳 `False`。

如果整個過程都符合條件，則可以順利完成所有行程。

## 收穫

NA

## 遇到的問題

NA