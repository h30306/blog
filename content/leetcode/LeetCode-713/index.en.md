---
title: "LeetCode 713: Subarray Product Less Than K"
summary: "LeetCode Problem Solving"
description: "LeetCode Daily"
date: 2025-08-02
tags: ["LeetCode", "daily", "medium", "sliding window"]

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

The target is to find the count of the contiguous subarray that product sum less then k, so this is a non-fixed sliding window problem.

**Key Insights:**

1. **Sliding Window Approach**: Since we need to find all contiguous subarrays with product < k, we can use a sliding window technique where we maintain a window of elements whose product is less than k.

2. **Dynamic Window Size**: Unlike fixed-size sliding windows, this problem requires a variable window size that expands and contracts based on the product constraint.

3. **Two Pointers Strategy**: 
   - Right pointer expands the window by including new elements
   - Left pointer contracts the window when the product becomes >= k
   - This ensures we always have a valid window

4. **Counting Logic**: When the product is < k, all subarrays ending at the right pointer are valid. The count is `right - left + 1`, which represents all possible starting positions from left to right.

5. **Edge Case Handling**: If k <= 1, no positive integers can multiply to less than 1, so return 0.

**Why This Works:**
- Each time we expand the right pointer, we add a new element to our window
- If the product becomes >= k, we shrink from the left until the product is < k again
- For each valid window, we count all subarrays ending at the right pointer
- This approach ensures we don't miss any valid subarrays and don't count any invalid ones

## Approach

```python
class Solution:
    def numSubarrayProductLessThanK(self, nums: List[int], k: int) -> int:
        if k <= 1:
            return 0
        n = len(nums)
        count = left = 0

        product = 1
        for right in range(n):
            product *= nums[right]
            while product >= k:
                product //= nums[left]
                left += 1
            count += right - left + 1

        return count
```

## Findings

1. **Sliding Window Variation**: This problem demonstrates a non-fixed size sliding window where we need to dynamically adjust the window size based on the product constraint.

2. **Product Handling**: When dealing with products, special attention must be paid to edge cases like k <= 1, which would make it impossible to find valid subarrays.

3. **Efficient Counting**: Learned how to efficiently count valid subarrays by understanding that when the product is < k, all subarrays ending at the right pointer are valid.

4. **Two Pointers Technique**: Mastered the flexible use of two pointers to maintain a dynamic window that satisfies the product constraint.

5. **Time Complexity**: O(n) where each element is visited at most twice (once by right pointer, once by left pointer).

6. **Space Complexity**: O(1) as we only use constant extra space.

## Encountered Problems