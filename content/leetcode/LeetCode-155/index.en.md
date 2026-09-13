---
title: "LeetCode 155: Min Stack"
summary: "Implementing a stack with O(1) minimum retrieval using tuple-based approach"
description: "LeetCode Daily Challenge - Min Stack implementation with constant time operations"
date: 2025-08-10
tags: ["leetcode", "daily", "medium", "stack", "constant-time", "data-structures", "design", "tuple"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: Medium
First Attempt: 2025-08-10
- Total time: 00:00.00

## Intuition

This is a stack problem where we need to track the minimum element at any given time. To achieve O(1) time complexity for the `getMin()` operation, we can store each element along with the current minimum value in a tuple. This way, every element in the stack knows what the minimum was when it was pushed.

## Approach

The solution uses a tuple-based approach where each stack element contains:
1. **Value**: The actual value being pushed
2. **Current Minimum**: The minimum value in the stack at the time of pushing

This design allows us to:
- **Push**: O(1) - Calculate new minimum and store with value
- **Pop**: O(1) - Remove top element
- **Top**: O(1) - Return top value
- **GetMin**: O(1) - Return current minimum from top element

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

**Time Complexity**: O(1) for all operations
**Space Complexity**: O(n) where n is the number of elements pushed

## Findings

- **Tuple-based design**: Using tuples to store value and minimum together is elegant and efficient
- **Constant time operations**: All stack operations maintain O(1) time complexity
- **Space trade-off**: We use extra space to store minimum values, but gain constant time access
- **Design pattern**: This demonstrates how to design data structures with specific performance guarantees

## Encountered Problems 
