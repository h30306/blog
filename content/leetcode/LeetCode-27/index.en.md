---
title: "LeetCode 27: Remove Element"
summary: "LeetCode 27 note: the write pointer copies only values not equal to val, returning how many were written"
description: "LeetCode 27 record from 2022-05-11"
date: 2022-05-11
tags: ["easy", "array", "two-pointers"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-05-11
- Submissions: Wrong Answer → Accepted ×3

## Approach

A write pointer `k` ([Two Pointers]({{< relref "/algorithm/Two-Pointers" >}}) Template 5): copy every value not equal to `val` to `nums[k]` and advance. The first `k` slots are what remains; order does not matter.

## My Attempts

Attempt 1 compared `v != nums` (a number against the whole list), always true, so nothing was removed: `[2]`, `val = 2` returned 1.

## Solution

```python
class Solution:
    def removeElement(self, nums: List[int], val: int) -> int:
        k = 0
        for x in nums:
            if x != val:
                nums[k] = x
                k += 1
        return k
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Compare against `val`.

## Interview Explanation

A write pointer copies values not equal to `val` to the front in order, and I return the count. Time `O(n)`, space `O(1)`.
