---
title: "LeetCode 1534: Count Good Triplets"
summary: "LeetCode Problem Solving"
description: "LeetCode Daily"
date: 2025-04-14
tags: ["LeetCode", "blog", "daily", "easy"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2025-04-14
- Total time: 2:00.00

## Intuition

It's natural to consider using brute force to solve this problem.  
Given that the range of `nums` is relatively small, an `O(n^3)` solution is acceptable and should not result in a TLE.

## Approach
```python
class Solution:
    def countGoodTriplets(self, arr: List[int], a: int, b: int, c: int) -> int:
        res = 0
        n = len(arr)
        for i in range(n):
            for j in range(i+1, n):
                for k in range(j+1, n):
                    if abs(arr[i]-arr[j]) <= a and abs(arr[j]-arr[k]) <= b and abs(arr[i]-arr[k]) <= c:
                        res +=1

        return res
```

## Findings
NA

## Encountered Problems 
NA