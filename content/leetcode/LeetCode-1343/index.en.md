---
title: "LeetCode 1343: Number of Sub-arrays of Size K and Average Greater than or Equal to Threshold"
summary: "LeetCode Problem Solving - Fixed Size Sliding Window with Sum Calculation"
description: "LeetCode Daily - Count subarrays of size K with average >= threshold using sliding window"
date: 2025-08-02
tags: ["LeetCode", "daily", "medium", "sliding window", "array", "prefix sum", "average calculation"]

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

This is a classic fixed-size sliding window problem. We need to maintain a window of size `k` and calculate the sum of elements within that window. Instead of calculating the average directly, we can optimize by pre-calculating the minimum sum required (`k * threshold`) and compare the window sum against this value. This avoids floating-point arithmetic and makes the comparison more efficient.

## Approach

### Fixed Size Sliding Window with Sum Optimization
```python
class Solution:
    def numOfSubarrays(self, arr: List[int], k: int, threshold: int) -> int:
        min_sum = k * threshold  # Pre-calculate minimum sum required
        sum_now = 0
        res = 0

        for i in range(len(arr)):
            sum_now += arr[i]
            
            # Remove element that falls outside the window
            if i - k >= 0:
                sum_now -= arr[i - k]

            # Check if current window meets the threshold requirement
            if i - k + 1 >= 0 and sum_now >= min_sum:
                res += 1

        return res
```

## Algorithm Analysis

### Time Complexity
- **Time**: O(n) where n is the length of the input array
- **Space**: O(1) since we only use a constant amount of extra space

### Key Optimizations
1. **Pre-calculated Threshold**: Instead of calculating average each time, we pre-calculate `min_sum = k * threshold`
2. **Integer Comparison**: Using sum comparison instead of average calculation avoids floating-point arithmetic
3. **Single Pass**: We only need to traverse the array once

## Findings

1. **Fixed Size Sliding Window**: This problem demonstrates the classic fixed-size sliding window technique, where we maintain a window of exactly size `k` and slide it through the array.

2. **Sum vs Average Optimization**: Instead of calculating the average for each window (which would require division), we pre-calculate the minimum sum required (`k * threshold`) and compare sums directly. This is more efficient and avoids floating-point precision issues.

3. **Window Management**: The key insight is maintaining the correct window size by adding new elements and removing old ones when the window exceeds size `k`.

4. **Boundary Condition**: The condition `i - k + 1 >= 0` ensures we only start counting results once we have a complete window of size `k`.

5. **Integer Arithmetic**: Using integer arithmetic for comparisons is more efficient and avoids potential floating-point precision errors that could occur with average calculations.

6. **Single Traversal**: The solution requires only one pass through the array, making it very efficient for large inputs.

7. **Memory Efficiency**: O(1) space complexity makes this solution very memory-efficient, as we only need a few variables to track the current sum and result count.

8. **Edge Case Handling**: The solution naturally handles edge cases where the array length is less than `k` by never finding valid windows.

## Encountered Problems 
