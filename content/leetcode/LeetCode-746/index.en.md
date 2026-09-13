---
title: "LeetCode 746: Min Cost Climbing Stairs"
summary: "LeetCode Problem Solving - Fibonacci-style minimum-cost DP"
description: "LeetCode study note from 2026-04-25"
date: 2026-04-25
tags: ["leetcode", "easy", "dynamic-programming"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2026-04-25
Source Note: `notes/day10-week3-day2-dp-repair-tls-handshake.md`

## Intuition

I can start from step 0 or step 1. To reach step i, I must come from i 1 or i 2, so the minimum cost to reach i is the current step cost plus the cheaper of those two previous states. Since the top is beyond the last ste

Pattern: Fibonacci-style minimum-cost DP

## Approach

- **Pattern:** Fibonacci-style minimum-cost DP.

## State
```text
dp[i] = minimum cost to reach step i
```

## Base Case
```text
dp[0] = cost[0]
dp[1] = cost[1]
```

## Transition
```text
dp[i] = cost[i] + min(dp[i - 1], dp[i - 2])
```

## Final Answer
The top is one step beyond the last index, so:
```text
answer = min(dp[n - 1], dp[n - 2])
```

## Complexity
```text
Time: O(n)
Space: O(n)
```

## Interview-Ready Explanation
I can start from step 0 or step 1. To reach step `i`, I must come from `i - 1` or `i - 2`, so the minimum cost to reach `i` is the current step cost plus the cheaper of those two previous states. Since the top is beyond the last step, the answer is the cheaper of reaching the last or second-last step.

## Findings

- Keep the state meaning explicit before writing the transition.
- Check base cases and return value before trusting the recurrence.
- Explain why the iteration order or traversal order preserves the intended invariant.

## Encountered Problems

Good enough.
