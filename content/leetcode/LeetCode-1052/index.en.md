---
title: "LeetCode 1052: Grumpy Bookstore Owner"
summary: "LeetCode Problem Solving - Fixed Window with Customer Satisfaction Optimization"
description: "LeetCode Daily - Maximize customer satisfaction using sliding window technique"
date: 2025-08-03
tags: ["LeetCode", "daily", "medium", "sliding window", "array", "optimization", "fixed window"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-08-03
- Total time: 00:00.00

## Intuition

This is a fixed window problem. Given the minutes that the bookstore owner can control their grumpiness, we can first calculate the base number of satisfied customers when the owner is always grumpy. Then we slide a window of size `minutes` from left to right, calculating how many additional customers can be satisfied if the owner uses their technique during that window period.

## Approach

### Fixed Window with Customer Satisfaction Optimization
```python
class Solution:
    def maxSatisfied(self, customers: List[int], grumpy: List[int], minutes: int) -> int:
        
        # Calculate base satisfaction when owner is always grumpy
        base_serve = 0
        for i in range(len(grumpy)):
            base_serve += (not grumpy[i]) * customers[i]

        # Calculate initial window satisfaction
        serve = 0
        for i in range(minutes):
            if grumpy[i]:
                serve += customers[i]

        max_serve = serve
        
        # Slide window and find maximum additional satisfaction
        for i in range(minutes, len(grumpy)):
            if grumpy[i]:
                serve += customers[i]
            
            # Remove customer from left side of window
            if i - minutes >= 0 and grumpy[i - minutes]:
                serve -= customers[i - minutes]

            max_serve = max(max_serve, serve)

        return max_serve + base_serve
```

## Algorithm Analysis

### Time Complexity
- **Time**: O(n) where n is the length of the input arrays
- **Space**: O(1) since we only use a constant amount of extra space

### Key Insights
1. **Base Satisfaction**: Calculate satisfaction when owner is always grumpy
2. **Fixed Window**: Use sliding window of size `minutes` to find optimal period
3. **Additional Satisfaction**: Track maximum additional customers that can be satisfied

## Findings

1. **Fixed Window Sliding**: This problem demonstrates the fixed-size sliding window technique, where we maintain a window of exactly `minutes` size and slide it through the array.

2. **Two-Phase Approach**: The solution uses a two-phase approach: first calculate base satisfaction, then find the optimal window for using the technique.

3. **Base Satisfaction Calculation**: We calculate the base number of satisfied customers when the owner is always grumpy, which gives us the minimum satisfaction we can guarantee.

4. **Window Optimization**: We slide a window of size `minutes` to find the period where using the technique would maximize additional customer satisfaction.

5. **Customer Counting Logic**: Within the window, we only count customers when the owner is grumpy (`grumpy[i] = 1`), since these are the customers we can potentially satisfy by using the technique.

6. **Window Management**: As the window slides, we add new customers and remove old ones to maintain the correct count within the window.

7. **Result Calculation**: The final result is `max_serve + base_serve`, representing the maximum possible satisfaction.

8. **Single Pass Solution**: The solution requires only one pass through the array for the sliding window part, making it very efficient.

## Encountered Problems 