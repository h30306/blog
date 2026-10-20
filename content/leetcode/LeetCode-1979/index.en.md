---
title: "LeetCode 1979: Find Greatest Common Divisor of Array"
summary: "LeetCode 1979 note: find the minimum and maximum, then take their GCD with Euclid's algorithm"
description: "LeetCode 1979 record from 2025-05-17"
date: 2025-05-17
tags: ["easy", "math", "number-theory", "gcd", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2025-05-17
- Submissions: Accepted ×3

## Approach

Only the GCD of the minimum and maximum is needed. Euclid's algorithm: `gcd(a, b) = gcd(b, a % b)` until `b == 0`, and the answer is `a`.

## My Solution

```python
class Solution:
    def findGCD(self, nums: List[int]) -> int:
        a, b = max(nums), min(nums)
        while b:
            a, b = b, a % b
        return a
```

My third submission found both extremes in one scan, saving a pass; `math.gcd(min(nums), max(nums))` also works.

## Complexity

Time `O(n + log M)`, space `O(1)`.

## Mistakes to Avoid

- Euclid's loop runs while `b != 0` and returns `a`.

## Interview Explanation

I find the minimum and maximum, then run Euclid's algorithm, replacing `(a, b)` with `(b, a % b)` until `b` is 0, at which point `a` is the GCD. Time `O(n + log M)`.
