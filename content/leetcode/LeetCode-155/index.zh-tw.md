---
title: "LeetCode 155: Min Stack"
summary: "使用元組方法實現具有 O(1) 最小值檢索的堆疊"
description: "LeetCode 每日挑戰 - 最小堆疊的實現與常數時間操作"
date: 2025-08-10
tags: ["leetcode", "daily", "medium", "stack", "constant-time", "data-structures", "design", "tuple"]

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

這是一個堆疊問題，我們需要在任何時候都能追蹤最小元素。為了實現 `getMin()` 操作的 O(1) 時間複雜度，我們可以在元組中儲存每個元素以及當前的最大值。這樣，堆疊中的每個元素都知道它被推入時的最小值是什麼。

## 解法

這個解決方案使用元組方法，其中每個堆疊元素包含：
1. **數值**：實際被推入的值
2. **當前最小值**：推入時堆疊中的最小值

這個設計允許我們：
- **推入 (Push)**：O(1) - 計算新的最小值並與值一起儲存
- **彈出 (Pop)**：O(1) - 移除頂部元素
- **頂部 (Top)**：O(1) - 返回頂部值
- **獲取最小值 (GetMin)**：O(1) - 從頂部元素返回當前最小值

```python
class MinStack:

    def __init__(self):
        self.stack: list[tuple] = []

    def push(self, val: int) -> None:
        min_latest = self.stack[-1][1] if self.stack else float("inf")
        min_latest = min(val, min_latest)
        self.stack.append((val, min_latest))

    def pop(self) -> None:
        val, _ = self.stack.pop()
        return val

    def top(self) -> int:
        val, _ = self.stack[-1] if self.stack else (None, None)
        return val

    def getMin(self) -> int:
        _, min_num = self.stack[-1] if self.stack else (None, None)
        return min_num
```

**時間複雜度**：所有操作都是 O(1)
**空間複雜度**：O(n)，其中 n 是被推入的元素數量

## 收穫

- **元組設計**：使用元組來儲存值和最小值既優雅又高效
- **常數時間操作**：所有堆疊操作都保持 O(1) 時間複雜度
- **空間權衡**：我們使用額外空間來儲存最小值，但獲得了常數時間的存取
- **設計模式**：這展示了如何設計具有特定性能保證的資料結構

## 遇到的問題

- **理解需求**：最初不清楚如何實現 O(1) 的最小值檢索
- **元組結構**：決定使用元組來儲存值和最小值是關鍵洞察
- **邊界情況**：在 `top()` 和 `getMin()` 方法中處理空堆疊的情況
- **pop 的返回值**：`pop()` 方法應該返回被彈出的值，而不只是移除它