---
title: "LeetCode 509: Fibonacci Number"
summary: "LeetCode 509 note: the starting point of 1D DP; only the previous two terms are needed, so roll two variables"
description: "LeetCode 509 record from 2022-08-25"
date: 2022-08-25
tags: ["easy", "math", "dynamic-programming", "recursion", "memoization"]
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
- Submissions: Accepted → Runtime Error → Accepted ×2

## Approach

`F(n) = F(n - 1) + F(n - 2)` depends only on the previous two terms, so roll two variables instead of an array ([Linear DP]({{< relref "/algorithm/Linear-DP" >}}) Template 1). Plain recursion without memoization is `O(2^n)`.

## My Attempts

A 2022-11 rewrite wrote `for _ in n`; **an integer is not iterable** (TypeError). `range(n)` passed.

## Solution

```python
class Solution:
    def fib(self, n: int) -> int:
        a, b = 0, 1
        for _ in range(n):
            a, b = b, a + b
        return a
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Loop over `range(n)`, not `for _ in n`.
- Recursion without memoization is exponential.

## Interview Explanation

Each term depends on the previous two, so I roll two variables forward n times. Time `O(n)`, space `O(1)`.
