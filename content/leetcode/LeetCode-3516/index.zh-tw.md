---
title: "LeetCode 3516: Find Closest Person"
summary: "LeetCode 解題紀錄"
description: "LeetCode Weekly Contest 445"
date: 2025-04-13
series: ["LeetCode Weekly Contest 445"]
series_order: 1
tags: ["LeetCode", "weekly", "easy"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試： 2025-04-13
- 總花費時間：02:00.00

## 解題思路

只需要使用暴力法來計算 `x` 到 `z` 和 `y` 到 `z` 的距離，然後比較這兩個距離並回傳結果。

## 解法
```python
class Solution:
    def findClosest(self, x: int, y: int, z: int) -> int:
        distance_x_z = abs(z-x)
        distance_y_z = abs(z-y)
        
        if distance_x_z>distance_y_z:
            return 2
        elif distance_x_z<distance_y_z:
            return 1
        return 0
```

## 收穫
NA

## 遇到的問題
NA