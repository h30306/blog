---
title: "LeetCode 258: Add Digits"
summary: "LeetCode 258 note: sum the digits repeatedly until one remains; the O(1) answer is the digital root 1 + (n - 1) % 9"
description: "LeetCode 258 record from 2022-08-22"
date: 2022-08-22
tags: ["easy", "math", "simulation", "number-theory"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-22
- Submissions: Runtime Error ×2 → Accepted ×4

## Approach

Simulate: keep summing digits until a single digit remains ([Math]({{< relref "/algorithm/Math" >}}) Template 5). For the `O(1)` follow-up: a number and its digit sum agree modulo 9 (since `10 ≡ 1 (mod 9)`), so the final digit is `n mod 9`, except that multiples of 9 give 9 rather than 0: `0 if n == 0 else 1 + (n - 1) % 9`.

## My Attempts

The first two used `sum(list(str(num)))`, **adding characters** (TypeError), and attempt 1 also misnamed the parameter `nums`. Converting to `int` first passed; In 2025 I rewrote it in Python and in C++. Every time I simulated rather than using the formula.

## Solution

```python
class Solution:
    def addDigits(self, num: int) -> int:
        return 0 if num == 0 else 1 + (num - 1) % 9
```

## Complexity

Time `O(1)`, space `O(1)`.

## Mistakes to Avoid

- `sum(list(str(n)))` adds characters; convert to `int` first.
- The formula must handle 0 and multiples of 9.

## Interview Explanation

Simulation sums digits repeatedly; in `O(1)`, a number and its digit sum are congruent mod 9, so the answer is 1 + (n - 1) % 9, with 0 for n = 0.
