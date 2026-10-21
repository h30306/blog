---
title: "LeetCode 204: Count Primes"
summary: "LeetCode 204 note: the sieve of Eratosthenes, crossing out multiples of each prime p starting at p², with the outer loop only up to √n"
description: "LeetCode 204 record from 2022-11-11"
date: 2022-11-11
tags: ["medium", "array", "math", "enumeration", "number-theory"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-11-11
- Submissions: Output Limit Exceeded → Time Limit Exceeded ×4 → Runtime Error ×2 → Accepted → Wrong Answer → Accepted ×2

## Approach

The sieve of Eratosthenes ([Number Theory]({{< relref "/algorithm/Number-Theory" >}}) Template 3): start with all `True`, and from 2 on, **only a `p` still marked prime** crosses out its multiples, beginning at `p²` (smaller multiples were crossed by smaller primes); `p` only needs to reach `√n`. In Python slice assignment `is_prime[p*p::p] = ...` is far faster than an inner loop.

## My Attempts

This took 11 submissions:

- The first 2022-11-11 version left a `print` in (Output Limit Exceeded). The next ones sieved, but with `if num:` **every number crossed out its multiples**, prime or not, and the outer loop ran to `n`: four TLEs.
- On 2022-11-17 I looped only to `√n` with slice assignment; a misspelled name (NameError) and `prime[1]` out of range for `n < 2` (IndexError) came first, then the special case passed.
- A 2026 rewrite as a linear sieve first tested `if is_composite[i]`, **the opposite condition**, so no prime was ever added: `n = 3` returned 0 instead of 1.

## Solution

```python
class Solution:
    def countPrimes(self, n: int) -> int:
        if n < 3:
            return 0
        is_prime = [True] * n
        is_prime[0] = is_prime[1] = False
        for p in range(2, int(n ** 0.5) + 1):
            if is_prime[p]:
                is_prime[p * p::p] = [False] * len(range(p * p, n, p))
        return sum(is_prime)
```

## Complexity

Time `O(n log log n)`, space `O(n)`.

## Mistakes to Avoid

- Sieve only with primes: a composite's multiples were already crossed out by its prime factors.
- The outer loop only needs `√n`.
- For `n < 2` the array is too short and `is_prime[1]` is out of range.
- In a linear sieve a number joins the prime list when it is **not** composite; inverting that finds no primes.

## Interview Explanation

I use the sieve of Eratosthenes: for p from 2 to √n, if p is still prime I cross out its multiples from p², then count what remains. Time `O(n log log n)`.
