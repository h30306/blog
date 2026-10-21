---
title: "LeetCode 18: 4Sum"
summary: "LeetCode 18 note: sort, fix the first two numbers with two loops, and converge pointers for the rest, skipping equal values at all four positions"
description: "LeetCode 18 record from 2022-10-20"
date: 2022-10-20
tags: ["medium", "array", "two-pointers", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-10-20
- Submissions: Runtime Error ×9 → Wrong Answer ×9 → Accepted ×3 → Wrong Answer → Accepted ×2

## Approach

Wrap 3sum in one more loop ([Two Pointers]({{< relref "/algorithm/Two-Pointers" >}}) Template 1): `i` and `j` fix the first two, and `l`, `r` converge on the last two. Deduplicate as in 3sum: skip `i` and `j` equal to their predecessors, and skip equal `l` values after a match.

## My Attempts

This took 24 submissions in 2022:

- The first ten REs were mostly undefined variables, `None` access, or out-of-range indices.
- The later WAs were all about deduplication: not skipping equal values after a match, so `[2, 1, 3, -2, 1]`, `target = 4` returned `[-2, 1, 2, 3]` twice; one skipped too much, finding nothing for `[1, -1, 3, 0]`, `target = 3`.

## Solution

```python
class Solution:
    def fourSum(self, nums: List[int], target: int) -> List[List[int]]:
        nums.sort()
        n, res = len(nums), []
        for i in range(n - 3):
            if i and nums[i] == nums[i - 1]:
                continue
            for j in range(i + 1, n - 2):
                if j > i + 1 and nums[j] == nums[j - 1]:
                    continue
                l, r = j + 1, n - 1
                while l < r:
                    s = nums[i] + nums[j] + nums[l] + nums[r]
                    if s < target:
                        l += 1
                    elif s > target:
                        r -= 1
                    else:
                        res.append([nums[i], nums[j], nums[l], nums[r]])
                        l += 1
                        while l < r and nums[l] == nums[l - 1]:
                            l += 1
                        r -= 1
        return res
```

## Complexity

Time `O(n³)`, space `O(1)` besides the output.

## Mistakes to Avoid

- `j`'s dedup condition is `j > i + 1`, not `j > 0`, or valid quadruplets get skipped.

## Interview Explanation

After sorting, two loops fix the first two numbers and converging pointers find the last two, skipping equal values at every position. Time `O(n³)`.
