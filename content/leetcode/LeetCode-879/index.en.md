---
title: "LeetCode 879: Profitable Schemes"
summary: "LeetCode Problem Solving - counting 0/1 knapsack with member capacity and capped profit threshold"
description: "LeetCode study note from 2026-08-19"
date: 2026-08-19
tags: ["leetcode", "hard", "dynamic-programming", "knapsack"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-08-19
Source Note: `notes/day46-week8-day4-profitable-schemes-form-largest-integer-redis-vs-query-fix.md`

## Intuition

This is a counting 0/1 knapsack. Each crime can be taken once, it consumes some members, and it contributes profit. The state I used is dp[p][m] = number of schemes that achieve at least profit p using at most m members.

Pattern: counting `0/1` knapsack with member capacity and capped profit threshold

## Approach

- **Pattern:** counting `0/1` knapsack with member capacity and capped profit threshold.

## Why This Fits
Each crime can be:
```text
taken once or skipped
```

It consumes:
- some members

It contributes:
- some profit

The question is not to maximize profit.

It is:
```text
how many subsets satisfy members <= n and profit >= minProfit?
```

## Core State / Invariant
For the implemented version used today:
```text
dp[p][m] = number of schemes that achieve at least profit p using at most m members
```

Profit is capped into:
```text
0..minProfit
```

## Base Case
For every member limit `m`:
```text
dp[0][m] = 1
```

Reason:
```text
the empty set already achieves profit at least 0 and fits under any member cap
```

## Transition
For a crime needing `g` members and giving profit `earn`:
```text
prevProfit = max(0, p - earn)
dp[p][m] += dp[prevProfit][m - g]
```

with modulo.

## Why Profit Is Capped
Once a scheme already achieves:
```text
profit >= minProfit
```

extra profit does not create a new validity category.

So all larger profits can be merged into:
```text
the minProfit bucket
```

## Complexity
```text
Time: O(len(group) * n * minProfit)
Space: O(n * minProfit)
```

## Common Mistakes
- mixing `exactly m members` with `at most m members`
- using a state explanation that does not match the code
- forgetting why `dp[0][m] = 1` is valid in the `at most` formulation
- not capping profit at `minProfit`

## Strong Spoken Explanation
This is a counting `0/1` knapsack. Each crime can be taken once, it consumes some members, and it contributes profit. The state I used is `dp[p][m] = number of schemes that achieve at least profit p using at most m members`. I cap the profit dimension at `minProfit` because once a scheme reaches that threshold, extra profit does not change whether it is valid. I initialize `dp[0][m] = 1` for all member limits because the empty set already satisfies profit at least `0`. Then for each crime I iterate both dimensions backward and add the previous-state count from `dp[max(0, p - earn)][m - g]`.

## Findings

- Keep the state meaning explicit before writing the transition.
- Check base cases and return value before trusting the recurrence.
- Explain why the iteration order or traversal order preserves the intended invariant.

## Encountered Problems

Captured from the learning note; no separate failure note was recorded.
