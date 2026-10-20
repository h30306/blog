---
title: "LeetCode 2709: Greatest Common Divisor Traversal"
summary: "LeetCode 2709 note: every pair of indices connects ⇔ one component; factor with SPF and union each number with its prime factors in Union-Find, treating 1 specially"
description: "LeetCode 2709 record from 2025-08-07"
date: 2025-08-07
tags: ["hard", "math", "number-theory", "union-find", "sieve", "gcd", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2025-08-07
- Submissions: TLE → RE → WA ×2 → TLE ×2 (2025-08-07) → AC → WA → RE → AC (2026-10-12)

## Approach

"Every pair of indices can reach each other" ⇔ **all indices form one component**. As in [LeetCode 952]({{< relref "/leetcode/LeetCode-952" >}}), prime factors replace pairwise GCDs.

Here the Union-Find nodes are **values**: sieve SPF up to `max(nums)` and union every number with each of its prime factors. Finally check that all numbers share one root.

**The special case of `1`**: 1 has no prime factors and connects to nothing.

- With a single element there is no pair to check, so the answer is `True` (even for `[1]`).
- With more than one element and any 1: always `False`.

## My Attempts

| Version | Problem |
|---|---|
| Attempt 1, TLE | Pairwise GCDs, `O(n^2)` |
| RE | Tried to deduplicate with `nums = set(nums)`, but a `set` cannot be indexed |
| WA | Deduplicated with `list(set(nums))`, collapsing two 1s into one. For `[1, 1]` the two 1s cannot reach each other, so the answer is `False`; it returned `True` |
| WA | Added "any 1 means `False`", but `[1]` alone is `True` |
| Two TLEs | Still pairwise GCDs |
| AC (a year later) | Unioned indices by prime factor |
| WA | Switched to SPF with values as nodes, again without handling 1: `[1, 1]` returned `True` |
| RE | Added an `n == 1` check, but before `n = len(nums)` |
| AC | Reordered |

## Solution

```python
class Solution:
    def canTraverseAllPairs(self, nums: List[int]) -> bool:
        n = len(nums)
        if n == 1:
            return True
        if 1 in nums:
            return False                           # 1 connects to nothing

        m = max(nums)
        spf = list(range(m + 1))
        for i in range(2, int(m ** 0.5) + 1):
            if spf[i] == i:
                for j in range(i * i, m + 1, i):
                    if spf[j] == j:
                        spf[j] = i

        parent = list(range(m + 1))                # nodes are values

        def find(a: int) -> int:
            while parent[a] != a:
                parent[a] = parent[parent[a]]
                a = parent[a]
            return a

        for x in nums:
            v = x
            while v > 1:
                p = spf[v]
                parent[find(x)] = find(p)          # union the number with its prime factor
                while v % p == 0:
                    v //= p

        root = find(nums[0])
        return all(find(x) == root for x in nums)
```

## Complexity

Time `O(M log log M + n log M)` with `M` the maximum; space `O(M)`.

## Mistakes to Avoid

- Pairwise GCDs: `O(n^2)`.
- Deduplicating: two equal 1s are two indices, and deduplication merges them.
- `[1]` is `True`; only with more than one element does a 1 mean `False`.

## Interview Explanation

Every pair connecting means everything is one component. Sharing a factor means sharing a prime factor, so I factor each number with an SPF sieve, union each number with its prime factors in Union-Find, and check that all numbers share a root. 1 has no prime factors: a single element is `True`, otherwise any 1 means `False`.
