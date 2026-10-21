---
title: "LeetCode 397: Integer Replacement"
summary: "LeetCode 397 note: even numbers are always halved; for odd numbers try +1 and -1 with memoized recursion, since n is too large for an n-sized array"
description: "LeetCode 397 record from 2022-11-16"
date: 2022-11-16
tags: ["medium", "dynamic-programming", "greedy", "bit-manipulation", "memoization"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-11-16
- Submissions: Wrong Answer → Accepted ×2

## Approach

Even numbers can only be halved. An odd `n` goes to `n + 1` or `n - 1`, both even, so `f(n) = 2 + min(f((n + 1) / 2), f((n - 1) / 2))`. Memoized recursion roughly halves `n` per level, giving `O(log n)` states. With `n` up to `2^31 - 1`, **a bottom-up array of size `n` runs out of memory**, and `dp[i + 1]` is not yet known when computing `dp[i]`.

A greedy also works: for odd `n`, subtract 1 when `n = 3` or the binary ends in `01`, otherwise (ending `11`) add 1.

## My Attempts

Attempt 1 was a bottom-up DP, but odd `i` needs `dp[i + 1]`, **which is not computed yet when going upward**, so that branch was effectively ignored and some odd values came out wrong. Switching to recursion (first with float `n / 2`, later `//`) passed.

## Solution

```python
class Solution:
    def integerReplacement(self, n: int) -> int:
        @cache
        def f(x):
            if x == 1:
                return 0
            if x % 2 == 0:
                return 1 + f(x // 2)
            return 2 + min(f((x + 1) // 2), f((x - 1) // 2))
        return f(n)
```

## Complexity

Time `O(log n)`, space `O(log n)`.

## Mistakes to Avoid

- A bottom-up DP needs `dp[i + 1]` before it exists when `i` is odd.
- `n` is too large for an `n`-sized array.
- `n / 2` is a float; use `//`.

## Interview Explanation

Even numbers are halved; for odd numbers I try both +1 and -1, each followed by halving. Memoized recursion halves n per level, leaving `O(log n)` states; n is too large for an n-sized array.
