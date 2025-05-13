---
title: "LeetCode 2799: Count Complete Subarrays in an Array"
summary: "LeetCode Problem Solving"
description: "LeetCode Daily"
date: 2025-04-21
tags: ["LeetCode", "daily", "medium"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-04-21
- Total time: 15:00.00

## Intuition

The length of this problem is quite small,  
so we can use brute-force to iterate through two arrays and count the subarrays.  
However, there is an optimized method:  
while iterating from the start index to the end index,  
once the current subarray already satisfies the complete condition,  
we can immediately stop iterating further and directly count the number of satisfied subarrays from the current end index to the end of the array.  
This optimization helps to avoid TLE (Time Limit Exceeded) issues.

## Approach

```python
class Solution:
    def countCompleteSubarrays(self, nums):
        distinct_elements = set(nums)
        total_distinct = len(distinct_elements)
        count = 0
        n = len(nums)
        
        for i in range(n):
            current_set = set()
            for j in range(i, n):
                current_set.add(nums[j])
                if len(current_set) == total_distinct:
                    count += (n - j)
                    break
        return count
```

## Findings

NA

## Encountered Problems 

NA