---
title: "LeetCode 3618: Split Array by Prime Indices"
summary: "LeetCode 3618 note: primality is about the index; a sieve of Eratosthenes marks all of 0..n-1 at once, faster than trial division per index"
description: "LeetCode 3618 record from 2025-07-19"
date: 2025-07-19
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
First Attempt: 2025-07-19
- Submissions: Accepted (first try)

## Approach

Elements at prime indices go to A and the rest to B; return `|sum(A) - sum(B)|`.

To test every index `0..n-1`, a **sieve of Eratosthenes** marks them all at once in `O(n log log n)`. I trial-divided each index up to `√i`, which is `O(n √n)` and still passes, but more slowly (767ms).

`0` and `1` are not prime.

## My Solution

```python
from math import isqrt

class Solution:
    def splitArray(self, nums: List[int]) -> int:
        n = len(nums)
        is_prime = [False, False] + [True] * max(0, n - 2)
        for i in range(2, isqrt(n) + 1):
            if is_prime[i]:
                for j in range(i * i, n, i):
                    is_prime[j] = False
        diff = 0
        for i, x in enumerate(nums):
            diff += x if is_prime[i] else -x
        return abs(diff)
```

With `n = 1`, only the first `n` entries of `is_prime` are read, so the padded `[False, False]` does no harm.

## Complexity

Time `O(n log log n)`, space `O(n)`.

## Mistakes to Avoid

- Primality is about the index, not the element's value.
- `0` and `1` are not prime.

## Interview Explanation

A sieve of Eratosthenes marks which indices are prime in one go; then one scan adds elements at prime indices, subtracts the rest, and takes the absolute value. Time `O(n log log n)`, faster than trial division per index.
