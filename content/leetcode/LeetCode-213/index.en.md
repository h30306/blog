---
title: "LeetCode 213: House Robber II"
summary: "LeetCode note for House Robber II, rebuilt from the original learning note"
description: "Cleaned LeetCode 213 article from 2026-04-25 with note repair points and final solution"
date: 2026-04-25
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
First Attempt: 2026-04-25
Source: Day 11 learning note

## Study Context

This article is rebuilt from the exact LeetCode section in the learning note. I kept the note's repair points, comparison points, and common mistakes, while removing unrelated non-LeetCode material from the same day.

## Learning Note Extract

#### Problem 2 - LC 213 House Robber II Timed Re-Solve
- **Status:** Good enough.
- **Pattern:** Circular array -> split into two linear robber problems.

#### Key Constraint
```text
first house and last house are adjacent
```

So a valid answer must be one of:
```text
exclude last house
exclude first house
```

#### Interview-Ready Explanation
Because the houses are arranged in a circle, the first and last houses are adjacent, so I cannot rob both. I split the problem into two linear House Robber I cases: rob `nums[:-1]` or rob `nums[1:]`, then take the maximum of those two answers.

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

```python
from typing import List

class Solution:
    def rob(self, nums: List[int]) -> int:
        if len(nums) == 1:
            return nums[0]

        def rob_line(arr):
            prev2 = prev1 = 0
            for x in arr:
                prev2, prev1 = prev1, max(prev1, prev2 + x)
            return prev1

        return max(rob_line(nums[:-1]), rob_line(nums[1:]))
```

## Complexity

Time O(n), Space O(1).

## Mistakes To Watch

- Running LC 198 directly on a circle.
- Forgetting n=1.

## Final Interview Explanation

Start from the state definition, then explain why the transition preserves that state. If there is a loop direction, state compression, or a similar-looking problem with a different answer shape, call that out explicitly because that is where this problem family usually breaks down.
