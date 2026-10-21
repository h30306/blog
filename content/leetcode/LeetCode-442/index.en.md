---
title: "LeetCode 442: Find All Duplicates in an Array"
summary: "LeetCode 442 note: values are in 1..n, so mark v with the sign of nums[v-1]; on the second visit it is already negative"
description: "LeetCode 442 record from 2026-01-31"
date: 2026-01-31
tags: ["medium", "hash-table", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-31
- Submissions: Time Limit Exceeded ×2 → Accepted

## Approach

Values are in `1..n`, so `nums[v - 1]` can serve as the "seen" flag for `v` ([Hash Table]({{< relref "/algorithm/Hash-Table" >}}) Template 2):

- The first time `v` appears, make `nums[v - 1]` negative.
- When `v` appears again, `nums[v - 1]` is already negative, so `v` is a duplicate.

Read values with `abs`, since a value may already have been negated by another number.

## My Attempts

The first two versions checked `-num in nums`; **`in` on a list is `O(n)`**, making it `O(n²)`, TLE. Looking up by index directly passed.

## Solution

```python
class Solution:
    def findDuplicates(self, nums: List[int]) -> List[int]:
        res = []
        for x in nums:
            i = abs(x) - 1
            if nums[i] < 0:
                res.append(abs(x))
            else:
                nums[i] = -nums[i]
        return res
```

## Complexity

Time `O(n)`, extra space `O(1)` besides the output.

## Mistakes to Avoid

- `in` on a list is a linear search.
- Read values with `abs`.

## Interview Explanation

With values in 1 to `n`, I use the sign of `nums[v - 1]` to record whether `v` has appeared. The first visit negates it; on the second it is already negative, so `v` goes into the answer. Time `O(n)`, extra space `O(1)`.
