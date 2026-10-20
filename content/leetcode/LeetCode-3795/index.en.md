---
title: "LeetCode 3795: Minimum Subarray Length With Distinct Sum At Least K"
summary: "LeetCode 3795 note: a shortest-window slide where each value counts once; track each value's last position, and subtract the left value only if it was the last occurrence"
description: "LeetCode 3795 record from 2026-01-03"
date: 2026-01-03
tags: ["medium", "sliding-window", "hash-table", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-03
- Submissions: Wrong Answer → Accepted

## Approach

All values are positive, so the sum of distinct values never decreases as the window grows, which allows the "shortest" variable window: update the answer while valid, then try shrinking the left.

The catch is that **a value appearing several times in the window counts once**:

- `last[x]` records the **last position** of value `x` in the window. When adding `x`, add it to the sum only if `x` is not in `last`.
- When `nums[left]` leaves, subtract and delete it only if `last[nums[left]] == left` (it was the last copy in the window); otherwise another copy remains on the right and the sum is unchanged.

## My Attempts

Attempt 1 used a plain sum without handling duplicates. For `nums = [4, 4]`, `k = 7`, the distinct sum is at most 4, so the answer is -1; adding both 4s gave 8 and it returned 2.

## Solution

```python
class Solution:
    def minLength(self, nums: List[int], k: int) -> int:
        last = {}                                  # value -> last position in the window
        total = left = 0
        best = float("inf")
        for right, x in enumerate(nums):
            if x not in last:
                total += x
            last[x] = right
            while total >= k:
                best = min(best, right - left + 1)
                if last[nums[left]] == left:       # no other copy of nums[left] in the window
                    total -= nums[left]
                    del last[nums[left]]
                left += 1
        return best if best < float("inf") else -1
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- A plain sum counts duplicates many times.
- When the left value leaves, another copy may remain on the right, so it cannot always be subtracted.

## Interview Explanation

Values are positive, so a larger window has a larger distinct sum, which fits a shortest-window slide. Duplicates count once: I track each value's last position in the window, adding a value to the sum only on its first appearance, and when the left value leaves I subtract it only if it was the last copy in the window. Time `O(n)`.
