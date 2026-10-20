---
title: "LeetCode 3918: Sum of Primes Between Number and Its Reverse"
summary: "LeetCode 3918 note: reverse n, take the range [min, max], and sum primes by trial division; test divisibility with %, never by comparing // with /"
description: "LeetCode 3918 record from 2026-05-03"
date: 2026-05-03
tags: ["medium", "math", "number-theory"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-05-03
- Submissions: Wrong Answer → Accepted

## Approach

With `r` the reverse of `n`, the range is `[min(n, r), max(n, r)]`. It is small, so trial-divide each number and sum the primes. (For larger ranges, a sieve computes them all at once.)

## My Attempts

Attempt 1's primality test:

- tested divisibility with `n // i == n / i`, relying on floating point, and
- tried `range(2, ceil(√n) + 1)`, so **for `n = 2` it tried `i = 2`**, where `2 // 2 == 2 / 2`, judging 2 composite.

For `n = 2`, the reverse is still 2 and the answer is 2; it returned 0. Handling 2 first, trying only odd divisors, and using `%` passed.

## Solution

```python
from math import isqrt

class Solution:
    def sumOfPrimesInRange(self, n: int) -> int:
        def is_prime(x: int) -> bool:
            if x < 2:
                return False
            if x % 2 == 0:
                return x == 2
            for d in range(3, isqrt(x) + 1, 2):
                if x % d == 0:
                    return False
            return True

        r = int(str(n)[::-1])
        return sum(x for x in range(min(n, r), max(n, r) + 1) if is_prime(x))
```

## Complexity

Time `O(R √R)` with `R` the range's upper end; space `O(1)`.

## Mistakes to Avoid

- Testing divisibility with floating-point division.
- Using `ceil(√n)` as the limit lets small numbers try themselves; use `isqrt` and stop at `√x`.

## Interview Explanation

Reversing `n` gives the range; trial division tests each number and the primes are summed. Trial division stops at `√x`, divisibility uses `%`, and 2 is handled first. For a bigger range, switch to a sieve.
