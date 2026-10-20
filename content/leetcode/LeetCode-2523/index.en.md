---
title: "LeetCode 2523: Closest Prime Numbers in Range"
summary: "LeetCode 2523 note: sieve the primes in range, since only adjacent primes can be closest; or trial-divide rightward from left and stop at the first twin primes with gap 2"
description: "LeetCode 2523 record from 2026-10-12"
date: 2026-10-12
tags: ["medium", "math", "number-theory", "sieve", "array"]
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
- Submissions: Wrong Answer → Accepted ×5 (linear sieve → trial division with early exit)

## Approach

The closest two primes are always **adjacent** primes (any prime between them would be closer).

### Sieve

Sieve all primes `<= right` with a linear sieve, start from the first one `>= left`, and compare adjacent gaps, keeping the smallest; on ties keep the earlier pair (smallest `num1`).

### Trial division with early exit

Trial-divide from `left` rightward, remembering the previous prime. Return as soon as a gap of 2 appears: nothing is smaller except `[2, 3]` (gap 1), which would be found first if it is in range. In practice this is fast (5ms), since twin primes with gap 2 are common.

## My Attempts

Attempt 1 computed the adjacent gap as `prime[i + 1] - prime[i - 1]` instead of `prime[i + 1] - prime[i]`. For `left = 6`, `right = 43` the answer is `[11, 13]`; it returned `[7, 11]`.

After the fix it passed, but the linear sieve up to `right = 10^6` took over 4 seconds; trial division with the early exit dropped it to 5ms.

## Solution

```python
class Solution:
    def closestPrimes(self, left: int, right: int) -> List[int]:
        def is_prime(x: int) -> bool:
            if x < 2:
                return False
            if x % 2 == 0:
                return x == 2
            d = 3
            while d * d <= x:
                if x % d == 0:
                    return False
                d += 2
            return True

        prev = -1
        ans = [-1, -1]
        best = float("inf")
        for x in range(left, right + 1):
            if is_prime(x):
                if prev != -1 and x - prev < best:
                    best = x - prev
                    ans = [prev, x]
                    if best <= 2:
                        return ans                 # cannot get smaller
                prev = x
        return ans
```

## Complexity

Worst case `O((right - left) √right)`, but twin primes appear quickly in practice. The sieve version is `O(right)`.

## Mistakes to Avoid

- The wrong index in the adjacent gap.
- Ties keep the smaller `num1`, the pair found first: use `<`, not `<=`.

## Interview Explanation

The closest two primes are always adjacent. I can sieve the primes in range and compare adjacent gaps, or trial-divide rightward from `left`, remembering the previous prime, and return as soon as the gap is 2, since only `[2, 3]` is smaller and it would appear first.
