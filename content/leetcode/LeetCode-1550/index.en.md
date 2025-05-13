---
title: "LeetCode 1550: Three Consecutive Odds"
summary: "LeetCode Problem Solving"
description: "LeetCode Daily"
date: 2025-05-11
tags: ["LeetCode", "array", "easy"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2025-05-11
- Total time: 05:00.00

## Intuition

Set a counter to track the number of consecutive odd numbers.  
If the count reaches 3, return the result early.

## Approach

```python
class Solution:
    def threeConsecutiveOdds(self, arr: List[int]) -> bool:
        
        count = 0
        for num in arr:
            if num%2:
                count+=1
            else:
                count = 0

            if count == 3:
                return True

        return False
```

## Findings

## Encountered Problems 