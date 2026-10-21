---
title: "LeetCode 3131: Find the Integer Added to Array I"
summary: "LeetCode 3131 note: every element gets the same x, so x is the difference of the two minimums (or of the sums divided by the length)"
description: "LeetCode 3131 record from 2024-04-28"
date: 2024-04-28
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
First Attempt: 2024-04-28
- Submissions: Runtime Error → Wrong Answer → Accepted

## Approach

Adding the same `x` to every element of `nums1` gives `nums2` (possibly reordered), so the minimums also differ by `x`: `x = min(nums2) - min(nums1)`. The difference of sums divided by the length also works, with integer division.

## My Attempts

Attempt 1 had a wrong variable name (NameError); attempt 2 divided the sum difference by the length with `/`, **returning the float** `5.0`, judged wrong. Wrapping it in `int` passed.

## Solution

```python
class Solution:
    def addedInteger(self, nums1: List[int], nums2: List[int]) -> int:
        return min(nums2) - min(nums1)
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- `/` produces a float; the answer must be an integer.

## Interview Explanation

Since every element gains the same x, the two minimums differ by exactly x, so I return their difference. Time `O(n)`.
