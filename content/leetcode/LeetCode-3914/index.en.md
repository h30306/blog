---
title: "LeetCode 3914: Minimum Operations to Make Array Non Decreasing"
summary: "LeetCode 3914 note: adding x to a range raises only the difference at its left edge by x, so the answer is the sum of all drops"
description: "LeetCode 3914 record from 2026-04-26"
date: 2026-04-26
tags: ["medium", "greedy", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-04-26
- Submissions: Accepted (first try)

## Approach

Look at adjacent differences `d[i] = nums[i] - nums[i - 1]`; the goal is every `d[i] >= 0`. Adding `x` to `[l, r]`:

- raises `d[l]` by `x` (if `l > 0`),
- lowers `d[r + 1]` by `x` (if `r + 1 < n`),
- leaves the differences in between unchanged.

So one operation raises at most **one** difference by `x`. Each drop `nums[i - 1] - nums[i] > 0` needs at least that much, and their sum is a lower bound. Adding to the suffix `[i, n - 1]` fixes exactly `d[i]` without breaking anything, reaching the bound. This is [Greedy]({{< relref "/algorithm/Greedy" >}}) Template 5.

## My Solution

```python
class Solution:
    def minOperations(self, nums: List[int]) -> int:
        return sum(max(0, nums[i - 1] - nums[i]) for i in range(1, len(nums)))
```

I originally accumulated the drops right to left in a while loop, which is the same thing.

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- No need to simulate the additions; adjacent differences give the answer directly.

## Interview Explanation

Adding `x` to a range only raises the difference at its left edge by `x`, so each drop costs at least its size. Adding to a suffix fixes exactly one drop, so the answer is the sum of all drops. Time `O(n)`.
