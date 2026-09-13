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

Start from the state definition, then explain why the transition preserves that state. If there is a loop direction, state compression, or a similar-looking problem with a different answer shape, call that out explicitly because that is where this problem family usually breaks down.
