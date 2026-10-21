---
title: "LeetCode 3904: Smallest Stable Index II"
summary: "LeetCode 3904 note: the first index where the prefix maximum minus the suffix minimum is <= k; build the suffix minimum right to left first"
description: "LeetCode 3904 record from 2026-04-19"
date: 2026-04-19
tags: ["medium", "prefix-sum", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-04-19
- Submissions: Accepted (first try)

## Approach

Each index scores `max(nums[0..i]) - min(nums[i..n-1])`; scan once from each side ([Prefix Sum]({{< relref "/algorithm/Prefix-Sum" >}}) Template 2):

- Build the suffix minimum right to left first.
- Update the prefix maximum left to right, returning the first index scoring `<= k`.

Versions I and II differ only in the length limit (100 for I, `10^5` for II); I used the same `O(n)` code for both, though for I's small range computing `max` and `min` directly at every position, `O(n²)`, also passes. See [LeetCode 3903]({{< relref "/leetcode/LeetCode-3903" >}}) for the other one.

## My Solution

```python
class Solution:
    def firstStableIndex(self, nums: List[int], k: int) -> int:
        n = len(nums)
        suf_min = nums[:]
        for i in range(n - 2, -1, -1):
            suf_min[i] = min(suf_min[i + 1], nums[i])
        pre_max = -inf
        for i, x in enumerate(nums):
            pre_max = max(pre_max, x)
            if pre_max - suf_min[i] <= k:
                return i
        return -1
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Both ranges include `i` itself.

## Interview Explanation

The score is the maximum up to `i` minus the minimum from `i`. I build the suffix minimum right to left, then keep the prefix maximum left to right, and the first position with difference `<= k` is the answer. Time `O(n)`.
