---
title: "LeetCode 3622: Check Divisibility by Digit Sum and Product"
summary: "LeetCode 3622 note: compute the digit sum and product and test n % (sum + product) == 0, keeping the modulo the right way around"
description: "LeetCode 3622 record from 2025-07-20"
date: 2025-07-20
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
First Attempt: 2025-07-20
- Submissions: Wrong Answer → Accepted

## Approach

`n` must be divisible by "digit sum + digit product", i.e. `n % (sum + product) == 0`. The digit sum is at least 1, so the divisor is never 0.

## My Attempts

Attempt 1 wrote `(product + sum) % n == 0`, the wrong way around. For `n = 2` the sum and product are both 2, and `2 % 4 = 2`, so the answer is `False`; it computed `4 % 2 = 0` and returned `True`.

## Solution

```python
from math import prod

class Solution:
    def checkDivisibility(self, n: int) -> bool:
        digits = [int(c) for c in str(n)]
        return n % (sum(digits) + prod(digits)) == 0
```

## Complexity

Time `O(d)`, space `O(d)`.

## Mistakes to Avoid

- "`n` divisible by `x`" is `n % x == 0`, not `x % n == 0`.

## Interview Explanation

I split `n` into digits, compute their sum and product, and check whether `n` modulo their total is 0. Time `O(d)`.
