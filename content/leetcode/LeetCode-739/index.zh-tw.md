---
title: "LeetCode 739: Daily Temperatures"
summary: "使用單調堆疊解決每日溫度問題"
description: "LeetCode 每日挑戰 - 使用高效的堆疊演算法找出等待更暖溫度的天數"
date: 2025-08-10
tags: ["leetcode", "daily", "medium", "algorithm", "array", "stack", "monotonic-stack", "data-structures", "temperature", "waiting-time"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

**難易度:** Medium  
**第一次嘗試:** 2025-08-10  
**總花費時間:** 00:00.00  
**分類:** 堆疊、單調堆疊、陣列  
**相關主題:** 溫度監控、等待時間計算、堆疊操作

## 解題思路

關鍵洞察是對於每個溫度，我們需要找到下一個更暖的溫度。這可以使用單調堆疊的方法高效解決，我們維護一個溫度遞減順序的堆疊。當我們遇到更暖的溫度時，我們可以更新所有之前較冷溫度的等待天數。

## 解法

### 使用單調堆疊尋找下一個更暖溫度

```python
class Solution:
    def dailyTemperatures(self, temperatures: List[int]) -> List[int]:
        n = len(temperatures)
        res = [0] * n
        stack = []

        for i in range(n):
            while stack and temperatures[stack[-1]] < temperatures[i]:
                idx = stack.pop()
                res[idx] = i - idx
            
            stack.append(i)

        return res
```

**時間複雜度:** O(n) 其中 n 是 temperatures 陣列的長度  
**空間複雜度:** O(n) 用於堆疊的最壞情況

## 關鍵洞察

1. **單調堆疊模式:** 我們使用堆疊來維護遞減順序的溫度
2. **下一個更暖溫度:** 當我們找到更暖的溫度時，我們可以計算所有較冷溫度的等待天數
3. **索引追蹤:** 我們在堆疊中儲存索引以計算溫度之間的距離
4. **高效更新:** 每個溫度只能被推入和彈出一次，導致 O(n) 時間複雜度

## 收穫

- 單調堆疊方法非常適合涉及尋找下一個較大/較小元素的問題
- 這個問題展示了如何使用堆疊索引來高效計算距離
- 時間複雜度在 O(n) 是最佳的，因為每個元素只能被推入和彈出一次
- 堆疊自然地維持遞減順序，使得找到下一個更暖溫度變得容易

## 遇到的問題
