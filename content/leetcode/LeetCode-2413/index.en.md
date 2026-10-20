---
title: "LeetCode 2413: Smallest Even Multiple"
summary: "LeetCode 2413 note: lcm(2, n), which is n when n is even and 2n when odd"
description: "LeetCode 2413 record from 2025-12-17"
date: 2025-12-17
tags: ["easy", "math", "number-theory"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2025-12-17
- Submissions: Accepted (Python) → Wrong Answer (C++) → Accepted (C++)

## Approach

The smallest positive multiple of both 2 and `n` is `lcm(2, n)`:

- Even `n`: `n` is already a multiple of 2, so the answer is `n`.
- Odd `n`: `gcd(2, n) = 1`, so the answer is `2n`.

## My Attempts

Python passed first. Practicing in C++, I swapped the ternary branches: `(n % 2) ? n : n * 2` returns `n` when `n % 2` is 1 (odd). For `n = 5` the answer is 10; it returned 5.

## Solution

```python
class Solution:
    def smallestEvenMultiple(self, n: int) -> int:
        return n if n % 2 == 0 else 2 * n
```

## Complexity

Time `O(1)`, space `O(1)`.

## Mistakes to Avoid

- `n % 2` is truthy (1) for odd numbers; writing `n % 2 == 0` makes the branches harder to swap.

## Interview Explanation

The answer is the least common multiple of 2 and `n`: `n` itself when even, and `2n` when odd since 2 and `n` are then coprime. Time `O(1)`.
