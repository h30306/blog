---
title: "LeetCode 2761: Prime Pairs With Target Sum"
summary: "LeetCode 2761 note: sieve primes below n, then try x up to n / 2; when x and n - x are both prime, they form a pair"
description: "LeetCode 2761 record from 2026-10-12"
date: 2026-10-12
tags: ["medium", "math", "number-theory", "sieve", "enumeration", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-10-12
- Submissions: Accepted (first try)

## Approach

1. Sieve every prime `< n` (`n` up to `10^6`, so a sieve beats trial division per number).
2. For `x` from 2 to `n / 2`: if `x` and `n - x` are both prime, `[x, n - x]` is a pair. Since `x <= n - x`, the result comes out sorted by `x`.

## My Solution

My accepted version ran a linear sieve, then converging pointers over the prime list looking for sums of `n` (like Two Sum II), taking 5.7 seconds. Checking `is_prime[n - x]` directly is simpler:

```python
from math import isqrt

class Solution:
    def findPrimePairs(self, n: int) -> List[List[int]]:
        if n < 4:
            return []
        is_prime = [False, False] + [True] * (n - 1)
        for i in range(2, isqrt(n) + 1):
            if is_prime[i]:
                for j in range(i * i, n + 1, i):
                    is_prime[j] = False
        return [[x, n - x] for x in range(2, n // 2 + 1) if is_prime[x] and is_prime[n - x]]
```

## Complexity

Time `O(n log log n)`, space `O(n)`.

## Mistakes to Avoid

- Stop `x` at `n / 2`, or each pair appears twice.
- Equal pairs like `[5, 5]` count too.

## Interview Explanation

I sieve the primes up to `n`, then walk `x` from 2 to `n / 2`, adding `[x, n - x]` when both are prime; the order is naturally increasing. Time `O(n log log n)`.
