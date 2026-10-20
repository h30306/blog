---
title: "LeetCode 3697: Compute Decimal Representation"
summary: "LeetCode 3697 note: each non-zero digit times its place value is one component; output them from the highest place down"
description: "LeetCode 3697 record from 2025-09-28"
date: 2025-09-28
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
First Attempt: 2025-09-28
- Submissions: Accepted (first try)

## Approach

A component is "one digit 1–9 × a power of 10", so each non-zero digit maps to exactly one component, e.g. `537 = 500 + 30 + 7`. Zero digits need none. That is the minimum, since each component covers only one digit.

Take digits from the low end with `% 10` while tracking the place value `place`, then reverse into descending order.

## My Solution

```python
class Solution:
    def decimalRepresentation(self, n: int) -> List[int]:
        res = []
        place = 1
        while n:
            d = n % 10
            if d:
                res.append(d * place)
            n //= 10
            place *= 10
        return res[::-1]                   # descending
```

I originally built each component as a string `f"{r}{'0' * zeros}"`; multiplying by `place` is more direct.

## Complexity

Time `O(d)` for `d` digits, space `O(d)`.

## Mistakes to Avoid

- Skip zero digits.
- Digits come out from the low end, so reverse at the end.

## Interview Explanation

Each non-zero digit times its place value is one component, and a component can only represent one digit, so this is minimal. I peel digits with `% 10`, skip zeros, and reverse into descending order. Time `O(d)`.
