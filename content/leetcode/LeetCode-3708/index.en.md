---
title: "LeetCode 3708: Longest Fibonacci Subarray"
summary: "LeetCode 3708 note: lengths 1 and 2 always work; from the third element, extend while nums[i] == nums[i-1] + nums[i-2], otherwise reset to 2"
description: "LeetCode 3708 record from 2025-10-11"
date: 2025-10-11
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
First Attempt: 2025-10-11
- Submissions: Accepted (first try)

## Approach

For a contiguous run, track only the current length ([Array]({{< relref "/algorithm/Array" >}}) Template 1). Any two adjacent numbers can start a new Fibonacci subarray, so a break resets the length to 2, not 1.

## My Solution

```python
class Solution:
    def longestSubarray(self, nums: List[int]) -> int:
        n = len(nums)
        if n <= 2:
            return n
        cur = best = 2
        for i in range(2, n):
            cur = cur + 1 if nums[i] == nums[i - 1] + nums[i - 2] else 2
            best = max(best, cur)
        return best
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- A break resets to 2, since the last two numbers start a new run.
- With fewer than 3 elements, return the length.

## Interview Explanation

From the third number on, I extend the current length when it equals the sum of the previous two, otherwise restart from the last two with length 2. Time `O(n)`.
