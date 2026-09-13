---
title: "LeetCode 152: Maximum Product Subarray"
summary: "LeetCode Problem Solving - Rolling DP with max/min state"
description: "LeetCode study note from 2026-05-01"
date: 2026-05-01
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
First Attempt: 2026-05-01
Source Note: `notes/day17-week4-day3-max-product-lis-pagination.md`

## Intuition

I track both the maximum and minimum product ending at each index, because multiplying by a negative can swap their roles. At each number, I either start a new subarray or extend the previous max/min product. I keep a se

Pattern: Rolling DP with max/min state

## Approach

- **Pattern:** Rolling DP with max/min state.

## Why DP Fits
Product behaves differently from sum because a negative number can flip:
- a very small negative product into the new maximum
- a previous maximum into the new minimum

So one rolling state is not enough.

## State
```text
cur_max = maximum product of a subarray ending at current index
cur_min = minimum product of a subarray ending at current index
```

Important nuance:
```text
"max" and "min" are value-based, not sign-based labels
```

## Base Case
```text
cur_max = cur_min = nums[0]
answer = nums[0]
```

## Transition
For current number `x`, compute from:
- `x`
- previous `cur_max * x`
- previous `cur_min * x`

So:
```text
new_max = max(x, cur_max * x, cur_min * x)
new_min = min(x, cur_max * x, cur_min * x)
```

Then:
```text
cur_max = new_max
cur_min = new_min
answer = max(answer, cur_max)
```

## Complexity
```text
Time: O(n)
Space: O(1)
```

## Common Mistakes
- tracking only one running product
- forgetting that the DP boundary is "ending at i"
- returning the final `cur_max` instead of a global answer

## Interview-Ready Explanation
I track both the maximum and minimum product ending at each index, because multiplying by a negative can swap their roles. At each number, I either start a new subarray or extend the previous max/min product. I keep a separate global answer because the best subarray may end before the last index.

## Findings

- Keep the state meaning explicit before writing the transition.
- Check base cases and return value before trusting the recurrence.
- Explain why the iteration order or traversal order preserves the intended invariant.

## Encountered Problems

Good enough.
