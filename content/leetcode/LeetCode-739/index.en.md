---
title: "LeetCode 739: Daily Temperatures"
summary: "Solving the Daily Temperatures problem using monotonic stack approach"
description: "LeetCode Daily Challenge - Find the number of days to wait for a warmer temperature using efficient stack-based algorithm"
date: 2025-08-10
tags: ["daily", "medium", "array", "stack", "monotonic-stack", "data-structures", "temperature", "waiting-time"]
categories: ["leetcode"]
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
**Category:** Stack, Monotonic Stack, Array  
**Related Topics:** Temperature Monitoring, Waiting Time Calculation, Stack Operations

## Intuition

The key insight is that for each temperature, we need to find the next warmer temperature. This can be efficiently solved using a monotonic stack approach, where we maintain a stack of temperatures in decreasing order. When we encounter a warmer temperature, we can update the waiting days for all previous colder temperatures.

## Approach

### Using Monotonic Stack for Next Warmer Temperature

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

**Time Complexity:** O(n) where n is the length of temperatures array  
**Space Complexity:** O(n) for the stack in worst case

## Key Insights

1. **Monotonic Stack Pattern:** We use a stack to maintain temperatures in decreasing order
2. **Next Warmer Temperature:** When we find a warmer temperature, we can calculate waiting days for all colder temperatures
3. **Index Tracking:** We store indices in the stack to calculate the distance between temperatures
4. **Efficient Updates:** Each temperature can only be pushed and popped once, leading to O(n) time complexity

## Findings

- The monotonic stack approach is perfect for problems involving finding the next greater/smaller element
- This problem demonstrates how to use stack indices to calculate distances efficiently
- The time complexity is optimal at O(n) since each element can only be pushed and popped once
- The stack naturally maintains the decreasing order, making it easy to find the next warmer temperature

## Encountered Problems
