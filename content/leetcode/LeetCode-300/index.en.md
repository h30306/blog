---
title: "LeetCode 300: Longest Increasing Subsequence"
summary: "LeetCode Problem Solving - Sequence DP, plus greedy + binary search optimization"
description: "LeetCode study note from 2026-05-01"
date: 2026-05-01
tags: ["medium", "dynamic-programming", "binary-search"]
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

The O(n^2) DP uses dp[i] as the LIS ending at i. The O(n log n) followup keeps the smallest possible tail for each subsequence length and uses binary search to replace tails. A smaller tail is better because it leaves mo

Pattern: Sequence DP, plus greedy + binary search optimization

## Approach

- **Pattern:** Sequence DP, plus greedy + binary search optimization.

## O(n^2) DP

### Why DP Fits
For each index `i`, the LIS ending at `i` depends on earlier indices `j < i` whose values are smaller than `nums[i]`.

### State
```text
dp[i] = length of the longest increasing subsequence ending at index i
```

### Base Case
```text
dp[i] = 1 for every i
```

Reason:
```text
each element alone is an increasing subsequence of length 1
```

### Transition
```text
for each j < i:
    if nums[j] < nums[i]:
        dp[i] = max(dp[i], dp[j] + 1)
```

### Answer
```text
max(dp)
```

### Complexity
```text
Time: O(n^2)
Space: O(n)
```

### Common Mistakes
- saying "choose index i as one of the elements" instead of "ending at i"
- forgetting the answer is global max, not just `dp[-1]`

## O(n log n) Follow-Up

### Core Idea
Keep:
```text
tails[len - 1] = the smallest possible tail value of an increasing subsequence of length len
```

Why smaller tail is better:
```text
for the same subsequence length, a smaller tail gives more future extension options
```

### Update Rule
For each number:
- if it is larger than all tails, append it
- otherwise replace the first tail `>= num`

### Important Nuance
```text
tails is not always the actual LIS sequence
```

But:
```text
len(tails) is the correct LIS length
```

### Complexity
```text
Time: O(n log n)
Space: O(n)
```

## Interview-Ready Explanation
The O(n^2) DP uses `dp[i]` as the LIS ending at `i`. The O(n log n)` follow-up keeps the smallest possible tail for each subsequence length and uses binary search to replace tails. A smaller tail is better because it leaves more room for future extension.

## Findings

- Keep the state meaning explicit before writing the transition.
- Check base cases and return value before trusting the recurrence.
- Explain why the iteration order or traversal order preserves the intended invariant.

## Encountered Problems

Good enough for both `O(n^2)` DP and `O(n log n)` follow-up.
