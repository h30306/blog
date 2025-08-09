---
title: "LeetCode 2090: K Radius Subarray Averages"
summary: "LeetCode Problem Solving"
description: "LeetCode Daily"
date: 2025-08-02
tags: ["LeetCode", "daily", "medium", "Sliding Window"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-08-02
- Total time: 00:00.00

## Intuition

This is a fixed-window sliding window problem. There's no special technique needed to solve this problem - we simply calculate the window size and slide from left to right. If the window is not large enough, we don't update the value in the result array. We can initialize the result array with all -1 values.

## Approach
```python
class Solution:
    def getAverages(self, nums: List[int], k: int) -> List[int]:
        
        window_size = (k * 2) + 1
        n = len(nums)
        res = [-1] * n

        if n < window_size:
            return res

        window_sum = 0
        for i in range(n):
            window_sum += nums[i]

            if i - window_size >= 0:
                window_sum -= nums[i - window_size]
            
            if i >= window_size - 1:
                res[i - k] = window_sum // window_size

        return res
```

## Findings

1. **Sliding Window Technique**: This problem is a classic application of the sliding window technique, where we maintain a fixed-size window and calculate the average of elements within that window.

2. **Edge Case Handling**: The key insight is handling cases where the array length is smaller than the required window size (2k + 1). In such cases, we return an array filled with -1.

3. **Window Size Calculation**: The window size is calculated as `(k * 2) + 1` because we need k elements on each side of the current element, plus the element itself.

4. **Result Array Positioning**: When we have a valid window, we place the average at position `i - k` in the result array, which corresponds to the center of the current window.

5. **Time Complexity**: O(n) where n is the length of the input array, as we only need to traverse the array once.

6. **Space Complexity**: O(1) extra space (excluding the result array), as we only use a constant amount of additional variables.

## Encountered Problems 
