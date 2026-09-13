---
title: "LeetCode 740: Delete and Earn"
summary: "LeetCode note for Delete and Earn, rebuilt from the original learning note"
description: "Cleaned LeetCode 740 article from 2026-04-25 with note repair points and final solution"
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

#### Problem 1 - LC 740 Delete and Earn
- **Status:** Completed.
- **Pattern:** Value bucketing -> House Robber.
- **Key insight:** The conflict is between values `x`, `x - 1`, and `x + 1`, not between original array positions.

#### Why House Robber
If I take value `x`, I cannot take `x - 1` or `x + 1`.

That is the same shape as:
```text
take current bucket -> skip adjacent bucket
skip current bucket -> keep previous answer
```

So first convert:
```text
points[x] = x * frequency(x)
```

Then solve House Robber on the `points` array.

#### State
```text
dp[i] = maximum points we can earn using values from 0 to i
```

#### Base Case
```text
dp[0] = 0
dp[1] = points[1]
```

#### Transition
```text
dp[i] = max(dp[i - 1], dp[i - 2] + points[i])
```

#### Complexity
```text
Time: O(n + m)
Space: O(m)
```

Where:
```text
n = len(nums)
m = max(nums)
```

#### Interview-Ready Explanation
I group equal values first, because taking a value deletes only its neighboring values, not neighboring positions in the original array. I build `points[x]` as the total points from taking all `x`s. After that, the problem becomes House Robber on values: if I take `x`, I cannot take `x - 1`, so the transition is `max(skip current, take current)`.

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

```python
from typing import List

class Solution:
    def deleteAndEarn(self, nums: List[int]) -> int:
        if not nums:
            return 0
        max_val = max(nums)
        points = [0] * (max_val + 1)
        for x in nums:
            points[x] += x

        prev2 = prev1 = 0
        for gain in points:
            prev2, prev1 = prev1, max(prev1, prev2 + gain)
        return prev1
```

## Complexity

Time O(max(nums)+n), Space O(max(nums)).

## Mistakes To Watch

- Thinking adjacency means array index adjacency instead of numeric value adjacency.
- Not aggregating duplicate values first.

## Final Interview Explanation

Start from the state definition, then explain why the transition preserves that state. If there is a loop direction, state compression, or a similar-looking problem with a different answer shape, call that out explicitly because that is where this problem family usually breaks down.
