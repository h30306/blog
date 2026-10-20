---
title: "LeetCode 2122: Recover the Original Array"
summary: "LeetCode 2122 note: the smallest number is always in lower, so enumerating its partner fixes k; after sorting, two pointers pair each smallest unmatched number with the number 2k above it"
description: "LeetCode 2122 record from 2026-01-26"
date: 2026-01-26
tags: ["hard", "two-pointers", "sorting", "hash-table", "enumeration", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-01-26
- Submissions: Wrong Answer → Accepted (counting) → Accepted (two pointers)

## Approach

Each original `arr[i]` produces the pair `arr[i] - k` and `arr[i] + k`, which differ by `2k`.

1. **Fix `k`**: after sorting, the smallest `nums[0]` must be a `lower` value, paired with some `nums[i]`. Enumerate `i`; `diff = nums[i] - nums[0]` must be positive and even, and `k = diff / 2`.
2. **Check this `k`**: going from small to large, the smallest unmatched number must be a `lower` value (everything smaller is matched), and its partner is `x + 2k`. With two pointers, `lo` finds the next unmatched number and `hi` finds the next unused number `>= x + 2k`; if equal, they form a pair.
3. With `n / 2` pairs, return `[x + k for each pair]`.

`x + 2k` grows with `lo`, so `hi` only moves right; numbers that `hi` skips for being below the target are never needed as `higher` later, since later targets are larger.

## My Attempts

I first wrote a `Counter` version: for each `k`, scan the sorted numbers, with `freq` tracking how many times each value has been used.

Attempt 1 used `break` on reaching a number already used as a `higher` value; it should `continue` past it. For `nums = [1, 3, 4, 6]` (original `[2, 5]`, `k = 1`), after pairing `1, 3` it stopped at the used `3` and returned nothing.

Switching to `continue` passed, and I later rewrote it with two pointers.

## Solution

```python
class Solution:
    def recoverArray(self, nums: List[int]) -> List[int]:
        nums.sort()
        n = len(nums)
        for i in range(1, n):
            diff = nums[i] - nums[0]
            if diff == 0 or diff % 2:
                continue                           # k must be a positive integer
            k = diff // 2
            used = [False] * n
            res = []
            hi = 0
            for lo in range(n):
                if used[lo]:
                    continue                       # already used as a higher value
                hi = max(hi, lo + 1)
                while hi < n and (used[hi] or nums[hi] < nums[lo] + 2 * k):
                    hi += 1
                if hi == n or nums[hi] != nums[lo] + 2 * k:
                    break                          # this k does not work
                used[lo] = used[hi] = True
                res.append(nums[lo] + k)
            if len(res) == n // 2:
                return res
        return []
```

## Complexity

Time `O(n^2)`: at most `n` values of `k`, each checked with two pointers in `O(n)`. Space `O(n)`.

## Mistakes to Avoid

- `k` must be a positive integer: skip a `diff` that is 0 or odd.
- `continue` past numbers already used in a pair, don't `break`.

## Interview Explanation

After sorting, the smallest number must be a `lower` value, so I enumerate its partner to fix `k`, requiring a positive even difference. For each `k`, going upward, the smallest unmatched number must be a `lower` value, and a second, right-only pointer finds its `x + 2k`; if it is missing I try the next `k`. Once all pairs are formed I return the midpoints. `O(n^2)` overall.
