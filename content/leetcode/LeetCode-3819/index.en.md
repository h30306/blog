---
title: "LeetCode 3819: Rotate Non Negative Elements"
summary: "LeetCode 3819 note: pull out the non-negative values, rotate them left by k, and put them back into the non-negative positions in order; with none, do not take a modulo by 0"
description: "LeetCode 3819 record from 2026-01-25"
date: 2026-01-25
tags: ["medium", "array", "simulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-25
- Submissions: Runtime Error → Accepted

## Approach

Negatives stay put, so only handle non-negatives ([Array]({{< relref "/algorithm/Array" >}}) Template 5): record their positions and values, rotate the values left by `k % m` (`m` non-negatives), and fill the positions back in order.

## My Attempts

Attempt 1 did not handle "no non-negative values": `k % len(non_neg)` took a modulo by 0. For `nums = [-1]`, `k = 2` it raised ZeroDivisionError. Adding the special case passed.

## Solution

```python
class Solution:
    def rotateElements(self, nums: List[int], k: int) -> List[int]:
        idx = [i for i, x in enumerate(nums) if x >= 0]
        if not idx:
            return nums
        vals = [nums[i] for i in idx]
        k %= len(vals)
        vals = vals[k:] + vals[:k]                 # 左旋 k 格
        res = nums[:]
        for i, v in zip(idx, vals):
            res[i] = v
        return res
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Make sure the number of non-negatives is not 0 before taking a modulo.
- Rotating left is `vals[k:] + vals[:k]`.

## Interview Explanation

I extract the non-negative positions and values, rotate the values left by `k`, and put them back in order while negatives stay. With no non-negatives I return the array as is. Time `O(n)`.
