---
title: "LeetCode 3512: Minimum Operations to Make Array Sum Divisible by K"
summary: "LeetCode Problem Solving"
description: "LeetCode Bi-Weekly Contest 154"
date: 2025-04-12
series: ["LeetCode Bi-Weekly Contest 154"]
series_order: 1
tags: ["LeetCode", "blog", "bi-weekly", "easy"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2025-04-12
- Total time: 01:00.00

## Intuition

The problem need to count the minimum operations to make the array sum can de divided by K, thus we just need to find how many count we should do, means to get the reminder of nums and k

## Approach
```python
class Solution:
    def minOperations(self, nums: List[int], k: int) -> int:
        return sum(nums)%k
```

## Findings
NA

## Encountered Problems 
NA