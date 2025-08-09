---
title: "LeetCode 904: Fruit Into Baskets"
summary: "LeetCode 解題紀錄 - 可變大小滑動窗口與雜湊表"
description: "LeetCode Daily - 使用滑動窗口尋找最多兩種水果的最大數量"
date: 2025-08-05
tags: ["LeetCode", "daily", "medium", "sliding window", "hash map", "two pointers", "variable window"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試： 2025-08-05
- 總花費時間：00:00.00

## 解題思路

這是一個帶有雜湊表約束的滑動窗口問題。問題說明我們在籃子中只能有兩種水果，我們的目標是在這個條件下找到我們可以收集的最大水果數量。這是一個可變大小的滑動窗口問題，當水果種類超過2種時，我們必須縮小窗口。我們維持一個雜湊表來追蹤每種水果的數量，當我們有超過兩種水果時，從左側縮小窗口。

## 解法

### 可變大小滑動窗口與雜湊表
```python
class Solution:
    def totalFruit(self, fruits: List[int]) -> int:
        pick = defaultdict(int)
        max_tree = 0

        left = 0
        for right in range(len(fruits)):
            # 將當前水果添加到籃子
            pick[fruits[right]] += 1
    
            # 如果我們有超過2種水果，則縮小窗口
            while len(pick) > 2:
                pick[fruits[left]] -= 1
                if not pick[fruits[left]]:
                    del pick[fruits[left]]
                left += 1
            
            # 更新收集的最大水果數量
            max_tree = max(max_tree, right - left + 1)

        return max_tree
```

## 演算法分析

### 時間複雜度
- **時間**: O(n)，其中 n 是輸入陣列的長度
- **空間**: O(1)，因為我們只使用最多3個條目的雜湊表

### 關鍵洞察
1. **可變窗口大小**: 窗口大小根據水果種類數量變化
2. **雜湊表追蹤**: 使用雜湊表追蹤每種水果的數量
3. **窗口縮小**: 當水果種類超過2種時縮小窗口

## 收穫

1. **可變大小滑動窗口**: 這道題展示了可變大小滑動窗口技巧，其中窗口大小根據約束條件（水果種類數量）變化。

2. **雜湊表約束管理**: 我們使用雜湊表來追蹤每種水果的數量，使我們能夠高效地確定何時有超過兩種水果。

3. **窗口縮小策略**: 當水果種類超過2種時，我們通過從左側一個一個移除水果來縮小窗口，直到我們回到最多2種水果。

4. **高效水果移除**: 我們遞減被移除水果的計數，當計數達到零時完全刪除條目，保持雜湊表清潔。

5. **最大值追蹤**: 每當我們有一個有效窗口（最多2種水果）時，我們持續更新收集的最大水果數量。

6. **單次遍歷解決方案**: 解決方案只需要遍歷陣列一次，對於大型輸入非常高效。

7. **記憶體效率**: O(1) 空間複雜度，因為雜湊表永遠不會有超過3個條目（當計數達到零時我們刪除條目）。

8. **基於約束的優化**: 關鍵洞察是我們可以連續收集水果，直到遇到第三種類型，然後我們必須開始從開頭移除水果。

## 遇到的問題
