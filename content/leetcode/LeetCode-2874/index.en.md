---
title: "LeetCode 2874: Maximum Value of an Ordered Triplet II"
summary: "LeetCode 2874 note: fix the middle j and take the prefix maximum on the left and the suffix maximum on the right, or scan once tracking the maximum and the best difference"
description: "LeetCode 2874 record from 2025-07-31"
date: 2025-07-31
tags: ["medium", "prefix-sum", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-07-31
- Submissions: Wrong Answer → Output Limit Exceeded → Accepted

## Approach

All numbers are positive, so with the middle `j` fixed, `nums[i]` and `nums[k]` should both be as large as possible ([Prefix Sum]({{< relref "/algorithm/Prefix-Sum" >}}) Template 2):

- `i < j`: the maximum of `nums[0..j-1]`.
- `k > j`: the maximum of `nums[j+1..n-1]`.

A more space-efficient version scans once: at `x`, treat it as `k` and multiply by the best difference `nums[i] - nums[j]` seen so far; then treat it as `j` and update the best difference; finally treat it as `i` and update the maximum. This order guarantees `i < j < k`.

## My Attempts

I used a prefix maximum array and a suffix maximum array built backward. Attempt 1 indexed the suffix array at `n - j - 1`, which is the maximum of `nums[j..]`, **counting `j` itself on the right**. For `[6, 2, 1]` the only triplet gives `(6 - 2) × 1 = 4`; it used `nums[j] = 2` as `k` and returned 8. After fixing it to `n - j - 2`, a leftover debug `print` caused Output Limit Exceeded; removing it passed.

## Solution

```python
class Solution:
    def maximumTripletValue(self, nums: List[int]) -> int:
        res = max_i = max_diff = 0
        for x in nums:
            res = max(res, max_diff * x)          # x as k
            max_diff = max(max_diff, max_i - x)   # x as j
            max_i = max(max_i, x)                 # x as i
        return res
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Index a backward-built suffix array carefully so it excludes `j`.
- In the single pass, use before updating, in the order `k`, `j`, `i`.
- Remove `print` before submitting.

## Interview Explanation

All numbers are positive, so with the middle `j` fixed, both sides should be maximal. I scan once, tracking the running maximum and the best difference `nums[i] - nums[j]`; each number is first used as `k`, then updates the difference as `j`, then the maximum as `i`. Time `O(n)`, space `O(1)`.
