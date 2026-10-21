---
title: "LeetCode 507: Perfect Number"
summary: "LeetCode 507 note: divisors come in pairs, so enumerate up to √n and add both d and n / d for each divisor found"
description: "LeetCode 507 record from 2022-08-25"
date: 2022-08-25
tags: ["easy", "math"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-25
- Submissions: Accepted (first try)

## Approach

Divisors `d` and `n / d` come in pairs, so enumerate `d` from 2 to `√n` (as in [Number Theory]({{< relref "/algorithm/Number-Theory" >}}) Template 2): add `d` when it divides, and `n / d` too when they differ. 1 always divides but `n` itself does not count, so start the sum at 1 and rule out `n = 1`.

## My Solution

```python
class Solution:
    def checkPerfectNumber(self, num: int) -> bool:
        if num == 1:
            return False
        total = 1
        d = 2
        while d * d <= num:
            if num % d == 0:
                total += d
                if d != num // d:
                    total += num // d
            d += 1
        return total == num
```

## Complexity

Time `O(√n)`, space `O(1)`.

## Mistakes to Avoid

- Do not count `n` itself.
- For a perfect square add `√n` once.
- The proper divisor sum of `n = 1` is 0.

## Interview Explanation

Divisors pair up, so I enumerate to √n, adding d and n / d for each divisor (the square root once), starting from 1 and excluding n itself, then compare with n. Time `O(√n)`.
