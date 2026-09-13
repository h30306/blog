---
title: "LeetCode 474: Ones and Zeroes"
summary: "LeetCode Problem Solving - two-capacity 0/1 knapsack maximization"
description: "LeetCode study note from 2026-08-19"
date: 2026-08-19
tags: ["medium", "dynamic-programming", "knapsack"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-08-19
Source Note: `notes/day45-week8-day3-ones-and-zeroes-last-stone-redis-cache-aside.md`

## Intuition

This is a twocapacity 0/1 knapsack. Each string is an item, its cost is (zeroCount, oneCount), and its value is 1 because taking that string increases the answer by one. I use dp[i][j] to mean the maximum number of strin

Pattern: two-capacity `0/1` knapsack maximization

## Approach

- **Pattern:** two-capacity `0/1` knapsack maximization.

## Why This Fits
Each string can be picked:
```text
at most once
```

Each picked string consumes:
- some zeros
- some ones

The value of picking it is:
```text
+1 string in the subset
```

## Core State / Invariant
```text
dp[i][j] = maximum number of strings we can pick from the strings processed so far
using at most i zeros and j ones
```

## Base Case
Initialize the whole table to:
```text
0
```

Reason:
```text
before processing any strings, the best answer is 0
```

## Transition
For a string with `zeros` and `ones`:
```text
dp[i][j] = max(dp[i][j], dp[i - zeros][j - ones] + 1)
```

## Why Both Loops Go Backward
The transition reads:
```text
dp[i - zeros][j - ones]
```

That source state must still belong to:
```text
previous strings only
```

If either capacity loop goes forward, the same string can be reused again in the same iteration.

## Complexity
```text
Time: O(len(strs) * m * n)
Space: O(m * n)
```

## Common Mistakes
- forgetting this is two-capacity, not one-capacity
- saying the value is zeros or ones instead of number of strings chosen
- going forward in one dimension and backward in the other
- omitting `processed so far` from the invariant

## Strong Spoken Explanation
This is a two-capacity `0/1` knapsack. Each string is an item, its cost is `(zeroCount, oneCount)`, and its value is `1` because taking that string increases the answer by one. I use `dp[i][j]` to mean the maximum number of strings I can pick from the strings processed so far using at most `i` zeros and `j` ones. For each string, I count its zeros and ones, then iterate both capacities backward and update `dp[i][j] = max(dp[i][j], dp[i - zeros][j - ones] + 1)`. Both loops must go backward so the current string is only used once.

## Findings

- Keep the state meaning explicit before writing the transition.
- Check base cases and return value before trusting the recurrence.
- Explain why the iteration order or traversal order preserves the intended invariant.

## Encountered Problems

Captured from the learning note; no separate failure note was recorded.
