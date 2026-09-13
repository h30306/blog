---
title: "LeetCode 740: Delete and Earn"
summary: "LeetCode Problem Solving - Value bucketing -> House Robber"
description: "LeetCode study note from 2026-04-25"
date: 2026-04-25
tags: ["leetcode", "medium", "dynamic-programming"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-04-25
Source Note: `notes/day11-week3-day3-delete-and-earn-cert-validation.md`

## Intuition

I group equal values first, because taking a value deletes only its neighboring values, not neighboring positions in the original array. I build points[x] as the total points from taking all xs. After that, the problem b

Pattern: Value bucketing -> House Robber

## Approach

- **Pattern:** Value bucketing -> House Robber.
- **Key insight:** The conflict is between values `x`, `x - 1`, and `x + 1`, not between original array positions.

## Why House Robber
If I take value `x`, I cannot take `x - 1` or `x + 1`.

That is the same shape as:
```text
take current bucket -> skip adjacent bucket
skip current bucket -> keep previous answer
```

So first convert:
```text
points[x] = x * frequency(x)
```

Then solve House Robber on the `points` array.

## State
```text
dp[i] = maximum points we can earn using values from 0 to i
```

## Base Case
```text
dp[0] = 0
dp[1] = points[1]
```

## Transition
```text
dp[i] = max(dp[i - 1], dp[i - 2] + points[i])
```

## Complexity
```text
Time: O(n + m)
Space: O(m)
```

Where:
```text
n = len(nums)
m = max(nums)
```

## Interview-Ready Explanation
I group equal values first, because taking a value deletes only its neighboring values, not neighboring positions in the original array. I build `points[x]` as the total points from taking all `x`s. After that, the problem becomes House Robber on values: if I take `x`, I cannot take `x - 1`, so the transition is `max(skip current, take current)`.

## Findings

- Keep the state meaning explicit before writing the transition.
- Check base cases and return value before trusting the recurrence.
- Explain why the iteration order or traversal order preserves the intended invariant.

## Encountered Problems

Completed.
