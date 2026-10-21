---
title: "LeetCode 3701: Compute Alternating Sum"
summary: "LeetCode 3701 note: add even indices and subtract odd ones; with slices, sum(nums[::2]) - sum(nums[1::2])"
description: "LeetCode 3701 record from 2025-10-05"
date: 2025-10-05
tags: ["easy", "array", "simulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2025-10-05
- Submissions: Accepted (first try)

## Approach

Sum the even positions and the odd positions separately; their difference is the alternating sum ([Array]({{< relref "/algorithm/Array" >}}) Template 5).

## My Solution

```python
class Solution:
    def alternatingSum(self, nums: List[int]) -> int:
        return sum(nums[::2]) - sum(nums[1::2])
```

I originally added or subtracted in a loop based on `i % 2`; same result.

## Complexity

Time `O(n)`, space `O(n)` (slices).

## Mistakes to Avoid

- Indices start at 0, so the first element is added.

## Interview Explanation

Sum the even positions, sum the odd positions, and subtract. Time `O(n)`.
