---
title: "LeetCode 611: Valid Triangle Number"
summary: "LeetCode 611 note: sort, fix the longest side k, and use two pointers for the shorter sides; when the sum is large enough every i in between works, adding j - i at once"
description: "LeetCode 611 record from 2022-11-27"
date: 2022-11-27
tags: ["medium", "array", "two-pointers", "binary-search", "greedy"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-11-27
- Submissions: Wrong Answer → Accepted ×2

## Approach

After sorting, a triangle only needs the two shorter sides to exceed the longest ([Two Pointers]({{< relref "/algorithm/Two-Pointers" >}}) Template 4). Fix the longest side `k`, with `i` from 0 and `j` from `k - 1`:

- `nums[i] + nums[j] > nums[k]`: any `i` in `i..j-1` is larger still, so add `j - i` at once and move `j` left.
- Otherwise move `i` right.

## My Attempts

Attempt 1 added `j - 1` (a typo): for `[4, 7, 9]` with `i = 0` and `j = 1` it should add 1 but added 0, returning 0.

## Solution

```python
class Solution:
    def triangleNumber(self, nums: List[int]) -> int:
        nums.sort()
        res = 0
        for k in range(2, len(nums)):
            i, j = 0, k - 1
            while i < j:
                if nums[i] + nums[j] > nums[k]:
                    res += j - i
                    j -= 1
                else:
                    i += 1
        return res
```

## Complexity

Time `O(n²)`, space `O(1)` besides sorting.

## Mistakes to Avoid

- Add `j - i` at a time, not `j - 1`.

## Interview Explanation

After sorting I fix the longest side and move two pointers over the shorter ones: when the sum is large enough every left choice in between works, so I add `j - i` and move right inward; otherwise the left pointer advances. Time `O(n²)`.
