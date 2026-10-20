---
title: "LeetCode 2401: Longest Nice Subarray"
summary: "LeetCode 2401 note: pairwise AND 0 ⇔ each bit is used by at most one number; a mask holds the window's bits, and on a conflict the left shrinks and its bits are removed"
description: "LeetCode 2401 record from 2026-01-22"
date: 2026-01-22
tags: ["medium", "sliding-window", "bit-manipulation", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-22
- Submissions: Accepted (first try)

## Approach

Every pair in the window ANDs to 0 ⇔ **each bit is used by at most one number**. So one integer `used` holds the OR of the window:

- If the new number `x` overlaps `used` (`used & x != 0`), shrink the left until it does not.
- When `nums[left]` leaves, its bits belong to it alone, so `used ^= nums[left]` (or `&= ~`) removes them.
- Add `x`: `used |= x`.

Numbers have at most 30 bits, so a valid window has at most 30 elements.

## My Solution

```python
class Solution:
    def longestNiceSubarray(self, nums: List[int]) -> int:
        used = left = best = 0
        for right, x in enumerate(nums):
            while used & x:                        # bit conflict
                used ^= nums[left]                 # its bits are its own, so XOR removes them
                left += 1
            used |= x
            best = max(best, right - left + 1)
        return best
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Removing bits with `-=` or `^=` is only correct because the window's bits never overlap; with overlaps it would not work.

## Interview Explanation

Pairwise AND 0 means each bit is used by at most one number, so one integer records the bits the window uses. If a new number overlaps it, I shrink the left; the leaving number's bits are its own, so XOR removes them. Tracking the longest length gives `O(n)`.
