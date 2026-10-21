---
title: "LeetCode 324: Wiggle Sort II"
summary: "LeetCode 324 note: sort, split into a small half and a large half, reverse each, and interleave with small values at even indices and large ones at odd indices"
description: "LeetCode 324 record from 2022-11-17"
date: 2022-11-17
tags: ["medium", "array", "divide-and-conquer", "greedy", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-11-17
- Submissions: Wrong Answer → Runtime Error → Accepted → Wrong Answer

## Approach

`nums[0] < nums[1] > nums[2] < ...` puts small values at even indices and large ones at odd indices. After sorting, the smaller `ceil(n / 2)` go to even indices and the rest to odd ones, but **both halves must be reversed**: in ascending order the end of the small half and the start of the large half may be equal (a repeated median) and they would land next to each other. Reversed, equal medians end up at opposite ends. The `O(n)` time, `O(1)` space follow-up needs quickselect for the median plus a 3-way partition with virtual indices.

## My Attempts

Attempt 1 interleaved in ascending order, **putting the repeated median side by side**: `[2, 4, 1, 2]` sorts to `[1, 2, 2, 4]` and interleaving gives `[1, 2, 2, 4]`, with two adjacent 2s. Reversing both halves fixed it after one slice-length mistake (ValueError).

## Solution

```python
class Solution:
    def wiggleSort(self, nums: List[int]) -> None:
        s = sorted(nums)
        half = (len(nums) + 1) // 2
        nums[::2] = s[:half][::-1]
        nums[1::2] = s[half:][::-1]
```

## Complexity

Time `O(n log n)`, space `O(n)`.

## Mistakes to Avoid

- Reverse both halves, or repeated medians become adjacent.
- The small half holds `ceil(n / 2)` values and goes to even indices.

## Interview Explanation

After sorting I place the smaller half at even indices and the larger half at odd indices, both reversed so repeated medians end up far apart. Time `O(n log n)`; the `O(n)` follow-up uses quickselect and a three-way partition.
