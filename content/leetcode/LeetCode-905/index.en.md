---
title: "LeetCode 905: Sort Array By Parity"
summary: "LeetCode 905 note: a write pointer swaps even numbers to the front, just like move zeroes"
description: "LeetCode 905 record from 2022-09-25"
date: 2022-09-25
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
First Attempt: 2022-09-25
- Submissions: Wrong Answer → Accepted ×2 → Runtime Error → Accepted ×3

## Approach

The same as LC 283 ([Two Pointers]({{< relref "/algorithm/Two-Pointers" >}}) Template 5): `left` is where the next even number goes, swapping each even number forward.

## My Attempts

Attempt 1 did not return the array; attempt 2 used an undefined variable.

## Solution

```python
class Solution:
    def sortArrayByParity(self, nums: List[int]) -> List[int]:
        left = 0
        for right in range(len(nums)):
            if nums[right] % 2 == 0:
                nums[left], nums[right] = nums[right], nums[left]
                left += 1
        return nums
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- This problem returns the array.

## Interview Explanation

A write pointer swaps evens to the front in order, leaving odds behind. Time `O(n)`, space `O(1)`.
