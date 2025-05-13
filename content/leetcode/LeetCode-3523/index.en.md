---
title: "LeetCode 3523: Make Array Non-decreasing"
summary: "LeetCode Problem Solving"
description: "LeetCode Weekly"
date: 2025-04-20
series: ["LeetCode Weekly Contest 446"]
series_order: 2
tags: ["LeetCode", "weekly", "medium"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-04-20
- Total time: 22:00.00

## Intuition

According to the problem description, we need to make the array **non-decreasing**.  
That means from left to right, if we encounter any number smaller than the largest number seen so far (prefix maximum), it must be "dropped" or corrected.  
Thus, we can simply iterate through the array and count how many elements need to be dropped.  
The size of the final array will be the original size minus the number of drops.

## Approach

```python
class Solution:
    def maximumPossibleSize(self, nums: List[int]) -> int:
        i = 0
        n = len(nums)
        change_count = 0
        
        while i < n-1:
            if nums[i]>nums[i+1]:
                change_count+=1
                nums[i+1] = nums[i]
                
            i+=1
            
        return n - change_count
```

### No Need to modify the array
We don't have to modify `nums[i]` just record the pre_max
```python
class Solution:
    def maximumPossibleSize(self, nums: List[int]) -> int:
        ans = 0
        prev_max = 0
        
        for n in nums:
            if n>=prev_max:
                ans += 1
                prev_max = n
            
        return ans
```

## Findings

NA

## Encountered Problems 

NA