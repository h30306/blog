---
title: "LeetCode 3840: House Robber V"
summary: "LeetCode 3840 note: houses conflict only when adjacent with the same color; take a house outright when the colors differ, and do the House Robber choice only when they match"
description: "LeetCode 3840 record from 2026-02-14"
date: 2026-02-14
tags: ["medium", "dynamic-programming", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-02-14
- Submissions: Accepted (first try)

## Approach

`dp[i]` = the most money from the first `i` houses. For house `i` (0-indexed):

- **Different color from the previous house**: taking it conflicts with nothing, and all amounts are positive, so take it: `dp[i + 1] = dp[i] + nums[i]`.
- **Same color as the previous house**: plain House Robber, taking it means skipping the previous one: `dp[i + 1] = max(dp[i], dp[i - 1] + nums[i])`.

## My Solution

```python
class Solution:
    def rob(self, nums: List[int], colors: List[int]) -> int:
        n = len(nums)
        dp = [0] * (n + 1)                         # dp[i]: best over the first i houses
        for i in range(n):
            if i > 0 and colors[i] == colors[i - 1]:
                dp[i + 1] = max(dp[i], dp[i - 1] + nums[i])
            else:
                dp[i + 1] = dp[i] + nums[i]        # no conflict, take it
        return dp[n]
```

## Complexity

Time `O(n)`, space `O(n)` (compressible to two variables).

## Mistakes to Avoid

- Treating it as ordinary House Robber: neighbors with different colors can both be taken.

## Interview Explanation

`dp[i]` is the best over the first `i` houses. If this house's color differs from the previous one, taking it causes no conflict and amounts are positive, so add it; only with matching colors is it House Robber, choosing between skipping this house and taking it while skipping the previous one. Time `O(n)`.
