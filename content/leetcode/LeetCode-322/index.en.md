---
title: "LeetCode 322: Coin Change"
summary: "LeetCode Problem Solving - Unbounded minimum-count DP"
description: "LeetCode study note from 2026-04-25"
date: 2026-04-25
tags: ["leetcode", "medium", "dynamic-programming", "unbounded-knapsack"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-04-25
Source Note: `notes/day10-week3-day2-dp-repair-tls-handshake.md`

## Intuition

This is a minimumcount DP problem. I define dp[i] as the minimum number of coins needed to make amount i. The base case is dp[0] = 0. For each coin, I update dp[i] from dp[i coin] + 1 if the smaller amount is reachable.

Pattern: Unbounded minimum-count DP

## Approach

- **Pattern:** Unbounded minimum-count DP.
- **Main lesson:** Correct DP setup was mostly fine; the bug was control flow and greedy intuition.

## State
```text
dp[i] = minimum number of coins needed to make amount i
```

## Base Case
```text
dp[0] = 0
```

## Transition
```text
dp[i] = min(dp[i], dp[i - coin] + 1)
```

for each reachable `i - coin`.

## Initialization
```text
dp[i] = infinity for unreachable amounts
```

## Important Repairs
- Do not early return just because `dp[amount]` becomes finite once.
- Do not assume reverse-sorting coins makes the first reachable answer optimal.
- Do not size the DP array with `len(coins) + 1`; it must be `amount + 1`.

## Interview-Ready Explanation
This is a minimum-count DP problem. I define `dp[i]` as the minimum number of coins needed to make amount `i`. The base case is `dp[0] = 0`. For each coin, I update `dp[i]` from `dp[i - coin] + 1` if the smaller amount is reachable. After filling the table, if `dp[amount]` is still infinity, the answer is `-1`.

## Complexity
```text
Time: O(amount * len(coins))
Space: O(amount)
```

## Must-Know Distinction
```text
Coin Change minimum count -> dp[0] = 0
Coin Change 2 counting ways -> dp[0] = 1
```

## Findings

- Keep the state meaning explicit before writing the transition.
- Check base cases and return value before trusting the recurrence.
- Explain why the iteration order or traversal order preserves the intended invariant.

## Encountered Problems

Repaired.
