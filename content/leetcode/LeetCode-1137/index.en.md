---
title: "LeetCode 1137: N-th Tribonacci Number"
summary: "LeetCode 1137 note: like Fibonacci, roll three variables; watch the base values T0 = 0, T1 = T2 = 1 and the loop range"
description: "LeetCode 1137 record from 2022-10-18"
date: 2022-10-18
tags: ["easy", "math", "dynamic-programming", "memoization"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-10-18
- Submissions: Wrong Answer ×3 → Accepted → Wrong Answer ×2 → Runtime Error ×2 → Accepted ×2 → Wrong Answer → Accepted

## Approach

`T(n) = T(n - 1) + T(n - 2) + T(n - 3)`: roll three variables ([Linear DP]({{< relref "/algorithm/Linear-DP" >}}) Template 1). Starting from `(T0, T1, T2) = (0, 1, 1)` and stepping `n` times leaves `T(n)` in the first variable, so `n = 0, 1, 2` need no special case.

## My Attempts

I wrote this four times (2022-10, twice in 2022-11, 2024) and failed 8 times, always on boundaries:

- The first 2022-10 version returned 0 for every `n < 3`, **but `T1` and `T2` are 1**; the loop `range(3, n)` stepped one short, so I returned `sum(T)` to compute one more term, and the boundaries kept misaligning.
- In 2024 there was no `n < 3` case, and with the loop skipped it returned `n3 = 1`: `n = 0` returned 1 instead of 0.

## Solution

```python
class Solution:
    def tribonacci(self, n: int) -> int:
        a, b, c = 0, 1, 1
        for _ in range(n):
            a, b, c = b, c, a + b + c
        return a
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- `T1` and `T2` are both 1, not 0.
- Off-by-one loop counts are easy; "step `n` times, return the first" avoids them.

## Interview Explanation

As with Fibonacci, I roll three variables from 0, 1, 1 forward n times and return the first, which also covers small n. Time `O(n)`.
