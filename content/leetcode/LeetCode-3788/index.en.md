---
title: "LeetCode 3788: Maximum Score of a Split"
summary: "LeetCode 3788 note: build the suffix minimum first, then accumulate the prefix sum from the left and try every split"
description: "LeetCode 3788 record from 2025-12-28"
date: 2025-12-28
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
First Attempt: 2025-12-28
- Submissions: Accepted (first try)

## Approach

Split `i` scores `prefixSum(i) - suffixMin(i + 1)`, and both can be precomputed ([Prefix Sum]({{< relref "/algorithm/Prefix-Sum" >}}) Template 2):

- Suffix minimum `suf_min[i] = min(nums[i..n-1])`, built right to left.
- The prefix sum accumulates during the scan.

Numbers can be negative and so can the answer, so start from `-inf`.

## My Solution

I originally named the two arrays backward (`prefix_min` was actually a prefix sum) and stored the suffix array reversed. Cleaned up:

```python
class Solution:
    def maximumScore(self, nums: List[int]) -> int:
        n = len(nums)
        suf_min = nums[:]
        for i in range(n - 2, -1, -1):
            suf_min[i] = min(suf_min[i + 1], nums[i])
        best, prefix = -inf, 0
        for i in range(n - 1):
            prefix += nums[i]
            best = max(best, prefix - suf_min[i + 1])
        return best
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- The answer can be negative; do not start from 0.
- `i` goes up to `n - 2`; the right side cannot be empty.

## Interview Explanation

The score is the left prefix sum minus the right minimum. I build the suffix minimum right to left, then accumulate the prefix sum left to right and take the best split. Time `O(n)`.
