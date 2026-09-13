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

Start from the state definition, then explain why the transition preserves that state. If there is a loop direction, state compression, or a similar-looking problem with a different answer shape, call that out explicitly because that is where this problem family usually breaks down.
