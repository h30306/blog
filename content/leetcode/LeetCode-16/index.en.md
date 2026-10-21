---
title: "LeetCode 16: 3Sum Closest"
summary: "LeetCode 16 note: sort, fix one number, and find the other two with converging pointers, comparing the distance abs(sum - target)"
description: "LeetCode 16 record from 2022-10-20"
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
- Submissions: Wrong Answer ×2 → Accepted → Wrong Answer ×2 → Accepted ×2

## Approach

Fix `nums[i]` and converge two pointers as in 3sum ([Two Pointers]({{< relref "/algorithm/Two-Pointers" >}}) Template 1), updating the closest sum by `abs(s - target)` for each triple. A sum below the target moves `l` right, above it moves `r` left, and an exact match returns immediately.

## My Attempts

Attempt 1 had three bugs: the first number was negated (left over from 3sum), distances were compared without `abs`, and pointer moves looked only at two numbers: `[1, 1, 4]`, `target = 1` did not return 6. A November 2022 rewrite failed twice more, both times comparing distances wrongly.

## Solution

```python
class Solution:
    def threeSumClosest(self, nums: List[int], target: int) -> int:
        nums.sort()
        best = nums[0] + nums[1] + nums[2]
        for i in range(len(nums) - 2):
            l, r = i + 1, len(nums) - 1
            while l < r:
                s = nums[i] + nums[l] + nums[r]
                if abs(s - target) < abs(best - target):
                    best = s
                if s < target:
                    l += 1
                elif s > target:
                    r -= 1
                else:
                    return s
        return best
```

## Complexity

Time `O(n²)`, space `O(1)`.

## Mistakes to Avoid

- Compare absolute distances; without `abs`, a sum far below the target looks closer.
- Move pointers based on the whole triple sum, not just two of the numbers.

## Interview Explanation

After sorting I fix one number and move two pointers for the others, updating the answer by distance to the target; too small moves left inward, too large moves right inward, equal returns. Time `O(n²)`.
