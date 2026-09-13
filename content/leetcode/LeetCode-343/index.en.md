---
title: "LeetCode 343: Integer Break"
summary: "LeetCode Problem Solving - Partition DP / max-product DP"
description: "LeetCode study note from 2026-05-07"
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
Source Note: `notes/day20-week4-weekend-day1-retry-safe-create-api.md`

## Intuition

This is partition DP. I define dp[i] as the maximum product obtainable by breaking integer i into at least two positive integers. For each i, I try every split j and i j. For each side, I choose either to keep it as a ra

Pattern: Partition DP / max-product DP

## Approach

- **Pattern:** Partition DP / max-product DP.

## Why DP Fits
For each integer `i`, we try every split:
```text
i = j + (i - j)
```

The best product for `i` depends on smaller integers, so this has overlapping subproblems.

Important nuance:
```text
each side of the split may be kept raw or broken further
```

## State
```text
dp[i] = maximum product obtainable by breaking integer i into at least two positive integers
```

## Base Case
```text
dp[1] = 1
dp[2] = 1
```

## Transition
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

## Complexity
```text
Time: O(n^2)
Space: O(n)
```

## Common Mistakes
- forcing both sides to use `dp[...]` instead of allowing raw factors
- forgetting that the problem requires at least one break
- using `j = 0` split even though all parts must be positive

## Interview-Ready Explanation
This is partition DP. I define `dp[i]` as the maximum product obtainable by breaking integer `i` into at least two positive integers. For each `i`, I try every split `j` and `i - j`. For each side, I choose either to keep it as a raw number or break it further, so the transition is `dp[i] = max(dp[i], max(j, dp[j]) * max(i - j, dp[i - j]))`. The time complexity is `O(n^2)` and the space complexity is `O(n)`.

## Findings

- Keep the state meaning explicit before writing the transition.
- Check base cases and return value before trusting the recurrence.
- Explain why the iteration order or traversal order preserves the intended invariant.

## Encountered Problems

Good enough.
