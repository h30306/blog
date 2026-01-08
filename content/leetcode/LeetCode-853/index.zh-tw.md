---
title: "LeetCode 853: Car Fleet"
summary: "使用堆疊方法解決車隊問題"
description: "LeetCode 每日挑戰 - 車隊問題的詳細解題思路與實作"
date: 2025-08-10
tags: ["LeetCode", "daily", "medium", "stack", "sorting", "simulation", "greedy", "array", "堆疊", "排序", "模擬", "貪心", "陣列"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: Medium
第一次嘗試： 2025-08-10
- 總花費時間：00:00.00

## 解題思路

每輛車都有到達目標位置的時間。我們可以按照車輛位置排序，從距離目標最近的車開始遍歷到最遠的車。如果一輛車的到達時間小於或等於堆疊中最後一輛車的到達時間，就表示這輛車會追上並與前面的車形成車隊。

## 解法

這個解決方案使用堆疊方法，包含以下步驟：

1. **計算到達時間**：對於每輛車，使用 `(target - position) / speed` 計算到達目標所需的時間
2. **按位置排序**：按照車輛位置降序排列（距離目標最近的車優先）
3. **堆疊處理**：使用堆疊來追蹤形成車隊的車輛
4. **車隊形成**：如果一輛車能追上前面的車（到達時間 ≤ 前車到達時間），它就加入車隊

```python
class Solution:
    def carFleet(self, target: int, position: List[int], speed: List[int]) -> int:
        position_rate = [(position[i], (target - position[i]) / speed[i]) for i in range(len(position))]
        position_rate.sort(key=lambda x: (x[0], -x[1]))
        stack = []

        for position, time_to_end in position_rate:
            while stack and stack[-1][1] <= time_to_end: # 表示會追上
                stack.pop()
            
            stack.append((position, time_to_end))

        return len(stack)
```

**時間複雜度**：O(n log n)，主要來自排序
**空間複雜度**：O(n)，用於堆疊儲存

## 收穫

- **堆疊方法**：使用堆疊來追蹤車隊既有效率又直觀
- **位置排序**：按照距離目標的遠近排序車輛，簡化了車隊形成的邏輯
- **追趕條件**：關鍵洞察是如果一輛車的到達時間 ≤ 前車到達時間，它們就形成車隊
- **貪心特性**：這個問題展示了貪心方法，我們按順序處理車輛並在每一步做出最佳決策

## 遇到的問題
