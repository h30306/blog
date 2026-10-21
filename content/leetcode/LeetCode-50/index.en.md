---
title: "LeetCode 50: Pow(x, n)"
summary: "LeetCode 50 note: fast exponentiation, x^n = (x²)^(n/2) with an extra x for odd n; for negative n compute 1 / x^(-n)"
description: "LeetCode 50 record from 2022-11-14"
date: 2022-11-14
tags: ["medium", "math", "recursion"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-11-14
- Submissions: Accepted (first try)

## Approach

Fast exponentiation ([Math]({{< relref "/algorithm/Math" >}}) Template 8): for even `n`, `x^n = (x²)^(n/2)`, and odd `n` needs one more `x`; halving `n` each time takes `O(log n)` multiplications. For `n < 0`, switch to `1 / x` and `-n`. The iterative version reads `n` in binary: each 1 bit multiplies the current `x^(2^k)` into the answer.

## My Attempts

Passed on the first try with a recursive version: `n < 0` returns `1 / myPow(x, -n)`, odd `n` gives `x * myPow(x, n - 1)`, and even `n` gives `myPow(x * x, n // 2)`.

## Solution

```python
class Solution:
    def myPow(self, x: float, n: int) -> float:
        if n < 0:
            x, n = 1 / x, -n
        res = 1.0
        while n:
            if n & 1:
                res *= x
            x *= x
            n >>= 1
        return res
```

## Complexity

Time `O(log n)`, space `O(1)`.

## Mistakes to Avoid

- Multiplying one `x` at a time is `O(n)` and times out for `n` near `2^31`.
- Negative exponents take the reciprocal.
- `n = 0` gives 1.

## Interview Explanation

I use fast exponentiation over the bits of n: multiply the current x into the answer for each 1 bit, square x and shift n each step; for negative n I switch to 1 / x and -n. Time `O(log n)`.
