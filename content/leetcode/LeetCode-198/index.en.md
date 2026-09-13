---
title: "LeetCode 198: House Robber"
summary: "LeetCode note for House Robber, rebuilt from the original learning note"
description: "Cleaned LeetCode 198 article from 2026-05-17 with note repair points and final solution"
date: 2026-05-17
tags: ["medium", "dynamic-programming"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-05-17
Source: Day 22 learning note

## Study Context

This article is rebuilt from the exact LeetCode section in the learning note. I kept the note's repair points, comparison points, and common mistakes, while removing unrelated non-LeetCode material from the same day.

## Learning Note Extract

#### Problem 3 - LC 198 House Robber Review
- **Pattern:** 1D DP / choose-skip recurrence.

#### Why This Review Matters
Week 5 starts a harder DP derivation week, so one stable 1D DP review keeps the baseline clean:
```text
dp[i] = max(dp[i - 1], nums[i] + dp[i - 2])
```

#### Interview-Ready Explanation
For each house, I either skip it and keep the best result up to `i - 1`, or rob it and add `nums[i]` to the best result up to `i - 2`. The recurrence is a clean choose-vs-skip DP.

## Organized Notes

This is the clean baseline for choose-or-skip DP. The important invariant is that after scanning a prefix of houses, `prev1` is the best amount for the processed prefix and `prev2` is the best amount before the previous house. For each new house, the two legal choices are: skip it and keep `prev1`, or rob it and add its value to `prev2`. That is why the rolling update is exactly the array recurrence without storing the full table.

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

```python
from typing import List

class Solution:
    def rob(self, nums: List[int]) -> int:
        prev2 = prev1 = 0
        for x in nums:
            prev2, prev1 = prev1, max(prev1, prev2 + x)
        return prev1
```

## Complexity

Time O(n), Space O(1).

## Mistakes To Watch

- Robbing adjacent houses.
- Building a full array when two variables are enough.

## Final Interview Explanation

I would explain this as a choose-or-skip DP. For each house, either I skip it and keep the best value so far, or I rob it and combine it with the best value before the adjacent house. The two-variable version is just the compressed form of `dp[i] = max(dp[i - 1], dp[i - 2] + nums[i])`.
