---
title: "LeetCode 1071: Greatest Common Divisor of Strings"
summary: "LeetCode Problem Solving"
description: "LeetCode Daily"
date: 2025-08-09
tags: ["leetcode", "daily", "easy", "string", "gcd", "math"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: Easy
First Attempt: 2025-08-09
- Total time: 00:00.00

## Intuition

Think of a "GCD string" as a base substring that, when repeated, forms both `str1` and `str2`. The answer must be a common prefix of both strings, and its length must divide both lengths. A straightforward strategy is to try candidate lengths from long to short and validate by repetition.

## Approach

High-level steps:

- Let `m = len(str1)` and `n = len(str2)`.
- Define `isValid(k)` to check whether the prefix `str1[:k]` can be repeated to form both strings. This requires `m % k == 0` and `n % k == 0`, and that repeating the prefix the appropriate number of times equals `str1` and `str2`.
- Iterate `k` from `m` down to `1`; return the first valid prefix. If none works, return an empty string.

```python
class Solution:
    def gcdOfStrings(self, str1: str, str2: str) -> str:
        m = len(str1)
        n = len(str2)

        def isValid(k):
            base = str1[: k]

            if m % k or n % k:
                return False

            times1 = m // k
            times2 = n // k

            return times1 * base == str1 and times2 * base == str2
            
        
        for i in range(m, 0, -1):
            if isValid(i):
                return str1[:i]
        return ""
```

## Findings

- A valid divisor length must divide both `m` and `n`.
- If `str1 + str2 != str2 + str1`, there is no common base string; this is a quick early-exit check.
- Potential optimization: Only test lengths that divide `gcd(m, n)`, or directly test `str1[:gcd(m, n)]`.
- Complexity of the current approach: worst-case O((m + n) × d), where `d` is the number of common divisors of `m` and `n`; space O(1).

## Encountered Problems 