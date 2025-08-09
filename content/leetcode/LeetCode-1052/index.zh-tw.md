---
title: "LeetCode 1052: Grumpy Bookstore Owner"
summary: "LeetCode 解題紀錄 - 固定窗口與客戶滿意度優化"
description: "LeetCode Daily - 使用滑動窗口技巧最大化客戶滿意度"
date: 2025-08-03
tags: ["LeetCode", "daily", "medium", "sliding window", "array", "optimization", "fixed window"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試： 2025-08-03
- 總花費時間：00:00.00


## 解題思路

這是一個固定窗口問題。給定書店老闆可以控制其暴躁情緒的分鐘數，我們可以首先計算當老闆總是暴躁時的基本滿意客戶數量。然後我們從左到右滑動一個大小為 `minutes` 的窗口，計算如果老闆在該窗口期間使用其技巧，可以額外滿意多少客戶。

## 解法

### 固定窗口與客戶滿意度優化
```python
class Solution:
    def maxSatisfied(self, customers: List[int], grumpy: List[int], minutes: int) -> int:
        
        # 計算當老闆總是暴躁時的基本滿意度
        base_serve = 0
        for i in range(len(grumpy)):
            base_serve += (not grumpy[i]) * customers[i]

        # 計算初始窗口滿意度
        serve = 0
        for i in range(minutes):
            if grumpy[i]:
                serve += customers[i]

        max_serve = serve
        
        # 滑動窗口並尋找最大額外滿意度
        for i in range(minutes, len(grumpy)):
            if grumpy[i]:
                serve += customers[i]
            
            # 從窗口左側移除客戶
            if i - minutes >= 0 and grumpy[i - minutes]:
                serve -= customers[i - minutes]

            max_serve = max(max_serve, serve)

        return max_serve + base_serve
```

## 演算法分析

### 時間複雜度
- **時間**: O(n)，其中 n 是輸入陣列的長度
- **空間**: O(1)，因為我們只使用常數量的額外空間

### 關鍵洞察
1. **基本滿意度**: 計算當老闆總是暴躁時的滿意度
2. **固定窗口**: 使用大小為 `minutes` 的滑動窗口尋找最佳時期
3. **額外滿意度**: 追蹤可以額外滿意的最大客戶數量

## 收穫

1. **固定窗口滑動**: 這道題展示了固定大小滑動窗口技巧，我們維持一個恰好大小為 `minutes` 的窗口並在陣列中滑動。

2. **兩階段方法**: 解決方案使用兩階段方法：首先計算基本滿意度，然後尋找使用技巧的最佳窗口。

3. **基本滿意度計算**: 我們計算當老闆總是暴躁時的基本滿意客戶數量，這給了我們可以保證的最小滿意度。

4. **窗口優化**: 我們滑動一個大小為 `minutes` 的窗口來尋找使用技巧會最大化額外客戶滿意度的時期。

5. **客戶計數邏輯**: 在窗口內，我們只在老闆暴躁時（`grumpy[i] = 1`）計算客戶，因為這些是我們可以通過使用技巧潛在滿意的客戶。

6. **窗口管理**: 隨著窗口滑動，我們添加新客戶並移除舊客戶以維持窗口內的正確計數。

7. **結果計算**: 最終結果是 `max_serve + base_serve`，代表最大可能的滿意度。

8. **單次遍歷解決方案**: 解決方案只需要遍歷陣列一次進行滑動窗口部分，非常高效。

## 遇到的問題
