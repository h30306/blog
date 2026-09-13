---
title: "LeetCode 84: Largest Rectangle in Histogram"
summary: "使用單調堆疊解決直方圖中最大矩形面積問題"
description: "LeetCode 每日挑戰 - 使用高效的堆疊演算法找出直方圖中能形成的最大矩形面積"
date: 2025-08-10
tags: ["daily", "hard", "array", "stack", "monotonic-stack", "dynamic-programming", "geometry", "histogram"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

**難易度:** Hard  
**第一次嘗試:** 2025-08-10  
**總花費時間:** 00:00.00  
**分類:** 堆疊、單調堆疊、陣列、幾何  
**相關主題:** 直方圖、矩形面積、動態規劃

## 解題思路

關鍵洞察是對於直方圖中的每個長條，我們需要找出使用該長條作為高度能形成的最大矩形。這個矩形的寬度由找到最左邊和最右邊的位置決定，這些位置的長條至少要和當前長條一樣高。這可以使用單調堆疊的方法高效解決。

## 解法

### 解法一：使用堆疊配合索引追蹤

```python
class Solution:
    def largestRectangleArea(self, heights: List[int]) -> int:
        if len(heights) == 1:
            return heights[0]

        heights.append(0)
        stack = []
        n = len(heights)
        max_area = 0
        for i in range(n):
            while stack and heights[stack[-1]] > heights[i]:
                idx = stack.pop(-1)
                width = i - stack[-1] - 1 if stack else i
                height = heights[idx]
                max_area = max(max_area, height * width)

            stack.append(i)
    
        return max_area
```

**時間複雜度:** O(n) 其中 n 是 heights 陣列的長度  
**空間複雜度:** O(n) 用於堆疊

### 解法二：使用堆疊配合左邊界計算

```python
class Solution:
    def largestRectangleArea(self, heights: List[int]) -> int:
        heights.append(0)
        max_area = 0
        stack = []

        for i in range(len(heights)):
            while stack and heights[stack[-1]] > heights[i]:
                top = stack.pop()
                height = heights[top]
                left = stack[-1] + 1 if stack else 0
                width = i - left
                max_area = max(max_area, height * width)
            stack.append(i)

        return max_area
```

**時間複雜度:** O(n) 其中 n 是 heights 陣列的長度  
**空間複雜度:** O(n) 用於堆疊

## 關鍵洞察

1. **單調堆疊模式:** 我們使用堆疊來維護遞增高度順序的長條
2. **邊界檢測:** 當我們遇到較短的長條時，我們可以計算所有在當前位置結束的較高長條的面積
3. **寬度計算:** 矩形的寬度由當前位置和前一個較小長條之間的距離決定
4. **哨兵值:** 在末尾添加 0 確保我們處理堆疊中所有剩餘的長條

## 收穫

- 單調堆疊方法非常適合涉及尋找下一個較小元素的問題
- 兩種方法具有相同的時間複雜度，但解法二在計算左邊界時更直觀
- 關鍵是理解每個長條只能與至少同樣高的長條形成矩形
- 堆疊自然地維持遞增順序，使得找到左邊界變得容易

## 遇到的問題

- 最初難以理解如何正確計算矩形的寬度
- 必須思考長條高度與矩形邊界之間的關係
- 在視覺化每個長條如何貢獻最大面積後，堆疊方法變得清晰
- 理解何時從堆疊中彈出元素對於正確實作至關重要