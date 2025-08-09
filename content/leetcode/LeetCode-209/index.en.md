---
title: "LeetCode 209: Minimum Size Subarray Sum (Sliding Window)"
summary: "Sliding window with two pointers; minimize subarray length where sum ≥ target."
description: "Sliding window approach to find the minimal-length subarray with sum ≥ target; includes complexity and key takeaways."
date: 2025-08-09
tags: ["LeetCode", "daily", "medium", "array", "sliding-window", "two-pointers", "prefix-sum", "binary-search"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: Medium
First Attempt: 2025-08-09
- Total time: 00:00.00

## Intuition

This is a sliding window problem. We expand the right pointer to accumulate the window sum. Whenever the sum becomes greater than or equal to the target, we shrink the window from the left to minimize the length that still satisfies the condition.

## Approach

- Maintain a window `[left, right]` and a running `window_sum`.
- For each `right`, add `nums[right]` to `window_sum`.
- While `window_sum ≥ target`, update the answer with the current window length and move `left` forward, subtracting `nums[left]` from `window_sum` to try to shorten the window.

```python
from typing import List

class Solution:
    def minSubArrayLen(self, target: int, nums: List[int]) -> int:
        left = 0
        window_sum = 0
        min_length = float("inf")

        for right, value in enumerate(nums):
            window_sum += value
            while window_sum >= target:
                min_length = min(min_length, right - left + 1)
                window_sum -= nums[left]
                left += 1

        return 0 if min_length == float("inf") else min_length
```

### Complexity

- Time: O(n)
- Space: O(1)

## Findings

- Sliding window works because all numbers are positive; shrinking the window only decreases the sum.
- Key invariant: when `window_sum ≥ target`, increment `left` to find the minimal valid window.
- Alternative: prefix sums + binary search yields O(n log n), but sliding window is optimal here.

## Encountered Problems 