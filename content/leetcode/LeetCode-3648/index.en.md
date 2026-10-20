---
title: "LeetCode 3648: Minimum Sensors to Cover Grid"
summary: "LeetCode 3648 note: each sensor covers a (2k + 1) × (2k + 1) square, so take a ceiling division in each direction and multiply"
description: "LeetCode 3648 record from 2025-08-16"
date: 2025-08-16
tags: ["medium", "math"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-08-16
- Submissions: Wrong Answer → Accepted

## Approach

Chebyshev distance `<= k` covers a square of side `2k + 1`. The two directions are independent:

- Rows need `ceil(n / (2k + 1))` sensors.
- Columns need `ceil(m / (2k + 1))`.

The answer is the product.

## My Attempts

Attempt 1 wrote `n // (2k + 1) + 1`, **one too many when it divides evenly**. For `n = 9`, `m = 3`, `k = 0` each sensor covers only itself, so the answer is 27; it computed `10 × 4 = 40`. Adding 1 only when there is a remainder passed.

## Solution

```python
class Solution:
    def minSensors(self, n: int, m: int, k: int) -> int:
        side = 2 * k + 1
        return -(-n // side) * -(-m // side)       # ceiling division
```

## Complexity

Time `O(1)`, space `O(1)`.

## Mistakes to Avoid

- Ceiling division as `a // b + 1`: one too many on exact division. Use `-(-a // b)` or `(a + b - 1) // b`.
- Testing divisibility with floating point `a / b == a // b`: large values can be inexact.

## Interview Explanation

Each sensor covers a square of side `2k + 1`, and rows and columns are independent, needing `n` and `m` divided by the side with rounding up; their product is the answer. Time `O(1)`.
