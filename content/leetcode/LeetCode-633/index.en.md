---
title: "LeetCode 633: Sum of Square Numbers"
summary: "LeetCode 633 note: converge a from 0 and b from isqrt(c); shrink b when the sum is too big and grow a when it is too small; watch for 0, a == b, and floating-point square roots"
description: "LeetCode 633 record from 2026-01-25"
date: 2026-01-25
tags: ["medium", "two-pointers", "math", "binary-search"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-25
- Submissions: Wrong Answer ×3 → Accepted ×2

## Approach

Find non-negative integers `a`, `b` with `a^2 + b^2 = c`.

Converge `a` from `0` and `b` from `⌊√c⌋`:

- `a^2 + b^2 > c`: `b` is too big, `b -= 1`.
- `a^2 + b^2 < c`: `a` is too small, `a += 1`.
- Equal: found.

Nothing is missed: each step rules out "the current `b` is too big with every value `>= a`" or "the current `a` is too small with every value `<= b`", exactly like converging pointers in Two Sum II.

## My Attempts

All three WAs were boundary issues:

| Version | Problem |
|---|---|
| Attempt 1 | Started `a` at `1`, missing `0`. `c = 4 = 0^2 + 2^2` and `c = 0` both returned `False` |
| Attempt 2 | Started `a` at 0 but looped while `a < b`, missing `a == b`. `c = 2 = 1^2 + 1^2` returned `False`; it also started `b` at `c`, taking `O(c)` steps |
| Attempt 3 | `b = c ** 0.5` is a float, and squaring it back is inexact. For `c = 2`, `(√2)^2` evaluates to `2.0000000000000004`, which is greater than 2, so nothing matched and it returned `False` |

`int(c ** 0.5)` passed. `math.isqrt` is safer still, since it never touches floating point.

## Solution

```python
from math import isqrt

class Solution:
    def judgeSquareSum(self, c: int) -> bool:
        a, b = 0, isqrt(c)
        while a <= b:
            s = a * a + b * b
            if s == c:
                return True
            if s < c:
                a += 1
            else:
                b -= 1
        return False
```

## Complexity

Time `O(√c)`, space `O(1)`.

## Mistakes to Avoid

- Forgetting that `0` is a square.
- Looping while `a < b` and missing `a == b`.
- Squaring a floating-point square root and comparing exactly.

## Interview Explanation

I converge `a` from 0 and `b` from the integer square root of `c`: if the sum of squares is too big, decrease `b`; if too small, increase `a`; if equal, done. The boundaries matter: 0 counts, `a` may equal `b`, and `isqrt` avoids floating-point error. Time `O(√c)`.
