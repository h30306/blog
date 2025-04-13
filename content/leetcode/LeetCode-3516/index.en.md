---
title: "LeetCode 3516: Find Closest Person"
summary: "LeetCode Problem Solving"
description: "LeetCode Weekly Contest 445"
date: 2025-04-13
series: ["LeetCode Weekly Contest 445"]
series_order: 1
tags: ["LeetCode", "blog", "weekly", "easy"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2025-04-13
- Total time: 02:00.00

## Intuition

Just use brute-force to calculate the distance from `x` to `z` and from `y` to `z`, then compare the distances and return the result.

## Approach
```python
class Solution:
    def findClosest(self, x: int, y: int, z: int) -> int:
        distance_x_z = abs(z-x)
        distance_y_z = abs(z-y)
        
        if distance_x_z>distance_y_z:
            return 2
        elif distance_x_z<distance_y_z:
            return 1
        return 0
```

## Findings
NA

## Encountered Problems 
NA