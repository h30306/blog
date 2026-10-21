---
title: "LeetCode 628: Maximum Product of Three Numbers"
summary: "LeetCode 628 note: after sorting there are only two candidates: the three largest, or the two smallest (negatives) times the largest"
description: "LeetCode 628 record from 2022-08-29"
date: 2022-08-29
tags: ["easy", "array", "math", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-29
- Submissions: Wrong Answer → Accepted ×3

## Approach

Only two cases can give the largest product of three ([Math]({{< relref "/algorithm/Math" >}}) Template 4): the three largest values, or the two smallest (possibly large negatives, whose product is positive) times the largest. Sort and take the larger of the two; no case split on signs is needed.

## My Attempts

Attempt 1 mistyped an index as `nums[-1] * nums[-1] * nums[-2]`, **using the largest number twice**: `[6, 5, 7]` returned 294 instead of 210. It also had an unneeded branch on whether any number is positive.

## Solution

```python
class Solution:
    def maximumProduct(self, nums: List[int]) -> int:
        nums.sort()
        return max(nums[-1] * nums[-2] * nums[-3], nums[0] * nums[1] * nums[-1])
```

## Complexity

Time `O(n log n)`, space `O(1)`; tracking the top three and bottom two gives `O(n)`.

## Mistakes to Avoid

- Two negatives multiply to a positive, so the two smallest are candidates too.
- Get the indices right: `nums[-1] * nums[-2] * nums[-3]`.

## Interview Explanation

After sorting the answer is either the three largest or the two smallest times the largest, whichever is bigger. Time `O(n log n)`; one pass tracking the top three and bottom two gives `O(n)`.
