---
title: "LeetCode 643: Maximum Average Subarray I"
summary: "LeetCode Problem Solving"
description: "LeetCode Daily"
date: 2025-08-02
tags: ["LeetCode", "daily", "easy", "Sliding Window"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2025-08-02
- Total time: 00:00.00

## Intuition

This is a fixed window size sliding window problem. Given the problem requirements, we need to find the maximum average of a subarray. We can understand this as finding the maximum sum of a subarray and then dividing by the window size to get the average. Therefore, the target can be simplified to a maximum subarray sum problem.

## Approach

```python
class Solution:
    def findMaxAverage(self, nums: List[int], k: int) -> float:
        max_sum = 0
        for i in range(k):
            max_sum += nums[i]

        sum_now = max_sum
        for i in range(k, len(nums)):
            sum_now += nums[i]
            sum_now -= nums[i - k]

            max_sum = max(max_sum, sum_now)

        return max_sum / k
```

## Findings

This is a fixed window problem. We can accumulate the first window first, and then slide the window until the end.

## Encountered Problems 