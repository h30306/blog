---
title: "LeetCode 3959: Check Good Integer"
summary: "LeetCode 3959 note: accumulate the square sum minus the digit sum; each digit adds d² − d ≥ 0, so the gap never shrinks and you can return as soon as it reaches 50"
description: "LeetCode 3959 record from 2026-06-14"
date: 2026-06-14
tags: ["easy", "math", "simulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2026-06-14
- Submissions: Accepted (first try)

## Approach

`squareSum - digitSum` splits into a contribution of `d² - d` per digit. Since `d` is an integer 0–9, `d² - d = d(d - 1) >= 0`, so **the gap only grows**, and once it reaches `>= 50` you can return `True` right away.

## My Solution

```python
class Solution:
    def checkGoodInteger(self, n: int) -> bool:
        gap = 0
        while n:
            d = n % 10
            gap += d * d - d                 # each digit adds >= 0
            if gap >= 50:
                return True
            n //= 10
        return False
```

I originally tracked `sum_` and `sSum` separately and compared the difference; a single `gap` is the same thing.

## Complexity

Time `O(d)`, space `O(1)`.

## Mistakes to Avoid

- An early return needs the running value to be monotonic; if a digit could contribute a negative amount, you could not conclude midway.

## Interview Explanation

The gap is the sum of `d² - d` over the digits, which is never negative, so I accumulate as I go and return `True` at 50, or `False` after the last digit. Time `O(d)`.
