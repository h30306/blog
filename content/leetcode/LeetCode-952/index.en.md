---
title: "LeetCode 952: Largest Component Size by Common Factor"
summary: "LeetCode 952 note: sharing a factor ⇔ sharing a prime factor; factor each number and union indices with the same prime factor using Union-Find, with no pairwise GCDs"
description: "LeetCode 952 record from 2025-05-10"
date: 2025-05-10
tags: ["hard", "math", "number-theory", "union-find", "hash-table", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2025-05-10
- Submissions: TLE ×2 → AC (2025-05-17) → TLE → AC ×2 (rewritten 2026-10-12)

## Approach

Two numbers share a factor greater than 1 ⇔ they **share a prime factor**.

- Pairwise GCDs are `O(n^2 log M)`, too slow for `n = 2 × 10^4`.
- Instead **factor each number** (trial division up to `√x`) and record each prime's first owner index `owner[p]`. Later numbers with the same prime are unioned with `owner[p]`.

Finally count each group's size and take the maximum.

## My Attempts

| When | Version | Problem |
|---|---|---|
| 2025-05 | Two TLEs | Pairwise GCDs, `O(n^2)` |
| 2025-05 | AC | Grouped indices by prime factor and unioned neighbors within each group |
| 2026-10 | TLE | The rewrite went back to pairwise GCDs |
| 2026-10 | AC (3.9 s) | Switched to `owner[p]`, but `find` was `return find(parent[a])` **without storing it in `parent[a]`**, so there was no path compression |
| 2026-10 | AC (1.3 s) | Added path compression |

## Solution

```python
class Solution:
    def largestComponentSize(self, nums: List[int]) -> int:
        n = len(nums)
        parent = list(range(n))

        def find(a: int) -> int:
            if parent[a] != a:
                parent[a] = find(parent[a])        # path compression: store it back
            return parent[a]

        def union(a: int, b: int) -> None:
            ra, rb = find(a), find(b)
            if ra != rb:
                parent[ra] = rb

        owner = {}                                 # prime factor -> first index that has it

        def link(i: int, p: int) -> None:
            if p in owner:
                union(i, owner[p])
            else:
                owner[p] = i

        for i, x in enumerate(nums):
            p = 2
            while p * p <= x:
                if x % p == 0:
                    link(i, p)
                    while x % p == 0:
                        x //= p
                p += 1
            if x > 1:
                link(i, x)                         # the leftover large prime factor

        return max(Counter(find(i) for i in range(n)).values())
```

## Complexity

Time `O(n √M)` (trial division) with `M` the maximum; an SPF sieve brings it to `O(M + n log M)`. Space `O(n + number of primes)`.

## Mistakes to Avoid

- Pairwise GCDs: `O(n^2)`.
- `find` not storing its result: no path compression.
- A leftover `x > 1` after trial division is a prime factor too.

## Interview Explanation

Sharing a factor means sharing a prime factor, so instead of pairwise GCDs I factor each number, remember each prime's first owner index, and union later numbers with the same prime using Union-Find. Then I count group sizes. Time `O(n √M)`.
