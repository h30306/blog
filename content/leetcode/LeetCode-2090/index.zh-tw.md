---
title: "LeetCode 2090: K Radius Subarray Averages"
summary: "LeetCode 解題紀錄"
description: "LeetCode Daily"
date: 2025-08-02
tags: ["LeetCode", "daily", "medium", "Sliding Window"]

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

## 解題思路

這是一個固定大小的滑動窗口問題。解決這個問題不需要特殊的技巧，只需要計算窗口大小並從左到右滑動。如果窗口不夠大，我們就不更新結果陣列中的值。我們可以將結果陣列初始化為全部 -1。

## 解法
```python
class Solution:
    def getAverages(self, nums: List[int], k: int) -> List[int]:
        
        window_size = (k * 2) + 1
        n = len(nums)
        res = [-1] * n

        if n < window_size:
            return res

        window_sum = 0
        for i in range(n):
            window_sum += nums[i]

            if i - window_size >= 0:
                window_sum -= nums[i - window_size]
            
            if i >= window_size - 1:
                res[i - k] = window_sum // window_size

        return res
```

## 收穫

1. **滑動窗口技巧**: 這道題是滑動窗口技巧的經典應用，我們維護一個固定大小的窗口並計算窗口內元素的平均值。

2. **邊界情況處理**: 關鍵洞察是處理陣列長度小於所需窗口大小 (2k + 1) 的情況。在這種情況下，我們返回一個填充了 -1 的陣列。

3. **窗口大小計算**: 窗口大小計算為 `(k * 2) + 1`，因為我們需要當前元素兩側各 k 個元素，再加上元素本身。

4. **結果陣列定位**: 當我們有一個有效的窗口時，我們將平均值放在結果陣列的位置 `i - k`，這對應於當前窗口的中心。

5. **時間複雜度**: O(n)，其中 n 是輸入陣列的長度，因為我們只需要遍歷陣列一次。

6. **空間複雜度**: O(1) 額外空間（不包括結果陣列），因為我們只使用常數量的額外變數。

## 遇到的問題
