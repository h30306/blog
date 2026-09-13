---
title: "LeetCode 377: Combination Sum IV"
summary: "LeetCode note for Combination Sum IV, rebuilt from the original learning note"
description: "Cleaned LeetCode 377 article from 2026-05-03 with note repair points and final solution"
date: 2026-05-03
tags: ["medium", "dynamic-programming", "unbounded-knapsack"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-05-03
Source: Day 18 learning note

## Study Context

This article is rebuilt from the exact LeetCode section in the learning note. I kept the note's repair points, comparison points, and common mistakes, while removing unrelated non-LeetCode material from the same day.

## Learning Note Extract

#### Problem 2 - LC 377 Combination Sum IV
- **Status:** Good enough.
- **Pattern:** Unbounded counting DP for ordered sequences.

#### Why DP Fits
For each target sum `i`, we can pick any `num` as the last element of the sequence.

That means:
```text
number of sequences for i depends on number of sequences for i - num
```

It is unbounded because each number can be reused many times.

Important nuance:
```text
order matters
```

So:
```text
1 + 2 and 2 + 1 are different answers
```

#### State
```text
dp[i] = number of ordered sequences that sum to i
```

#### Base Case
```text
dp[0] = 1
```

Reason:
```text
there is exactly one way to make sum 0: choose nothing
```

#### Transition
For each total `i` from `1` to `target`:
```text
for num in nums:
    if i >= num:
        dp[i] += dp[i - num]
```

#### Why Loop Order Matters
Use:
```text
outer loop on total, inner loop on nums
```

Why:
```text
for each target sum i, we try every num as the last element of the sequence
```

That counts permutations separately.

Example with `nums = [1, 2]`, `target = 3`:
- `[1, 1, 1]`
- `[1, 2]`
- `[2, 1]`

If you use coin-first loop order, you undercount by collapsing different permutations into one combination.

#### Complexity
```text
Time: O(target * len(nums))
Space: O(target)
```

#### Common Mistakes
- saying `dp[i]` is number of combinations instead of ordered sequences
- setting `dp[0] = 0` instead of `1`
- using coin-first loop order and counting combinations instead of permutations
- using min-count transition like `+ 1` instead of counting transition `+=`

#### Interview-Ready Explanation
This is an unbounded counting DP problem where order matters. I define `dp[i]` as the number of ordered sequences that sum to `i`. The base case is `dp[0] = 1`, because there is exactly one way to make sum `0`, which is choosing nothing. Then for each total `i` from `1` to `target`, I iterate through `nums`, and if `i >= num`, I do `dp[i] += dp[i - num]`. The important nuance is that looping total first and nums second counts permutations, so `[1, 2]` and `[2, 1]` are different answers. The time complexity is `O(target * len(nums))` and the space complexity is `O(target)`.

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

```python
from typing import List

class Solution:
    def combinationSum4(self, nums: List[int], target: int) -> int:
        dp = [0] * (target + 1)
        dp[0] = 1

        for t in range(1, target + 1):
            for num in nums:
                if num <= t:
                    dp[t] += dp[t - num]

        return dp[target]
```

## Complexity

Time O(target * len(nums)), Space O(target).

## Mistakes To Watch

- Using coin outer loop, which counts combinations not permutations.
- Confusing this with LC 518.

## Final Interview Explanation

Start from the state definition, then explain why the transition preserves that state. If there is a loop direction, state compression, or a similar-looking problem with a different answer shape, call that out explicitly because that is where this problem family usually breaks down.
