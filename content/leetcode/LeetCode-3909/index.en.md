---
title: "LeetCode 3909: Compare Sums of Bitonic Parts"
summary: "LeetCode 3909 note: walk to the peak and sum each side; the peak belongs to both, so including it or not does not change the comparison"
description: "LeetCode 3909 record from 2026-04-25"
date: 2026-04-25
tags: ["medium", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-04-25
- Submissions: Accepted (first try)

## Approach

The array strictly rises then falls, so the peak is unique. Left is `nums[0..peak]` and right is `nums[peak..n-1]` ([Array]({{< relref "/algorithm/Array" >}}) Template 1). The peak belongs to both, adding the same amount to each side, so it can be left out of the comparison.

## My Solution

```python
class Solution:
    def compareBitonicSums(self, nums: List[int]) -> int:
        peak = nums.index(max(nums))
        left, right = sum(nums[:peak + 1]), sum(nums[peak:])
        if left > right:
            return 0
        if left < right:
            return 1
        return -1
```

I originally walked two pointers from both ends toward the peak, summing as they went (without the peak). With a strictly bitonic array the maximum is the peak, so `max` finds it too.

## Complexity

Time `O(n)`, space `O(n)` (slices).

## Mistakes to Avoid

- Return values: 0 when the left is larger, 1 when the right is, -1 when equal.

## Interview Explanation

In a strictly bitonic array the maximum is the peak; I find it, sum both sides, and compare. The peak is on both sides, so it does not affect the result. Time `O(n)`.
