---
title: "LeetCode 1695: Maximum Erasure Value (Sliding Window)"
summary: "Sliding window with a set and running sum; two pointers to keep the subarray unique."
description: "LeetCode Daily"
date: 2025-08-09
tags: ["LeetCode", "daily", "medium", "sliding-window", "two-pointers", "array", "hashset"]

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

This is a classic sliding window with a uniqueness constraint. Maintain a window that contains no duplicates. Move the right pointer forward; while `nums[right]` is already in the window, shrink from the left by removing values and subtracting them from the running sum. Then insert `nums[right]`, update the running sum, and track the maximum.

## Approach

```python
class Solution:
    def maximumUniqueSubarray(self, nums: List[int]) -> int:
        left = max_score = score_now = 0
        occur = set()

        for right in range(len(nums)):
            while nums[right] in occur:
                occur.remove(nums[left])
                score_now -= nums[left]
                left += 1

            occur.add(nums[right])
            score_now += nums[right]
            max_score = max(max_score, score_now)

        return max_score
```

## Complexity

- Time: O(n)
- Space: O(n)

## Findings

- Keeping a running sum avoids recomputing subarray sums when the window moves.
- A set gives O(1) membership checks to enforce uniqueness.
- This is a standard two-pointer pattern; the same template applies to many "longest/maximum subarray with constraint" problems.

## Encountered Problems 