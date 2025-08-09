---
title: "LeetCode 1004: Max Consecutive Ones III"
summary: "LeetCode Problem Solving - Variable Size Sliding Window with Zero Counting"
description: "LeetCode Daily - Find longest subarray with at most K zeros using sliding window"
date: 2025-08-03
tags: ["LeetCode", "daily", "medium", "sliding window", "array", "two pointers", "binary array"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-08-03
- Total time: 00:00.00

## Intuition

We need to keep track of how many zeros are in the current window. If the zero count exceeds the limit `k`, we start shrinking the window from the left until the zero count meets the limit. This is a classic variable-size sliding window problem where we expand the window as much as possible and contract it when necessary to maintain the constraint.

## Approach

### Variable Size Sliding Window with Zero Counting
```python
class Solution:
    def longestOnes(self, nums: List[int], k: int) -> int:
        zero_count = max_len = left = 0

        for right in range(len(nums)):
            # Count zeros in current window
            if nums[right] == 0:
                zero_count += 1

            # Shrink window if zero count exceeds limit
            while zero_count > k:
                if nums[left] == 0:
                    zero_count -= 1
                left += 1

            # Update maximum length
            max_len = max(max_len, right - left + 1)

        return max_len
```

## Algorithm Analysis

### Time Complexity
- **Time**: O(n) where n is the length of the input array
- **Space**: O(1) since we only use a constant amount of extra space

### Key Insights
1. **Variable Window Size**: Unlike fixed-size sliding window, this window can grow and shrink based on constraints
2. **Zero Counting**: We only need to track the count of zeros, not ones
3. **Window Shrinking**: When constraint is violated, we shrink from left until valid again

## Findings

1. **Variable Size Sliding Window**: This problem demonstrates the variable-size sliding window technique, where the window size can change based on the constraint (number of zeros).

2. **Constraint-Based Window Management**: The key insight is that we can expand the window as much as possible, but we must shrink it when the zero count exceeds the limit `k`.

3. **Zero Counting Strategy**: We only need to track the count of zeros in the window, not ones. This simplifies the logic since we're essentially looking for the longest subarray with at most `k` zeros.

4. **Window Shrinking Logic**: When the zero count exceeds `k`, we shrink the window from the left by moving the left pointer until the zero count is back within the limit.

5. **Maximum Length Tracking**: We continuously update the maximum length whenever we have a valid window (zero count ≤ k).

6. **Single Pass Solution**: The solution requires only one pass through the array, making it very efficient for large inputs.

7. **Memory Efficiency**: O(1) space complexity makes this solution very memory-efficient, as we only need a few variables to track the current state.

8. **Edge Case Handling**: The solution naturally handles edge cases like arrays with all ones or all zeros.

## Encountered Problems 
