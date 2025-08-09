---
title: "LeetCode 1343: Number of Sub-arrays of Size K and Average Greater than or Equal to Threshold"
summary: "LeetCode 解題紀錄 - 固定大小滑動窗口與總和計算"
description: "LeetCode Daily - 使用滑動窗口計算大小為K且平均值>=閾值的子陣列數量"
date: 2025-08-02
tags: ["LeetCode", "daily", "medium", "sliding window", "array", "prefix sum", "average calculation"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試： 2025-08-02
- 總花費時間：00:00.00

## 問題描述

給定一個整數陣列 `arr` 和兩個整數 `k` 和 `threshold`，返回大小為 `k` 且平均值大於或等於 `threshold` 的子陣列數量。子陣列的平均值是所有元素總和除以子陣列中的元素數量。

## 解題思路

這是一個經典的固定大小滑動窗口問題。我們需要維持一個大小為 `k` 的窗口並計算窗口內元素的總和。與其直接計算平均值，我們可以通過預先計算所需的最小總和 (`k * threshold`) 並將窗口總和與此值進行比較來優化。這避免了浮點運算並使比較更高效。

## 解法

### 固定大小滑動窗口與總和優化
```python
class Solution:
    def numOfSubarrays(self, arr: List[int], k: int, threshold: int) -> int:
        min_sum = k * threshold  # 預先計算所需的最小總和
        sum_now = 0
        res = 0

        for i in range(len(arr)):
            sum_now += arr[i]
            
            # 移除落在窗口外的元素
            if i - k >= 0:
                sum_now -= arr[i - k]

            # 檢查當前窗口是否滿足閾值要求
            if i - k + 1 >= 0 and sum_now >= min_sum:
                res += 1

        return res
```

## 演算法分析

### 時間複雜度
- **時間**: O(n)，其中 n 是輸入陣列的長度
- **空間**: O(1)，因為我們只使用常數量的額外空間

### 關鍵優化
1. **預先計算閾值**: 與其每次都計算平均值，我們預先計算 `min_sum = k * threshold`
2. **整數比較**: 使用總和比較而不是平均值計算，避免浮點運算
3. **單次遍歷**: 我們只需要遍歷陣列一次

## 收穫

1. **固定大小滑動窗口**: 這道題展示了經典的固定大小滑動窗口技巧，我們維持一個恰好大小為 `k` 的窗口並在陣列中滑動。

2. **總和 vs 平均值優化**: 與其為每個窗口計算平均值（需要除法），我們預先計算所需的最小總和 (`k * threshold`) 並直接比較總和。這更高效並避免浮點精度問題。

3. **窗口管理**: 關鍵洞察是通過添加新元素和移除舊元素來維持正確的窗口大小，當窗口超過大小 `k` 時。

4. **邊界條件**: 條件 `i - k + 1 >= 0` 確保我們只有在有完整的大小為 `k` 的窗口時才開始計算結果。

5. **整數運算**: 使用整數運算進行比較更高效，避免平均值計算可能發生的浮點精度錯誤。

6. **單次遍歷**: 解決方案只需要遍歷陣列一次，對於大型輸入非常高效。

7. **記憶體效率**: O(1) 空間複雜度使這個解決方案非常記憶體高效，因為我們只需要幾個變數來追蹤當前總和和結果計數。

8. **邊界情況處理**: 解決方案自然地處理陣列長度小於 `k` 的邊界情況，通過永遠找不到有效窗口。

## 遇到的問題
