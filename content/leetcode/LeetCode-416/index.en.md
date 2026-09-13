---
title: "LeetCode 416: Partition Equal Subset Sum"
summary: "LeetCode Problem Solving - 0/1 knapsack / subset-sum reachability"
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
Source Note: `notes/day43-week8-day1-partition-coin-change-replication-lag.md`

## Intuition

I first reduce the problem to whether some subset reaches total / 2, because equal partition means both sides must sum the same. Then I use 0/1 subsetsum DP where dp[s] means whether the processed numbers can make sum s.

Pattern: `0/1` knapsack / subset-sum reachability

## Approach

- **Pattern:** `0/1` knapsack / subset-sum reachability

## Why This Fits
Each number can be used:
```text
either once or not at all
```

The question becomes:
```text
can I reach total / 2?
```

That is classic `0/1` subset selection.

## Core State / Invariant
2D form:
```text
dp[i][s] = whether some subset from the first i numbers can make sum s
```

Compressed form:
```text
dp[s] = whether the numbers processed so far can make sum s
```

## Base Case
```text
dp[0] = true
```

Reason:
```text
choosing nothing always makes sum 0
```

## Transition
For each `num`:
```text
dp[s] = dp[s] or dp[s - num]
```

when:
```text
s >= num
```

## Why Loop Direction Matters
In 1D compression, iterate `s` backward:
```text
for s from target down to num
```

Reason:
```text
backward iteration prevents the current number from being reused in the same round
```

## Complexity
```text
Time: O(n * target)
Space: O(target)
```

## Common Mistakes
- forgetting the odd-total early exit
- iterating `s` forward and accidentally reusing one number in the same round
- saying `dp[s]` is a best value instead of a reachable-state boolean
- failing to explain why `dp[0] = true`

## Strong Spoken Explanation
I first reduce the problem to whether some subset reaches `total / 2`, because equal partition means both sides must sum the same. Then I use `0/1` subset-sum DP where `dp[s]` means whether the processed numbers can make sum `s`. The base case is `dp[0] = true`, since choosing nothing makes sum zero. For each number I update the target sum backward so the current number is used at most once. If `dp[target]` is true at the end, an equal partition exists.

## Findings

- Keep the state meaning explicit before writing the transition.
- Check base cases and return value before trusting the recurrence.
- Explain why the iteration order or traversal order preserves the intended invariant.

## Encountered Problems

Captured from the learning note; no separate failure note was recorded.
