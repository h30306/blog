---
title: "LeetCode 2779: Maximum Beauty of an Array After Applying Operation"
summary: "LeetCode 2779 note: each number can become anything in [x - k, x + k], so a group can become one value ⇔ max - min <= 2k; sort and find the longest such window"
description: "LeetCode 2779 record from 2026-01-11"
date: 2026-01-11
tags: ["medium", "sliding-window", "sorting", "binary-search", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-11
- Submissions: Time Limit Exceeded → Accepted

## Approach

Each number `x` can become any value in `[x - k, x + k]`. A group can become one value ⇔ their ranges share a common point ⇔ **max − min `<= 2k`**.

The problem asks for a subsequence (not contiguous), so sort first; it becomes "the longest window with `nums[right] - nums[left] <= 2k`".

## My Attempts

Attempt 1 counted every integer in `[x - k, x + k]` for each number and took the maximum, `O(n · k)`, which hit TLE with `k` up to `10^5`.

(That idea can be made `O(n + value range)` with a difference array, but sorting plus a sliding window is more direct.)

## Solution

```python
class Solution:
    def maximumBeauty(self, nums: List[int], k: int) -> int:
        nums.sort()
        left = best = 0
        for right, x in enumerate(nums):
            while x - nums[left] > 2 * k:
                left += 1
            best = max(best, right - left + 1)
        return best
```

## Complexity

Time `O(n log n)`, space `O(1)` apart from sorting.

## Mistakes to Avoid

- Counting every integer in each range: `O(n · k)`.
- The bound is `2k`, not `k`: both ends can move `k` toward each other.

## Interview Explanation

Each number can become anything within `k` of itself, so a group can be made equal when max minus min is at most `2k`. The problem wants a subsequence, so I sort and use a sliding window for the longest stretch with max minus min `<= 2k`. Time `O(n log n)`.
