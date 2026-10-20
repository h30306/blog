---
title: "LeetCode 3932: Count K-th Roots in a Range"
summary: "LeetCode 3932 note: the answer is floor(r^(1/k)) - floor((l-1)^(1/k)); take roots with integer binary search and count 0 too"
description: "LeetCode 3932 record from 2026-05-17"
date: 2026-05-17
tags: ["medium", "binary-search", "math"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-05-17
- Submissions: WA ×4 → AC (05-17) → WA → TLE → AC → AC (rewritten on 05-18)

## Approach

The perfect k-th powers in `[l, r]` correspond to integers `x` with `l <= x^k <= r`.

Let `f(n)` be the largest `x` with `x^k <= n`. Then:

```text
answer = f(r) - f(l - 1)
```

Note that **`0 = 0^k` is a perfect k-th power too**, so `x` starts at 0, and `f(-1) = -1`.

## My Attempts

### Attempt 1: comparing floats for equality

```python
if i ** (1 / k) == int(i ** (1 / k)):
```

Floating-point roots are inexact: in Python, `64 ** (1/3)` is `3.9999999999999996`, so comparing with `int(...)` says 64 is not a perfect cube. It also checked every value in `[l, r]` one by one, which is far too slow for `10^9`.

### Integer binary search, but missing 0

```python
if n == 0:
    return 0
low = 1
```

The search started at 1 and returned 0 for `n == 0`, which excludes `x = 0`. With `l = 0`, the perfect power 0 was missed. Starting the search at 0 and returning `-1` for `n < 0` passed.

### The next day: enumerating bases

I rewrote it to enumerate `x` from 0 to `r^(1/k) + 1` and check `l <= x^k <= r`. With `k = 1`, `x` runs up to `10^9` and times out, so a `k == 1` special case was needed.

The last version used floats only to estimate the range of `x` and corrected both ends with integers, which also passed.

## Solution

```python
class Solution:
    def countKthRoots(self, l: int, r: int, k: int) -> int:
        def floor_root(n: int) -> int:            # largest x with x ** k <= n
            lo, hi = 0, n + 1
            while lo < hi:
                mid = (lo + hi) // 2
                if mid ** k <= n:
                    lo = mid + 1
                else:
                    hi = mid
            return lo - 1                          # -1 when n < 0

        return floor_root(r) - floor_root(l - 1)
```

Everything is integer arithmetic, and `k = 1` needs no special case.

## Complexity

Time `O(k log r)`: `log r` iterations, each computing `mid ** k`. Space `O(1)`.

## Mistakes to Avoid

- Taking a floating-point root and comparing for equality.
- Missing `0`: when `l = 0`, `0` itself is a perfect k-th power.
- Enumerating bases without considering `k = 1`: there would be up to `10^9` bases.

## Interview Explanation

The count of perfect k-th powers in the range is `f(r) - f(l - 1)`, where `f(n)` is the largest integer `x` with `x^k <= n`. Floating-point roots are inexact, so I compute `f` with integer binary search starting from 0, which counts 0 and naturally gives `f(-1) = -1`. Time `O(k log r)`.
