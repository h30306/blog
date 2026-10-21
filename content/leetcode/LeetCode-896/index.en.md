---
title: "LeetCode 896: Monotonic Array"
summary: "LeetCode 896 note: monotonic means non-increasing or non-decreasing; check both directions, allowing equal neighbors"
description: "LeetCode 896 record from 2022-09-24"
date: 2022-09-24
tags: ["easy", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-09-24
- Submissions: Wrong Answer ×3 → Accepted ×3

## Approach

Monotonic has two directions and is **non-strict** (equal neighbors are fine). In one pass record whether any rise and any fall occur; they cannot both happen ([Array]({{< relref "/algorithm/Array" >}}) Template 1).

## My Attempts

The first two **checked only one direction**: allowing only non-increasing made `[0, 3]` return `False`, and only non-decreasing made `[1, 0]` return `False`. Attempt 3 checked both but with **strict** `<` and `>`: `[0, 0]` returned `False`. Switching to `<=` and `>=` passed.

## Solution

```python
class Solution:
    def isMonotonic(self, nums: List[int]) -> bool:
        up = down = False
        for i in range(1, len(nums)):
            if nums[i] > nums[i - 1]:
                up = True
            elif nums[i] < nums[i - 1]:
                down = True
        return not (up and down)
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Consider both directions.
- Use `<=` and `>=`; equal neighbors keep it monotonic.

## Interview Explanation

In one pass I record whether a rise and a fall occur; the array is monotonic unless both do, and equal neighbors do not matter. Time `O(n)`, space `O(1)`.
