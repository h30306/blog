---
title: "LeetCode 3075: Maximize Happiness of Selected Children"
summary: "LeetCode 3075 note: choose k children from the happiest, where the i-th choice loses i, floored at 0"
description: "LeetCode 3075 record from 2024-03-10"
date: 2024-03-10
tags: ["medium", "array", "greedy", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2024-03-10
- Submissions: Accepted (first try)

## Approach

Each pick lowers everyone unpicked by 1, so the `i`-th pick (0-based) contributes `max(happiness - i, 0)`. Picking from the largest down maximizes the total ([Greedy]({{< relref "/algorithm/Greedy" >}}) Template 1): large values lose the least, and values stop at 0.

## My Attempts

Passed on the first try during the 2024 contest by sorting and picking from the largest.

## Solution

```python
class Solution:
    def maximumHappinessSum(self, happiness: List[int], k: int) -> int:
        happiness.sort(reverse=True)
        return sum(max(h - i, 0) for i, h in enumerate(happiness[:k]))
```

## Complexity

Time `O(n log n)`, space `O(1)`.

## Mistakes to Avoid

- Values stop at 0 and never go negative.
- The answer may be large, but Python does not overflow.

## Interview Explanation

The i-th pick loses i, so I sort descending, take the first k, and add each value minus i floored at 0. Time `O(n log n)`.
