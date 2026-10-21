---
title: "LeetCode 26: Remove Duplicates from Sorted Array"
summary: "LeetCode 26 note: overwrite in place with a write pointer for the next slot, writing only values different from the last one written"
description: "LeetCode 26 record from 2020-01-30"
date: 2020-01-30
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
First Attempt: 2020-01-30
- Submissions: Compile Error → Output Limit Exceeded → Accepted → Runtime Error ×5 → Wrong Answer ×2 → Runtime Error → Wrong Answer → Accepted → Runtime Error → Wrong Answer → Runtime Error ×3 → Accepted ×2

## Approach

Sorted, so duplicates are adjacent. Keep a write pointer `k` ([Two Pointers]({{< relref "/algorithm/Two-Pointers" >}}) Template 5): for each number, write it to `nums[k]` and advance only if it differs from the last written `nums[k - 1]`. Return `k`; the first `k` slots hold the distinct values.

## My Attempts

This was among my first problems in 2020 and 2022, and most early errors came from misreading what was asked: returning a tuple or a new list, or computing `k` as the number of duplicates rather than the number kept. One later version had the wrong write condition and did not skip duplicates: `[2, 2, 4]` kept `[2, 2]`.

## Solution

```python
class Solution:
    def removeDuplicates(self, nums: List[int]) -> int:
        k = 1
        for x in nums[1:]:
            if x != nums[k - 1]:
                nums[k] = x
                k += 1
        return k
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Modify the array **in place** and return the length, not a new list.

## Interview Explanation

With a sorted array, a write pointer copies a value forward only when it differs from the last written one, and I return the count written. Time `O(n)`, space `O(1)`.
