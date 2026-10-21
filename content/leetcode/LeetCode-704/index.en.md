---
title: "LeetCode 704: Binary Search"
summary: "LeetCode 704 note: a closed interval [l, r] with an integer mid; return on a match, otherwise discard the half that cannot contain the target"
description: "LeetCode 704 record from 2022-08-31"
date: 2022-08-31
tags: ["easy", "array", "binary-search"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-31
- Submissions: Accepted → Runtime Error ×3 → Accepted ×2 → Runtime Error → Accepted ×3

## Approach

Standard binary search ([Binary Search]({{< relref "/algorithm/Binary-Search" >}}) Template 1). With a closed interval `[l, r]` and `while l <= r`: if `nums[mid]` is too small set `l = mid + 1`, if too large `r = mid - 1`.

## My Attempts

The REs came from `mid = (l + r) / 2` producing a float used as an index (TypeError), or bounds stepping out of range.

## Solution

```python
class Solution:
    def search(self, nums: List[int], target: int) -> int:
        l, r = 0, len(nums) - 1
        while l <= r:
            mid = (l + r) // 2
            if nums[mid] == target:
                return mid
            if nums[mid] < target:
                l = mid + 1
            else:
                r = mid - 1
        return -1
```

## Complexity

Time `O(log n)`, space `O(1)`.

## Mistakes to Avoid

- In Python 3 `/` gives a float; indices need `//`.
- A closed interval goes with `while l <= r` and `mid ± 1`.

## Interview Explanation

With a closed interval, I move the left bound to `mid + 1` when `mid` is too small and the right bound to `mid - 1` when too large, returning on a match. Time `O(log n)`.
