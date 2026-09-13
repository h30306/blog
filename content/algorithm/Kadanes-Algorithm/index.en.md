---
title: "Kadane's Algorithm"
summary: "Maximum subarray DP with an ending-here invariant"
description: "Algorithm Learning"
date: 2025-07-25
tags: ["kadane", "dynamic-programming", "array"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Introduction

Kadane's Algorithm solves the maximum subarray problem in linear time. The important idea is not just "keep a running sum"; it is to define a precise DP state:

```text
curr = maximum subarray sum ending at the current index
best = maximum subarray sum seen anywhere so far
```

This ending-here invariant is what makes the algorithm safe on arrays with negative numbers.

## Core Idea

At each value `x`, the best subarray ending here has only two choices:

- start a new subarray at `x`
- extend the previous best subarray ending at the previous index

So the recurrence is:

```text
curr = max(x, curr + x)
best = max(best, curr)
```

Initialize both values from `nums[0]`, not from `0`, because the answer may be negative.

## Template

```python
from typing import List

def max_subarray(nums: List[int]) -> int:
    curr = best = nums[0]

    for x in nums[1:]:
        curr = max(x, curr + x)
        best = max(best, curr)

    return best
```

### Explanation of the Key Parameters

- `curr`: best sum of a subarray that must end at the current element.
- `best`: best sum found globally.
- `max(x, curr + x)`: choose between restarting and extending.

## Common Mistakes

- Initializing `curr` or `best` to `0`, which breaks all-negative arrays.
- Returning `curr` instead of `best`.
- Describing `curr` vaguely as "current sum" instead of the maximum sum ending here.

## Examples

For:

```text
nums = [-2,1,-3,4,-1,2,1,-5,4]
```

The best subarray is:

```text
[4, -1, 2, 1]
```

with sum:

```text
6
```

## Related LeetCode

- `LC 53` Maximum Subarray
- `LC 152` Maximum Product Subarray, which needs both max-ending-here and min-ending-here because negative values can flip the sign.
