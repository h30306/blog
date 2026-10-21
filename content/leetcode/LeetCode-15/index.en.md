---
title: "LeetCode 15: 3Sum"
summary: "LeetCode 15 note: sort, fix the first number, and find the other two with converging pointers, skipping equal values at all three positions to avoid duplicate triplets"
description: "LeetCode 15 record from 2022-10-20"
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
- Submissions: Runtime Error ×2 → Wrong Answer ×2 → Runtime Error ×3 → Time Limit Exceeded ×2 → Runtime Error → Accepted → Wrong Answer → Time Limit Exceeded ×4 → Runtime Error → Wrong Answer → Accepted → Runtime Error → Wrong Answer ×3 → Memory Limit Exceeded → Time Limit Exceeded ×4 → Accepted → Wrong Answer ×2 → Accepted ×2 → Wrong Answer → Accepted ×2

## Approach

After sorting, fix `nums[i]` and use converging pointers over `i + 1..end` to find two numbers summing to `-nums[i]` ([Two Pointers]({{< relref "/algorithm/Two-Pointers" >}}) Template 1). Deduplicate in three places:

- Skip `nums[i]` equal to the previous one.
- After a match, skip equal values at both `left` and `right`.

## My Attempts

This took 36 submissions, the most in this batch:

- At first the pointers started at 0 and the end, straddling `i`, which searched the wrong range and kept producing duplicates: `[2, -2, 0, 0]` returned `[-2, 0, 2]` twice.
- Versions deduplicating with sets or triple loops hit TLE / MLE.
- Late October 2022 versions did not skip equal values after a match: `[4, -2, -2, 4]` returned `[-2, -2, 4]` twice; adding the dedup finally passed on October 31. The 2026 rewrite got it right in one go.

## Solution

```python
class Solution:
    def threeSum(self, nums: List[int]) -> List[List[int]]:
        nums.sort()
        n, res = len(nums), []
        for i in range(n - 2):
            if i and nums[i] == nums[i - 1]:
                continue
            l, r = i + 1, n - 1
            while l < r:
                s = nums[i] + nums[l] + nums[r]
                if s < 0:
                    l += 1
                elif s > 0:
                    r -= 1
                else:
                    res.append([nums[i], nums[l], nums[r]])
                    l += 1
                    while l < r and nums[l] == nums[l - 1]:
                        l += 1
                    r -= 1
        return res
```

## Complexity

Time `O(n²)`, space `O(1)` besides sorting and the output.

## Mistakes to Avoid

- After a match skip equal values, or the same triplet is added repeatedly.
- The second and third numbers range from `i + 1`, not from 0.

## Interview Explanation

After sorting I fix the first number and close in from both ends for the other two, skipping equal values at the first position and after each match so nothing repeats. Time `O(n²)`.
