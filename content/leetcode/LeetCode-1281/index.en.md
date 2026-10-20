---
title: "LeetCode 1281: Subtract the Product and Sum of Digits of an Integer"
summary: "LeetCode 1281 note: walk the digits once, accumulating product and sum, and return product minus sum"
description: "LeetCode 1281 record from 2025-12-23"
date: 2025-12-23
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
First Attempt: 2025-12-23
- Submissions: Accepted (C++, first try)

## Approach

Walk every digit, multiplying into a product that starts at 1 and adding into a sum that starts at 0, then return `product - sum`.

## My Solution

I used C++ `to_string` to walk the digits; here is the equivalent Python:

```python
class Solution:
    def subtractProductAndSum(self, n: int) -> int:
        product, total = 1, 0
        while n:
            d = n % 10
            product *= d
            total += d
            n //= 10
        return product - total
```

## Complexity

Time `O(d)`, space `O(1)`.

## Mistakes to Avoid

- The product starts at 1, not 0.

## Interview Explanation

Peel digits with `% 10`, accumulating the product and sum together, then subtract. Time `O(d)`.
