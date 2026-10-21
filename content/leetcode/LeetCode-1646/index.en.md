---
title: "LeetCode 1646: Get Maximum in Generated Array"
summary: "LeetCode 1646 note: generate by the rules, nums[i // 2] at even i and nums[i // 2] + nums[i // 2 + 1] at odd i, handling n = 0 separately"
description: "LeetCode 1646 record from 2022-11-01"
date: 2022-11-01
tags: ["easy", "array", "simulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-11-01
- Submissions: Runtime Error → Wrong Answer → Accepted → Runtime Error → Wrong Answer → Accepted

## Approach

Simulate ([Array]({{< relref "/algorithm/Array" >}}) Template 5): `nums[0] = 0`, `nums[1] = 1`, then `nums[i] = nums[i // 2]` for even `i` and `nums[i // 2] + nums[i // 2 + 1]` for odd `i`. For `n = 0` the array is just `[0]`, so `nums[1]` must not be set.

## My Attempts

- 2022-11-01: attempt 1 had a one-cell array for `n = 0`, so `res[1] = 1` overran it; with that special case, odd positions used `res[i // 2] + res[i % 2]`, **and `i % 2` is always 1**: `n = 9` should be 4; it returned 3.
- The 2022-11-15 rewrite first wrote `j = i - 1 // 2`; **`//` binds tighter than `-`**, so `j = i`, out of range. After that fix it missed `n = 0` again: the maximum of `[0, 1]` is 1, while the answer is 0.

## Solution

```python
class Solution:
    def getMaximumGenerated(self, n: int) -> int:
        if n == 0:
            return 0
        nums = [0] * (n + 1)
        nums[1] = 1
        for i in range(2, n + 1):
            nums[i] = nums[i // 2] if i % 2 == 0 else nums[i // 2] + nums[i // 2 + 1]
        return max(nums)
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Odd positions use `nums[i // 2 + 1]`, not `nums[i % 2]`.
- `i - 1 // 2` means `i - 0`; write `(i - 1) // 2`.
- For `n = 0` the answer is 0.

## Interview Explanation

I generate up to index n by the rules, half the index for even positions and the sum of half and half plus one for odd ones, then take the maximum; n = 0 returns 0. Time `O(n)`.
