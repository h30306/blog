---
title: "LeetCode 2799: Count Complete Subarrays in an Array"
summary: "LeetCode Problem Solving"
description: "LeetCode Daily"
date: 2025-04-21
tags: ["LeetCode", "daily", "medium", "sliding window"]

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

Second Attempt: 2025-07-01
- Total time: 10:00.00

## Intuition

The length of this problem is quite small,  
so we can use brute-force to iterate through two arrays and count the subarrays.  
However, there is an optimized method:  
while iterating from the start index to the end index,  
once the current subarray already satisfies the complete condition,  
we can immediately stop iterating further and directly count the number of satisfied subarrays from the current end index to the end of the array.  
This optimization helps to avoid TLE (Time Limit Exceeded) issues.

And there's another method using sliding window. We can keep track of the occurrence of each element in a hashmap, and when the distinct element count matches the distinct count in nums, it means this subarray fulfills the condition of being complete. After we find the minimum complete subarray, all subarrays from the right index to the end of nums are also complete arrays. Thus, we can count the number of complete subarrays and then iterate through the array.

## Approach

### Method 1: Optimized Brute Force
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

### Method 2: Sliding Window
```python
class Solution:
    def countCompleteSubarrays(self, nums):
        distinct_elements = set(nums)
        total_distinct = len(distinct_elements)
        count = 0
        n = len(nums)
        
        # Use sliding window with two pointers
        left = 0
        element_count = {}
        
        for right in range(n):
            # Add current element to count
            element_count[nums[right]] = element_count.get(nums[right], 0) + 1
            
            # When we have all distinct elements, try to minimize window
            while len(element_count) == total_distinct:
                # All subarrays from left to right (inclusive) to end are complete
                count += (n - right)
                
                # Remove leftmost element
                element_count[nums[left]] -= 1
                if element_count[nums[left]] == 0:
                    del element_count[nums[left]]
                left += 1
                
        return count
```

## Findings

NA

## Encountered Problems 

NA