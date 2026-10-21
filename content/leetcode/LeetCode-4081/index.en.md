---
title: "LeetCode 4081: Prime Subset Selection II"
summary: "LeetCode 4081 note: sieve the primes, then 0/1 knapsack with dp[j] the fewest primes summing to j; adding primes from large to small, a tie gives a smaller first element, so updating on <= yields the lexicographically smallest"
description: "LeetCode 4081 record from 2026-10-13"
date: 2026-10-13
tags: ["hard", "knapsack-dp", "number-theory"]
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
- Submissions: Accepted → Wrong Answer ×2 → Accepted ×9 (the later ones were practicing different versions)

## Approach

1. **Sieve**: with `n <= 1000`, use a sieve from [Number Theory]({{< relref "/algorithm/Number-Theory" >}}) to list the primes `<= n`.
2. **0/1 knapsack** ([Knapsack DP]({{< relref "/algorithm/Knapsack-DP" >}})): `dp[j]` is the fewest primes summing exactly to `j`, and `best[j]` the matching set. Each prime is used at most once, so update `j` from high to low.
3. **Three-level comparison**: largest sum first (search down from `min(s, sum of primes)` for the first reachable value), then fewest primes (`dp` itself), then lexicographically smallest.
4. **Lexicographic ties**: add primes **from large to small**. With equal counts, the new set is `[p] + best[j - p]`, and `p` is smaller than every prime added before, so the new set starts smaller and is lexicographically smaller. Updating on `<=` therefore handles ties too.

## My Attempts

The first version used a "sum -> set" dictionary and passed. When I later rewrote it as an array knapsack for practice, the first two tries failed because **the linear sieve's inner loop was indented inside `if is prime`**, so composites never crossed out their multiples. For `n = 9`, `s = 49`, 8 was never crossed out and it returned `[2, 3, 5, 7, 8]`; the answer is `[2, 3, 5, 7]`. Moving the inner loop out passed.

The last version also added a `dp[j - p] != inf` check: `inf + 1 <= inf` is `True` in Python, so without it unreachable states also receive a bogus set, even though those are never used.

## Solution

```python
class Solution:
    def maxPrimeSubset(self, n: int, s: int) -> List[int]:
        primes, composite = [], [False] * (n + 1)
        for i in range(2, n + 1):                  # linear sieve: the outer loop runs every i
            if not composite[i]:
                primes.append(i)
            for p in primes:
                if i * p > n:
                    break
                composite[i * p] = True
                if i % p == 0:
                    break
        cap = min(s, sum(primes))
        dp = [inf] * (cap + 1)
        dp[0] = 0
        best = [[] for _ in range(cap + 1)]
        for p in reversed(primes):                 # large to small: ties start with a smaller prime
            for j in range(cap, p - 1, -1):
                if dp[j - p] != inf and dp[j - p] + 1 <= dp[j]:
                    dp[j] = dp[j - p] + 1
                    best[j] = [p] + best[j - p]
        for j in range(cap, 0, -1):
            if dp[j] != inf:
                return best[j]
        return []
```

## Complexity

The sieve is `O(n)`; the knapsack has `π(n)` primes (168 for `n = 1000`) and capacity `s`, copying a set on each update, worst case `O(π(n) · s · π(n))`, which is fast at this size. Space `O(s · π(n))`.

## Mistakes to Avoid

- The linear sieve's inner loop must run for **every** `i`, not only primes.
- `inf + 1 <= inf` is `True`; rule out unreachable states first.
- Think through the insertion order for lexicographic ties; adding large to small is what makes `<=` pick the smallest.

## Interview Explanation

I sieve the primes, then run a 0/1 knapsack where `dp[j]` is the fewest primes summing to `j`, remembering the set. The answer is the largest reachable sum. For the lexicographically smallest set, I add primes from large to small, so a tie in count starts with a smaller prime and updating on `<=` is correct.
