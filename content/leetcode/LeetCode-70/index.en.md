---
title: "LeetCode 70: Climbing Stairs"
summary: "LeetCode Problem Solving - Fibonaccistyle 1D DP. State Base Case dp[0] = 1 means there is one way to start before taking any steps: do nothing. Transition To reach step i, the last move must come from step i 1 with one step or from step i"
description: "LeetCode study note from 2026-04-20"
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
Source Note: `notes/day9-week3-dp-intro-tls-load-balancing.md`

## Intuition

Pattern: Fibonaccistyle 1D DP. State Base Case dp[0] = 1 means there is one way to start before taking any steps: do nothing. Transition To reach step i, the last move must come from step i 1 with one step or from step i

Pattern: Fibonacci-style 1D DP

## Approach

- **Pattern:** Fibonacci-style 1D DP.

## State
```text
dp[i] = number of distinct ways to reach step i
```

## Base Case
```text
dp[0] = 1
dp[1] = 1
```

`dp[0] = 1` means there is one way to start before taking any steps: do nothing.

## Transition
```text
dp[i] = dp[i - 1] + dp[i - 2]
```

To reach step `i`, the last move must come from step `i - 1` with one step or from step `i - 2` with two steps.

## Complexity
```text
Time: O(n)
Space: O(n) with array, O(1) with two variables
```

## Findings

- Keep the state meaning explicit before writing the transition.
- Check base cases and return value before trusting the recurrence.
- Explain why the iteration order or traversal order preserves the intended invariant.

## Encountered Problems

Completed.
