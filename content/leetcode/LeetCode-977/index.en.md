---
title: "LeetCode 977: Squares of a Sorted Array"
summary: "LeetCode 977 note: the largest squares are at the two ends, so compare the ends with two pointers and fill the result from the back"
description: "LeetCode 977 record from 2022-09-26"
date: 2022-09-26
tags: ["easy", "array", "two-pointers", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-09-26
- Submissions: Wrong Answer → Accepted ×3

## Approach

Negatives scramble the order after squaring, but **the largest square is always at one of the ends** ([Two Pointers]({{< relref "/algorithm/Two-Pointers" >}}) Template 1). Compare the squares at both ends and place the larger at the back of the result, moving inward.

## My Attempts

Attempt 1 wrote `[...].sort()`; `sort()` works in place and returns `None`, so the function returned `None`.

## Solution

```python
class Solution:
    def sortedSquares(self, nums: List[int]) -> List[int]:
        n = len(nums)
        res = [0] * n
        l, r = 0, n - 1
        for k in range(n - 1, -1, -1):
            if abs(nums[l]) > abs(nums[r]):
                res[k] = nums[l] * nums[l]
                l += 1
            else:
                res[k] = nums[r] * nums[r]
                r -= 1
        return res
```

## Complexity

Time `O(n)`, space `O(n)` for the output.

## Mistakes to Avoid

- `list.sort()` sorts in place and returns `None`; use `sorted()` to get a list back.

## Interview Explanation

The largest square sits at an end, so two pointers compare absolute values and write the larger square from the back of the result. Time `O(n)`.
