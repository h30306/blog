---
title: "LeetCode 3912: Valid Elements in an Array"
summary: "LeetCode 3912 note: greater than all on the left means greater than the prefix maximum, and likewise for the right with the suffix maximum; scan both ways and output in original order"
description: "LeetCode 3912 record from 2026-04-26"
date: 2026-04-26
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
First Attempt: 2026-04-26
- Submissions: Accepted (first try)

## Approach

"Strictly greater than everything on the left" means "strictly greater than the left maximum" ([Array]({{< relref "/algorithm/Array" >}}) Template 3). Scan left to right marking elements above the prefix maximum, and right to left marking those above the suffix maximum; keep an element if either holds. The first and last elements have nothing to compare against on their side, so they get marked naturally.

## My Solution

```python
class Solution:
    def findValidElements(self, nums: List[int]) -> List[int]:
        n = len(nums)
        valid = [False] * n
        best = float("-inf")
        for i in range(n):
            if nums[i] > best:
                valid[i] = True
            best = max(best, nums[i])
        best = float("-inf")
        for i in range(n - 1, -1, -1):
            if nums[i] > best:
                valid[i] = True
            best = max(best, nums[i])
        return [x for x, ok in zip(nums, valid) if ok]
```

I originally put valid indices in a set and sorted them at the end; a boolean array avoids the sort.

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- It is **strictly** greater; equal to the maximum does not count.
- Output in original order, without listing an element twice.

## Interview Explanation

Greater than everything on the left equals greater than the prefix maximum, so I scan once each way marking valid elements and output them in original order. Time `O(n)`.
