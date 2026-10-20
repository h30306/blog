---
title: "LeetCode 3984: Divisible Game"
summary: "LeetCode 3984 note: replacing a composite k by one of its prime factors only helps (more values divisible, smaller k), so try every prime factor of the numbers plus 2, running Kadane once per candidate"
description: "LeetCode 3984 record from 2026-07-06"
date: 2026-07-06
tags: ["medium", "dynamic-programming", "kadane", "math", "number-theory", "enumeration"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-07-06
- Submissions: WA → AC → WA ×2 → AC

## Approach

With `k` fixed, divisible values count `+x` and the rest `-x`, so the best difference is a **maximum subarray sum**, one `O(n)` Kadane pass.

Which `k` to try?

- **Skip composites**: if `k` is composite with prime factor `p`, everything divisible by `k` is divisible by `p`, so `p` gives a difference at least as large, and `p < k` wins ties.
- So the candidates are **all prime factors of the numbers**. With `nums[i] <= 10^6`, trial division by primes `<= 1000` works, and any leftover `> 1` is also a prime factor.
- **Always include 2**: if every number is 1 there are no prime factors; then `k = 2` divides nothing, the best difference is the largest single `-x`, and 2 is the smallest `k`.

On ties, keep the smallest `k`.

## My Attempts

| Version | Problem |
|---|---|
| Attempt 1 | Used only primes `<= 1000` as candidates, **missing prime factors above 1000**. For `[1013]`, `k = 1013` gives 1013, so the answer is `1013 × 1013 = 1026169`; it only tried 2 |
| Attempt 2, AC | Added the leftover `> 1` after trial division |
| Attempt 3 | Dropped the default 2, so the candidate set was empty when every number is 1. For `[1]` the answer is `-1 × 2` modulo; it computed `nan` |
| Attempt 4 | A rewrite of the sieve forgot to `append` the primes, leaving only each number itself as a candidate. For `[9]`, `k = 3` and `k = 9` both give 9, the smaller 3 wins, and the answer is 27; it returned 81 |
| Attempt 5, AC | Added the `append` |

## Solution

```python
class Solution:
    def divisibleGame(self, nums: List[int]) -> int:
        MOD = 10 ** 9 + 7
        LIMIT = 1001
        is_prime = [True] * LIMIT
        primes = []
        for p in range(2, LIMIT):
            if is_prime[p]:
                primes.append(p)
                for q in range(p * p, LIMIT, p):
                    is_prime[q] = False

        candidates = {2}                           # a candidate even when every number is 1
        for x in nums:
            for p in primes:
                if p * p > x:
                    break
                if x % p == 0:
                    candidates.add(p)
                    while x % p == 0:
                        x //= p
            if x > 1:
                candidates.add(x)                  # the leftover large prime factor

        best_diff, best_k = float("-inf"), 0
        for k in sorted(candidates):               # ascending, so ties keep the smaller k
            cur, best = 0, float("-inf")
            for x in nums:
                score = x if x % k == 0 else -x
                cur = max(score, cur + score)      # Kadane
                best = max(best, cur)
            if best > best_diff:
                best_diff, best_k = best, k
        return best_diff * best_k % MOD
```

Trial division can stop once `p * p > x`: any leftover `x > 1` is then prime.

## Complexity

Each number has at most 7 distinct prime factors, so there are at most about `7n` candidates, each with an `O(n)` Kadane pass: `O(n^2)` with `n <= 1000`.

## Mistakes to Avoid

- Using only small primes as candidates: prime factors above `sqrt(max)` get missed.
- The no-candidate case (every number is 1).
- Forgetting to collect the primes in the sieve.

## Interview Explanation

With `k` fixed, divisible values are positive and the rest negative, so the answer is a maximum subarray sum via Kadane. A composite `k` is never better than its prime factor, so the candidates are the numbers' prime factors, plus 2 for the all-ones case. One Kadane pass per candidate, with ties going to the smaller `k`. Time `O(n^2)`.
