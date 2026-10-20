---
title: "LeetCode 1877: Minimize Maximum Pair Sum in Array"
summary: "LeetCode 1877 note: after sorting, pair the smallest with the largest, the second smallest with the second largest, and take the largest pair sum with converging pointers"
description: "LeetCode 1877 record from 2026-01-24"
date: 2026-01-24
tags: ["medium", "two-pointers", "greedy", "sorting", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-24
- Submissions: Accepted (first try)

## Approach

Greedy: **the largest number should pair with the smallest.** If the largest is paired with some `x`, swapping `x` for the smallest number never increases the maximum pair sum (an exchange argument).

After sorting, converging pointers give each pair `nums[left] + nums[right]`, and the answer is the largest of those sums.

## My Solution

```python
class Solution:
    def minPairSum(self, nums: List[int]) -> int:
        nums.sort()
        left, right = 0, len(nums) - 1
        best = 0
        while left < right:
            best = max(best, nums[left] + nums[right])
            left += 1
            right -= 1
        return best
```

## Complexity

Time `O(n log n)`, space `O(1)` apart from sorting.

## Mistakes to Avoid

- Pairing neighbors: the two largest end up together, which gives the worst pair sum.

## Interview Explanation

The largest number is in some pair no matter what, and pairing it with the smallest keeps that pair as small as possible; an exchange argument shows this is never worse. After sorting I pair the smallest with the largest, move inward, and take the largest pair sum. Time `O(n log n)`.
