---
title: "LeetCode 901: Online Stock Span"
summary: "使用單調堆疊解決股票價格跨度問題"
description: "LeetCode 每日挑戰 - 實作計算股票價格跨度的 StockSpanner 類別"
date: 2025-08-10
tags: ["leetcode", "daily", "medium", "algorithm", "stack", "monotonic-stack", "data-structures", "design", "design-patterns", "stock"]

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
**分類:** 設計模式、堆疊、單調堆疊  
**相關主題:** 股票市場、跨度計算

## 解題思路

關鍵洞察是我們需要找到往後看時第一個大於當前價格的價格。這可以使用單調堆疊的方法高效解決，我們維護一個價格遞減順序的堆疊。

## 解法

### 解法一：使用分離的堆疊和價格陣列

```python
class StockSpanner:

    def __init__(self):
        self.stack = []
        self.stock_price = []

    def next(self, price: int) -> int:
        while self.stack and self.stock_price[self.stack[-1]] <= price:
            self.stack.pop(-1)

        self.stack.append(len(self.stock_price))
        self.stock_price.append(price)

        if len(self.stack) > 1:
            return self.stack[-1] - self.stack[-2]
        else:
            return self.stack[-1] + 1
```

**時間複雜度:** O(1) 攤銷每次呼叫  
**空間複雜度:** O(n) 其中 n 是呼叫 next() 的次數

### 解法二：使用價格-跨度對的堆疊（更高效）

```python
class StockSpanner:

    def __init__(self):
        self.stack = []

    def next(self, price: int) -> int:
        curr_span = 1

        while self.stack and self.stack[-1][0] <= price:
            _, span = self.stack.pop()
            curr_span += span
        
        self.stack.append((price, curr_span))

        return curr_span
```

**時間複雜度:** O(1) 攤銷每次呼叫  
**空間複雜度:** O(n) 其中 n 是呼叫 next() 的次數

## 關鍵洞察

1. **單調堆疊模式:** 我們使用堆疊來維護遞減順序的價格
2. **跨度累積:** 當我們從堆疊中彈出較小的價格時，我們累積它們的跨度
3. **高效查找:** 堆疊為我們提供 O(1) 存取前一個較大價格的能力

## 收穫

- 單調堆疊方法非常適合涉及尋找下一個較大/較小元素的問題
- 解法二更優雅且高效，因為它將價格和跨度資訊一起儲存
- 攤銷時間複雜度是 O(1)，因為每個元素只能被推入和彈出一次

## 遇到的問題

- 最初難以理解如何在不重新計算每個元素的情況下高效計算跨度
- 必須思考連續跨度之間的關係以及如何累積它們
- 在逐步畫出過程後，堆疊方法變得清晰