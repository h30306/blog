---
title: "LeetCode 3644: Maximum K to Sort a Permutation"
summary: "LeetCode 3644 note: every misplaced number must be swapped, so each bit of k must belong to all of them; the answer is the AND of every misplaced number"
description: "LeetCode 3644 record from 2025-08-10"
date: 2025-08-10
tags: ["medium", "bit-manipulation", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-08-10
- Submissions: Wrong Answer → Accepted

## Approach

Swapping `nums[i]` and `nums[j]` requires `nums[i] & nums[j] == k`, so every number that takes part in a swap contains all of `k`'s bits ([Bit Manipulation]({{< relref "/algorithm/Bit-Manipulation" >}}) Template 1).

- Each misplaced number must be swapped at least once, so every bit of `k` must belong to all of them: `k` is at most their combined AND.
- That value is achievable: `k` itself is in the array (values are `0..n-1`, and `k` is no larger than any misplaced number), and `k & x == k` for every misplaced `x`, so `k` can serve as a pivot that every swap goes through, fixing each cycle.
- If the array is already sorted, return 0.

## My Attempts

Attempt 1 tried simulating: for each misplaced position `i`, take the maximum of `i & nums[i]` and swap the right number in. But `k` is a single value that must let **all** misplaced numbers swap, so a maximum is wrong. For `[2, 3, 0, 1]` all four move and `2 & 3 & 0 & 1 = 0`, so the answer is 0; it returned 1. ANDing them all passed.

## Solution

```python
class Solution:
    def sortPermutation(self, nums: List[int]) -> int:
        k = -1                                     # -1 的每一位都是 1
        for i, x in enumerate(nums):
            if x != i:
                k &= x
        return 0 if k == -1 else k
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- `k` must let **every** misplaced number swap, so it is an AND, not a per-position maximum.
- AND starts from -1 (all bits set), not 0.

## Interview Explanation

Every misplaced number must take part in a swap, and swapped pairs AND to `k`, so all of them contain `k`'s bits. The largest `k` is the AND of all misplaced numbers, or 0 if already sorted. Time `O(n)`.
