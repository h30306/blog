---
title: "LeetCode 2469: Convert the Temperature"
summary: "LeetCode 2469 note: apply the formulas directly, Kelvin = C + 273.15 and Fahrenheit = C × 1.8 + 32"
description: "LeetCode 2469 record from 2025-12-17"
date: 2025-12-17
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
First Attempt: 2025-12-17
- Submissions: Accepted (C++, first try)

## Approach

The problem gives both conversion formulas; apply them and return `[Kelvin, Fahrenheit]`. A `1e-5` tolerance is allowed, so floating-point arithmetic is fine.

## My Solution

I wrote it in C++; here is the equivalent Python:

```python
class Solution:
    def convertTemperature(self, celsius: float) -> List[float]:
        return [celsius + 273.15, celsius * 1.8 + 32]
```

## Complexity

Time `O(1)`, space `O(1)`.

## Mistakes to Avoid

- Kelvin comes first, then Fahrenheit.

## Interview Explanation

Apply both formulas and return them. With a `1e-5` tolerance, floating-point error does not matter. Time `O(1)`.
