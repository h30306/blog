---
title: "LeetCode 84: Largest Rectangle in Histogram"
summary: "Solving the Largest Rectangle in Histogram problem using monotonic stack approach"
description: "LeetCode Daily Challenge - Find the largest rectangle area that can be formed from a histogram using efficient stack-based algorithm"
date: 2025-08-10
tags: ["LeetCode", "daily", "hard", "stack", "monotonic-stack", "array", "histogram", "geometry", "algorithm", "dynamic-programming"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

**Difficulty:** Hard  
**First Attempt:** 2025-08-10  
**Total Time:** 00:00.00  
**Category:** Stack, Monotonic Stack, Array, Geometry  
**Related Topics:** Histogram, Rectangle Area, Dynamic Programming

## Intuition

The key insight is that for each bar in the histogram, we need to find the largest rectangle that can be formed using that bar as the height. The width of this rectangle is determined by finding the leftmost and rightmost positions where bars are at least as tall as the current bar. This can be efficiently solved using a monotonic stack approach.

## Approach

### Approach 1: Using Stack with Index Tracking

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

**Time Complexity:** O(n) where n is the length of heights array  
**Space Complexity:** O(n) for the stack

### Approach 2: Using Stack with Left Boundary Calculation

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

**Time Complexity:** O(n) where n is the length of heights array  
**Space Complexity:** O(n) for the stack

## Key Insights

1. **Monotonic Stack Pattern:** We use a stack to maintain bars in increasing height order
2. **Boundary Detection:** When we encounter a shorter bar, we can calculate the area of all taller bars that end at the current position
3. **Width Calculation:** The width of a rectangle is determined by the distance between the current position and the previous smaller bar
4. **Sentinel Value:** Adding 0 at the end ensures we process all remaining bars in the stack

## Findings

- The monotonic stack approach is perfect for problems involving finding the next smaller element
- Both approaches have the same time complexity, but Approach 2 is more intuitive in calculating the left boundary
- The key is understanding that each bar can only form a rectangle with bars that are at least as tall
- The stack naturally maintains the increasing order, making it easy to find the left boundary

## Encountered Problems

- Initially struggled with understanding how to calculate the width of rectangles correctly
- Had to think about the relationship between bar heights and the boundaries of rectangles
- The stack approach became clear after visualizing how each bar contributes to the maximum area
- Understanding when to pop elements from the stack was crucial for correct implementation 