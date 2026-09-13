---
title: "LeetCode 343: Integer Break"
summary: "LeetCode note for Integer Break, rebuilt from the original learning note"
description: "Cleaned LeetCode 343 article from 2026-05-07 with note repair points and final solution"
date: 2026-05-07
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
First Attempt: 2026-05-07
Source: Day 20 learning note

## Study Context

This article is rebuilt from the exact LeetCode section in the learning note. I kept the note's repair points, comparison points, and common mistakes, while removing unrelated non-LeetCode material from the same day.

## Learning Note Extract

#### Problem 1 - LC 343 Integer Break
- **Status:** Good enough.
- **Pattern:** Partition DP / max-product DP.

#### Why DP Fits
For each integer `i`, we try every split:
```text
i = j + (i - j)
```

The best product for `i` depends on smaller integers, so this has overlapping subproblems.

Important nuance:
```text
each side of the split may be kept raw or broken further
```

#### State
```text
dp[i] = maximum product obtainable by breaking integer i into at least two positive integers
```

#### Base Case
```text
dp[1] = 1
dp[2] = 1
```

#### Transition
For each split `j` from `1` to `i - 1`:
```text
dp[i] = max(dp[i], max(j, dp[j]) * max(i - j, dp[i - j]))
```

Why `max(raw, dp)` matters:
- sometimes a side should stay as the raw number
- sometimes a side should be broken further

Counterexample to `dp[j] * dp[i-j]` only:
```text
i = 3, split = 2 + 1
correct product is 2 * 1 = 2
but dp[2] * dp[1] = 1 * 1 = 1
```

#### Complexity
```text
Time: O(n^2)
Space: O(n)
```

#### Common Mistakes
- forcing both sides to use `dp[...]` instead of allowing raw factors
- forgetting that the problem requires at least one break
- using `j = 0` split even though all parts must be positive

#### Interview-Ready Explanation
This is partition DP. I define `dp[i]` as the maximum product obtainable by breaking integer `i` into at least two positive integers. For each `i`, I try every split `j` and `i - j`. For each side, I choose either to keep it as a raw number or break it further, so the transition is `dp[i] = max(dp[i], max(j, dp[j]) * max(i - j, dp[i - j]))`. The time complexity is `O(n^2)` and the space complexity is `O(n)`.

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

```python
class Solution:
    def integerBreak(self, n: int) -> int:
        dp = [0] * (n + 1)
        for x in range(2, n + 1):
            for a in range(1, x):
                b = x - a
                dp[x] = max(dp[x], max(a, dp[a]) * max(b, dp[b]))
        return dp[n]
```

## Complexity

Time O(n^2), Space O(n).

## Mistakes To Watch

- Forgetting n must be broken into at least two positive integers.
- Only considering fully broken subparts.

## Final Interview Explanation

Start from the state definition, then explain why the transition preserves that state. If there is a loop direction, state compression, or a similar-looking problem with a different answer shape, call that out explicitly because that is where this problem family usually breaks down.
