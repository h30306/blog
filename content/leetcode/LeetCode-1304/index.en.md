---
title: "LeetCode 1304: Find N Unique Integers Sum up to Zero"
summary: "LeetCode 1304 note: place 1..n/2 and their negatives so each pair cancels, adding 0 when n is odd"
description: "LeetCode 1304 record from 2025-07-21"
date: 2025-07-21
tags: ["easy", "math", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2025-07-21
- Submissions: Wrong Answer ×2 → Accepted

## Approach

Place `i` and `-i` in pairs (`i = 1..n/2`): each pair sums to 0 and nothing repeats. When `n` is odd, add one `0`.

## My Attempts

1. Attempt 1 used `range(-n//2, n//2 + 1)`, **one number too many for even `n`** (it includes 0). For `n = 2` it returned `[-1, 0, 1]`, three numbers.
2. Attempt 2 lowered the upper bound for even `n`, giving `[-1, 0]`, which does not sum to 0.
3. Generating `-n//2..n//2` and removing the middle 0 for even `n` passed.

## Solution

```python
class Solution:
    def sumZero(self, n: int) -> List[int]:
        res = []
        for i in range(1, n // 2 + 1):
            res += [i, -i]                         # each pair cancels
        if n % 2:
            res.append(0)
        return res
```

## Complexity

Time `O(n)`, space `O(n)` for the output.

## Mistakes to Avoid

- With even `n` there is no room for 0 (it would add a number or force removing another).

## Interview Explanation

I place `i` and `-i` in pairs, each summing to 0, for `n / 2` pairs, and add a 0 when `n` is odd. Time `O(n)`.
