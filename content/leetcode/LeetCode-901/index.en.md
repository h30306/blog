---
title: "LeetCode 901: Online Stock Span"
summary: "Solving the Online Stock Span problem using monotonic stack approach"
description: "LeetCode Daily Challenge - Implement a StockSpanner class that calculates the span of stock prices"
date: 2025-08-10
tags: ["LeetCode", "daily", "medium", "stack", "monotonic-stack", "design", "data-structure", "algorithm"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

**Difficulty:** Medium  
**First Attempt:** 2025-08-10  
**Total Time:** 00:00.00  
**Category:** Design, Stack, Monotonic Stack  
**Related Topics:** Stock Market, Span Calculation

## Intuition

The key insight is that we need to find the first price that is greater than the current price when looking backward. This can be efficiently solved using a monotonic stack approach, where we maintain a stack of prices in decreasing order.

## Approach

### Approach 1: Using Separate Stack and Price Arrays

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

**Time Complexity:** O(1) amortized per call  
**Space Complexity:** O(n) where n is the number of calls to next()

### Approach 2: Using Stack with Price-Span Pairs (More Efficient)

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

**Time Complexity:** O(1) amortized per call  
**Space Complexity:** O(n) where n is the number of calls to next()

## Key Insights

1. **Monotonic Stack Pattern:** We use a stack to maintain prices in decreasing order
2. **Span Accumulation:** When we pop smaller prices from the stack, we accumulate their spans
3. **Efficient Lookup:** The stack gives us O(1) access to the previous greater price

## Findings

- The monotonic stack approach is perfect for problems involving finding the next greater/smaller element
- Approach 2 is more elegant and efficient as it stores both price and span information together
- The amortized time complexity is O(1) because each element can only be pushed and popped once

## Encountered Problems

- Initially struggled with understanding how to efficiently calculate spans without recalculating for each element
- Had to think about the relationship between consecutive spans and how to accumulate them
- The stack approach became clear after drawing out the process step by step 