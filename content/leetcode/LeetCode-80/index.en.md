---
title: "LeetCode 80: Remove Duplicates from Sorted Array II"
summary: "LeetCode 80 note: keep each value at most twice by comparing with nums[k - 2], two slots back from the write position"
description: "LeetCode 80 record from 2022-10-26"
date: 2022-10-26
tags: ["medium", "array", "two-pointers"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-10-26
- Submissions: Wrong Answer ×3 → Runtime Error → Accepted ×4

## Approach

The same write pointer as LC 26 ([Two Pointers]({{< relref "/algorithm/Two-Pointers" >}}) Template 5), allowing two copies. A number `x` may be written when `k < 2` or `x != nums[k - 2]`; equal to the one two slots back means two copies are already written.

## My Attempts

The early versions tracked occurrences with a counter `c` and complicated updates for two pointers `i` and `j`: `[0, 0, 0]` returned 3 instead of 2, and a single element returned 0.

## Solution

```python
class Solution:
    def removeDuplicates(self, nums: List[int]) -> int:
        k = 0
        for x in nums:
            if k < 2 or x != nums[k - 2]:
                nums[k] = x
                k += 1
        return k
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Compare with the **already written** `nums[k - 2]`, not the original `nums[i - 2]` (which may be overwritten).

## Interview Explanation

With at most two copies, a write pointer accepts a number only when it differs from the value two slots back; for at most `m` copies just replace 2 with `m`. Time `O(n)`.
