---
title: "LeetCode 70: Climbing Stairs"
summary: "LeetCode note for Climbing Stairs, rebuilt from the original learning note"
description: "Cleaned LeetCode 70 article from 2026-04-20 with note repair points and final solution"
date: 2026-04-20
tags: ["easy", "dynamic-programming"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2026-04-20
Source: Day 9 learning note

## Study Context

This article is rebuilt from the exact LeetCode section in the learning note. I kept the note's repair points, comparison points, and common mistakes, while removing unrelated non-LeetCode material from the same day.

## Learning Note Extract

#### LC 70 - Climbing Stairs
- **Status:** Completed.
- **Pattern:** Fibonacci-style 1D DP.

#### State
```text
dp[i] = number of distinct ways to reach step i
```

#### Base Case
```text
dp[0] = 1
dp[1] = 1
```

`dp[0] = 1` means there is one way to start before taking any steps: do nothing.

#### Transition
```text
dp[i] = dp[i - 1] + dp[i - 2]
```

To reach step `i`, the last move must come from step `i - 1` with one step or from step `i - 2` with two steps.

#### Complexity
```text
Time: O(n)
Space: O(n) with array, O(1) with two variables
```

## Organized Notes

The useful way to say this problem is not just "Fibonacci". The state is a count of ordered step sequences. Reaching step `i` can only end with a `1`-step from `i - 1` or a `2`-step from `i - 2`, so the two predecessor counts are disjoint and can be added. In the submitted version I use `n <= 2` as the small-case shortcut, then roll the same recurrence with two variables.

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

```python
class Solution:
    def climbStairs(self, n: int) -> int:
        if n <= 2:
            return n
        prev2, prev1 = 1, 2
        for _ in range(3, n + 1):
            prev2, prev1 = prev1, prev1 + prev2
        return prev1
```

## Complexity

Time O(n), Space O(1).

## Mistakes To Watch

- Off-by-one base cases.
- Thinking order does not matter; sequences of 1/2 steps are distinct.

## Final Interview Explanation

I would describe this as counting ordered step sequences. `dp[i]` is the number of ways to stand on step `i`; the last move is either one step from `i - 1` or two steps from `i - 2`, so I add those two counts and roll the recurrence with constant space.
