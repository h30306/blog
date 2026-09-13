---
title: "LeetCode 213: House Robber II"
summary: "LeetCode Problem Solving - Circular array -> split into two linear robber problems"
description: "LeetCode study note from 2026-04-25"
date: 2026-04-25
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
First Attempt: 2026-04-25
Source Note: `notes/day11-week3-day3-delete-and-earn-cert-validation.md`

## Intuition

Because the houses are arranged in a circle, the first and last houses are adjacent, so I cannot rob both. I split the problem into two linear House Robber I cases: rob nums[:1] or rob nums[1:], then take the maximum of

Pattern: Circular array -> split into two linear robber problems

## Approach

- **Pattern:** Circular array -> split into two linear robber problems.

## Key Constraint
```text
first house and last house are adjacent
```

So a valid answer must be one of:
```text
exclude last house
exclude first house
```

## Interview-Ready Explanation
Because the houses are arranged in a circle, the first and last houses are adjacent, so I cannot rob both. I split the problem into two linear House Robber I cases: rob `nums[:-1]` or rob `nums[1:]`, then take the maximum of those two answers.

## Findings

- Keep the state meaning explicit before writing the transition.
- Check base cases and return value before trusting the recurrence.
- Explain why the iteration order or traversal order preserves the intended invariant.

## Encountered Problems

Good enough.
