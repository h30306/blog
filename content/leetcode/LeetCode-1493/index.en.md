---
title: "LeetCode 1493: Longest Subarray of 1's After Deleting One Element"
summary: "LeetCode 1493 note: find the longest window with at most one 0; since one element must be deleted, the answer is the window length minus 1"
description: "LeetCode 1493 record from 2025-08-24"
date: 2025-08-24
tags: ["medium", "sliding-window", "dynamic-programming", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-08-24
- Submissions: Accepted ×2

## Approach

A subarray that is all 1s after deleting one element was a subarray with **at most one 0**, and the deleted element is that 0 (or any 1 if there is no 0).

So find the longest window with at most one 0; the answer is **window length − 1**:

- Add elements on the right; shrink the left while there is more than one 0.
- Update with `right - left` (the length minus 1).

All 1s still require one deletion, giving `n - 1`, which this handles naturally.

## My Solution

```python
class Solution:
    def longestSubarray(self, nums: List[int]) -> int:
        left = zeros = best = 0
        for right, x in enumerate(nums):
            zeros += x == 0
            while zeros > 1:
                zeros -= nums[left] == 0
                left += 1
            best = max(best, right - left)         # window length - 1
        return best
```

Both accepted versions were similar; the second had a cleaner `while` condition (the first also checked `nums[right] == 0`).

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Returning the window length instead of length minus 1: one deletion is mandatory.
- With all 1s the answer is `n - 1`, not `n`.

## Interview Explanation

Being all 1s after one deletion means the original subarray had at most one 0. I slide a window that allows at most one 0, shrinking the left when there are two. One element must be deleted, so the answer is the window length minus 1, which also covers the all-1s case. Time `O(n)`.
