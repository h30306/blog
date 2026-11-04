---
title: "LeetCode 1011: Capacity To Ship Packages Within D Days"
summary: "LeetCode 1011 note: binary search on the answer over [max(weights), sum(weights)], checking the day count by filling greedily in order"
description: "LeetCode 1011 record from 2026-11-03"
date: 2026-11-03
tags: ["medium", "array", "binary-search"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-11-03
- Submissions: Accepted (first try)

## Approach

A larger capacity needs fewer days, which is monotone, so binary search on the answer ([Binary Search]({{< relref "/algorithm/Binary-Search" >}}) Template 2):
- **The lower bound is `max(weights)`**: packages cannot be split, so a capacity below the heaviest one can never work.
- **The upper bound is `sum(weights)`**: everything ships in one day.
- **Check**: load in order and start a new day when the next package does not fit, then compare the day count with `days`.

We want the smallest feasible capacity.

## My Attempts

Accepted on the first try. Written the same day as LC 875 with the same closed-interval template: `right = mid - 1` when feasible, otherwise `left = mid + 1`, and return `left`.

## Solution

```python
class Solution:
    def shipWithinDays(self, weights: List[int], days: int) -> int:
        def valid(cap):
            need, curr = 1, 0
            for w in weights:
                if curr + w <= cap:
                    curr += w
                else:                 # does not fit, start a new day
                    need += 1
                    curr = w
            return need <= days

        left, right = max(weights), sum(weights)
        while left <= right:
            mid = (left + right) // 2
            if valid(mid):
                right = mid - 1
            else:
                left = mid + 1
        return left
```

## Complexity

Time `O(n log S)` where `S` is `sum(weights)`; space `O(1)`.

## Mistakes to Avoid

- A lower bound of 1: `valid` never checks whether a single package exceeds the capacity, so starting a new day counts as fitting. `weights = [1, 5]`, `days = 2` returns 1; the answer is 5. Starting at `max(weights)` makes that check unnecessary.
- Count days from 1; the first day counts.

## Interview Explanation

More capacity means fewer days, so I binary search on the answer. The lower bound is the heaviest package because packages cannot be split, and the upper bound is the total weight, which ships in one day. To check a capacity I load packages in order and start a new day when one does not fit, then compare with the limit. I look for the smallest feasible capacity. Time `O(n log S)`, space `O(1)`.
