---
title: "LeetCode 494: Target Sum"
summary: "LeetCode note for Target Sum, rebuilt from the original learning note"
description: "Cleaned LeetCode 494 article from 2026-08-23 with note repair points and final solution"
date: 2026-08-23
tags: ["medium", "dynamic-programming", "knapsack", "subset-sum"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-08-23
Source: Day 44 learning note

## Study Context

This article is rebuilt from the exact LeetCode section in the learning note. I kept the note's repair points, comparison points, and common mistakes, while removing unrelated non-LeetCode material from the same day.

## Related Reminders From The Note

- `LC 494`: pass after algebra repair
- say one clean difference between `LC 494`, `LC 518`, and `LC 1155`

## Learning Note Extract

#### Problem 1 - LC 494 Target Sum
- **Pattern:** `0/1` subset-sum counting after algebra reduction.

#### Why This Fits
Each number is used exactly once, but can land in either:
- the `+` set
- the `-` set

Let:
```text
P = sum of plus-assigned numbers
N = sum of minus-assigned numbers
```

Then:
```text
P - N = target
P + N = total
=> N = (total - target) / 2
```

So the real question is:
```text
how many subsets sum to (total - target) / 2?
```

#### Core State / Invariant
```text
dp[s] = number of ways to form sum s using the numbers processed so far
```

#### Base Case
```text
dp[0] = 1
```

Reason:
```text
there is exactly one way to make sum 0 before using any numbers:
choose nothing
```

#### Transition
For each `num`, iterate sum backward:
```text
dp[s] += dp[s - num]
```

#### Why Backward
Backward iteration preserves the `0/1` rule:
```text
the current number must not be reused again in the same iteration
```

#### Immediate Zero Cases
```text
abs(target) > total
```

or:
```text
(total - target) is odd
```

#### Complexity
```text
Time: O(len(nums) * reduced_target)
Space: O(reduced_target)
```

#### Common Mistakes
- getting the algebra reduction sign wrong
- forgetting the `abs(target) > total` rejection
- saying `dp[s]` is only `possible or not` instead of `number of ways`
- iterating the sum forward and accidentally reusing one number multiple times

#### Strong Spoken Explanation
I convert the sign-assignment problem into subset-sum counting. If `P` is the plus set and `N` is the minus set, then `P - N = target` and `P + N = total`, so `N = (total - target) / 2`. That means I just need to count how many subsets sum to that reduced target. If the reduced target is negative or not an integer, the answer is `0`. Then I use `0/1` counting DP where `dp[s]` is the number of ways to form sum `s` using the numbers processed so far. I initialize `dp[0] = 1`, iterate each number once, and update sums backward with `dp[s] += dp[s - num]`.

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

```python
from typing import List

class Solution:
    def findTargetSumWays(self, nums: List[int], target: int) -> int:
        total = sum(nums)
        if abs(target) > total or (total + target) % 2:
            return 0
        subset = (total + target) // 2
        dp = [0] * (subset + 1)
        dp[0] = 1

        for num in nums:
            for s in range(subset, num - 1, -1):
                dp[s] += dp[s - num]

        return dp[subset]
```

## Complexity

Time O(n * subset_target), Space O(subset_target).

## Mistakes To Watch

- Missing the parity check.
- Iterating forward and reusing one number.

## Final Interview Explanation

Start from the state definition, then explain why the transition preserves that state. If there is a loop direction, state compression, or a similar-looking problem with a different answer shape, call that out explicitly because that is where this problem family usually breaks down.
