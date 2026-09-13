---
title: "LeetCode 853: Car Fleet"
summary: "Solving the Car Fleet problem using stack-based approach"
description: "LeetCode Daily Challenge - Car Fleet problem solution with detailed explanation"
date: 2025-08-10
tags: ["leetcode", "daily", "medium", "array", "stack", "greedy", "simulation", "sorting"]

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

Every car has its arrival time to the target. We can sort cars by their position and iterate from the closest to the farthest from the target. If a car's arrival time is smaller than or equal to the last car in our stack, it means the current car will catch up and form a fleet with the car ahead of it.

## Approach

The solution uses a stack-based approach with the following steps:

1. **Calculate arrival times**: For each car, calculate the time it takes to reach the target using `(target - position) / speed`
2. **Sort by position**: Sort cars by their position in descending order (closest to target first)
3. **Stack processing**: Use a stack to track cars that form fleets
4. **Fleet formation**: If a car can catch up to the car ahead (arrival time ≤ previous car), it joins the fleet

```python
class Solution:
    def carFleet(self, target: int, position: List[int], speed: List[int]) -> int:
        position_rate = [(position[i], (target - position[i]) / speed[i]) for i in range(len(position))]
        position_rate.sort(key=lambda x: (x[0], -x[1]))
        stack = []

        for position, time_to_end in position_rate:
            while stack and stack[-1][1] <= time_to_end: # means will be catch up
                stack.pop()
            
            stack.append((position, time_to_end))

        return len(stack)
```

**Time Complexity**: O(n log n) due to sorting
**Space Complexity**: O(n) for the stack

## Findings

- **Stack-based approach**: Using a stack to track fleets is efficient and intuitive
- **Sorting by position**: Sorting cars by their distance from target simplifies the fleet formation logic
- **Catch-up condition**: The key insight is that if a car's arrival time ≤ previous car's arrival time, they form a fleet
- **Greedy nature**: This problem demonstrates a greedy approach where we process cars in order and make optimal decisions at each step

## Encountered Problems 
