---
title: "LeetCode 283: Move Zeroes"
summary: "LeetCode 283 note: the write pointer advances only on non-zero values, swapping with them, which pushes zeros to the back"
description: "LeetCode 283 record from 2022-08-23"
date: 2022-08-23
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
First Attempt: 2022-08-23
- Submissions: Accepted ×2 → Wrong Answer ×2 → Accepted ×2

## Approach

`left` is where the next non-zero value goes ([Two Pointers]({{< relref "/algorithm/Two-Pointers" >}}) Template 5). On a non-zero `nums[right]`, swap it with `nums[left]` and advance `left`. Non-zero values keep their order and zeros end up at the back.

## My Attempts

It passed in 2022; a 2025 rewrite placed `left += 1` outside the `if`, advancing every step, so nothing moved: `[0, 1]` stayed `[0, 1]`.

## Solution

```python
class Solution:
    def moveZeroes(self, nums: List[int]) -> None:
        left = 0
        for right in range(len(nums)):
            if nums[right] != 0:
                nums[left], nums[right] = nums[right], nums[left]
                left += 1
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- `left += 1` belongs inside the `if`, advancing only after writing a non-zero value.

## Interview Explanation

`left` marks where the next non-zero value goes; each non-zero value is swapped there and `left` advances, pushing zeros back. Time `O(n)`, space `O(1)`.
