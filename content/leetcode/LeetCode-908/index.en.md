---
title: "LeetCode 908: Smallest Range I"
summary: "LeetCode 908 note: lower the maximum by k and raise the minimum by k; the answer is max(0, max - min - 2k)"
description: "LeetCode 908 record from 2022-09-25"
date: 2022-09-25
tags: ["easy", "array", "math"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-09-25
- Submissions: Wrong Answer ×5 → Accepted

## Approach

Only the maximum and minimum matter ([Math]({{< relref "/algorithm/Math" >}}) Template 4): the maximum can drop by `k` and the minimum rise by `k`, shrinking the gap by up to `2k`; every other value lies between and can follow. The gap cannot go below 0.

## My Attempts

The first four computed `max + min` instead of `max - min`; after fixing that, **a gap larger than `2k` forgot to subtract `2k`**: `[9, 0]`, `k = 3` should be 3; it returned 9.

## Solution

```python
class Solution:
    def smallestRangeI(self, nums: List[int], k: int) -> int:
        return max(0, max(nums) - min(nums) - 2 * k)
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Take the maximum minus the minimum, then subtract `2k`.

## Interview Explanation

Only the extremes matter: the maximum drops by k and the minimum rises by k, so the gap shrinks by up to 2k but not below 0. Time `O(n)`.
