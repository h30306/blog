---
title: "LeetCode 494: Target Sum"
summary: "LeetCode Problem Solving - 0/1 subset-sum counting after algebra reduction"
description: "LeetCode study note from 2026-08-23"
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
Source Note: `notes/day44-week8-day2-target-sum-dice-rolls-shard-key-hot-shard.md`

## Intuition

I convert the signassignment problem into subsetsum counting. If P is the plus set and N is the minus set, then P N = target and P + N = total, so N = (total target) / 2. That means I just need to count how many subsets

Pattern: `0/1` subset-sum counting after algebra reduction

## Approach

- **Pattern:** `0/1` subset-sum counting after algebra reduction.

## Why This Fits
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

## Core State / Invariant
```text
dp[s] = number of ways to form sum s using the numbers processed so far
```

## Base Case
```text
dp[0] = 1
```

Reason:
```text
there is exactly one way to make sum 0 before using any numbers:
choose nothing
```

## Transition
For each `num`, iterate sum backward:
```text
dp[s] += dp[s - num]
```

## Why Backward
Backward iteration preserves the `0/1` rule:
```text
the current number must not be reused again in the same iteration
```

## Immediate Zero Cases
```text
abs(target) > total
```

or:
```text
(total - target) is odd
```

## Complexity
```text
Time: O(len(nums) * reduced_target)
Space: O(reduced_target)
```

## Common Mistakes
- getting the algebra reduction sign wrong
- forgetting the `abs(target) > total` rejection
- saying `dp[s]` is only `possible or not` instead of `number of ways`
- iterating the sum forward and accidentally reusing one number multiple times

## Strong Spoken Explanation
I convert the sign-assignment problem into subset-sum counting. If `P` is the plus set and `N` is the minus set, then `P - N = target` and `P + N = total`, so `N = (total - target) / 2`. That means I just need to count how many subsets sum to that reduced target. If the reduced target is negative or not an integer, the answer is `0`. Then I use `0/1` counting DP where `dp[s]` is the number of ways to form sum `s` using the numbers processed so far. I initialize `dp[0] = 1`, iterate each number once, and update sums backward with `dp[s] += dp[s - num]`.

## Findings

- Keep the state meaning explicit before writing the transition.
- Check base cases and return value before trusting the recurrence.
- Explain why the iteration order or traversal order preserves the intended invariant.

## Encountered Problems

Captured from the learning note; no separate failure note was recorded.
