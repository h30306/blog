---
title: "LeetCode 2584: Split the Array to Make Coprime Products"
summary: "LeetCode 2584 note: coprime products ⇔ no prime factor in both parts; record each prime's last index, extend reach left to right, and split after i when reach == i"
description: "LeetCode 2584 record from 2026-10-13"
date: 2026-10-13
tags: ["hard", "math", "number-theory", "sieve", "hash-table", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-10-13
- Submissions: AC → WA → AC ×2

## Approach

The products themselves are too large to compute. The two products are coprime ⇔ **no prime factor appears in both parts**.

1. Factor each number with an SPF sieve and record each prime's **last index** `last[p]`.
2. Scan left to right with `reach` = the furthest last index among all primes seen so far. If the left part ends at `i`, the right part may not contain any of its primes, so `reach == i` is required.
3. The first `i <= n - 2` with `reach == i` is the answer; otherwise -1.

This is the same idea as "Partition Labels" (LC 763): each prime spans an interval, and cuts must lie outside every interval.

## My Attempts

After passing once I rewrote it and started `reach` at `-1`. If the first number is 1 (no prime factors), `reach` stays -1, so `reach == 0` fails and the first position can never be a split. For `[1, 1]`, splitting after 0 gives coprime `1` and `1`, so the answer is 0; it returned -1.

Starting at 0 again passed: the left part always contains index 0, so `reach` is at least 0.

## Solution

```python
class Solution:
    def findValidSplit(self, nums: List[int]) -> int:
        m = max(nums)
        spf = list(range(m + 1))
        for i in range(2, int(m ** 0.5) + 1):
            if spf[i] == i:
                for j in range(i * i, m + 1, i):
                    if spf[j] == j:
                        spf[j] = i

        def primes_of(x: int) -> List[int]:
            out = []
            while x > 1:
                p = spf[x]
                out.append(p)
                while x % p == 0:
                    x //= p
            return out

        last = {}
        for i, x in enumerate(nums):
            for p in primes_of(x):
                last[p] = i                        # last index of each prime factor

        reach = 0                                  # the left part reaches at least index 0
        for i in range(len(nums) - 1):
            for p in primes_of(nums[i]):
                reach = max(reach, last[p])
            if reach == i:
                return i
        return -1
```

## Complexity

Time `O(M log log M + n log M)`, space `O(M)`.

## Mistakes to Avoid

- Computing the products: the numbers get enormous.
- Start `reach` at 0, not -1: `1` has no prime factors.
- The last position cannot be a split; `i` goes up to `n - 2`.

## Interview Explanation

Coprime products mean no prime factor appears in both parts. I factor each number with an SPF sieve and record each prime's last index. Scanning left to right, I track how far the primes seen so far extend; when that equals `i`, no prime on the left appears on the right, so I can split after `i`. Time `O(M log log M + n log M)`.
