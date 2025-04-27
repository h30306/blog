---
title: "LeetCode 2145: Count the Hidden Sequences"
summary: "LeetCode Problem Solving"
description: "LeetCode Daily"
date: 2025-04-21
tags: ["LeetCode", "blog", "daily", "medium"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium  
First Attempt: 2025-04-21  
- Total time: 20:00.00  

## Intuition

The possible hidden sequences should fall within the range defined by `minK` and `maxK`.  
Thus, we can iterate through the `differences` array to track the running total (`now`), and record the minimum and maximum prefix sums.  
The hidden sequence count will depend on how we can shift this range within `[lower, upper]`.

## Approach

```python
class Solution:
    def numberOfArrays(self, differences: List[int], lower: int, upper: int) -> int:
        min_, max_ = 0, 0
        now = 0
        for diff in differences:
            now += diff
            min_ = min(now, min_)
            max_ = max(now, max_)
            if max_ - min_ > upper - lower:
                return 0

        bound = max_ - min_

        return upper - lower - bound + 1
```

## Findings

N/A

## Encountered Problems

At first, I initialized `min_` and `max_` with `float("inf")` and `float("-inf")`, respectively.  
I thought that after iterating through all elements in `differences`, I could correctly capture the true minimum and maximum values.  
However, I forgot about the edge case where `differences` contains only one element.  
For example, with `differences = [-40]`, both `min_` and `max_` would become `-40` — but since it's a difference array, the correct range should be from `0` to `-40`.  
Thus, I rewrote the initialization to `min_ = max_ = 0` to correctly handle such cases.