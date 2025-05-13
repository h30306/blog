---
title: "LeetCode 1922: Count Good Numbers"
summary: "LeetCode Problem Solving"
description: "LeetCode Daily"
date: 2025-04-13
tags: ["LeetCode", "daily", "medium"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-04-13
- Total time: 15:00.00

## Intuition

This is a math problem that requires counting all possible combinations that satisfy the following conditions:

1. Digits at even indices must be even.
2. Digits at odd indices must be prime numbers.

If a digit string meets these conditions, we call it a **good number**.

My initial approach is to use exhaustive calculation. First, I determine how many even and odd positions are in the number. Then, I use `pow` to compute the total number of combinations by multiplying the number of valid choices at each position.

Finally, since the result can be very large, I return the answer modulo `10^9 + 7` as required by the problem.


## Approach
```python
class Solution:
    def countGoodNumbers(self, n: int) -> int:
        odd_count = n//2
        even_count = n//2
        
        if n%2: even_count+=1
        mod = 10**9+7

        return (pow(5, even_count, mod)*pow(4, odd_count, mod)) % mod
```
## Findings

1. Initially, I used a naive way to count the number of even and odd positions, but actually, it can be simplified using the following:

```python
even = (n + 1) // 2
odd = n // 2
```
Example:
If the length is odd (e.g., 123, n = 3):
→ (3 + 1) // 2 = 2 even positions

If the length is even (e.g., 12, n = 2):
→ (2 + 1) // 2 = 1 even position

This works because indexing starts from 0, so positions 0, 2, 4... are considered "even indices".

## Encountered Problems 
1. I returned
```python
return (pow(5, even_count)*pow(4, odd_count)) % mod
```
and encounter TLE issue, to avoid overflow caused by handling huge numbers before applying the modulo, we can apply the modulo during the multiplication steps — that is, take the modulo before each multiplication to keep the intermediate results within a safe range.
```python
return (pow(5, even_count, mod)*pow(4, odd_count, mod)) % mod
```

