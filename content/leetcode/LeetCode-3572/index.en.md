---
title: "LeetCode 3572: Maximize Y‑Sum by Picking a Triplet of Distinct X‑Values"
summary: "LeetCode 3572 note: keep the largest y for each x, then take the three largest"
description: "LeetCode 3572 record from 2025-06-07"
date: 2025-06-07
tags: ["medium", "greedy", "hash-map", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-06-07
- Submissions: Wrong Answer → Accepted

## Approach

Pick three indices with pairwise different `x` values to maximize the sum of their `y` values.

Greedy: each `x` value can be used at most once, so use its largest `y`:

1. For each `x` value, keep only the largest `y`.
2. If there are fewer than three distinct `x` values, return `-1`.
3. Otherwise, add the three largest `y` values.

## My Attempt: taking the wrong end after sorting

```python
max_number_of_groups.sort()
return sum(max_number_of_groups[:3])     # ascending sort: [:3] is the three smallest
```

After an ascending sort, the first three are the smallest. It should be `[-3:]`.

## Solution

```python
import heapq

class Solution:
    def maxSumDistinctTriplet(self, x: List[int], y: List[int]) -> int:
        best = {}
        for xi, yi in zip(x, y):
            if yi > best.get(xi, 0):
                best[xi] = yi
        if len(best) < 3:
            return -1
        return sum(heapq.nlargest(3, best.values()))
```

`heapq.nlargest(3, ...)` is `O(m)`, slightly faster than sorting the list in `O(m log m)`, and harder to get backwards.

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Taking `[:3]` after an ascending sort.
- Using the same `x` twice.

## Interview Explanation

Each `x` can be chosen only once, so I keep the largest `y` for each `x`. With fewer than three distinct `x` values I return `-1`; otherwise I add the three largest `y` values. One pass with a dict plus `nlargest` for the top three, so time is `O(n)`.
