---
title: "LeetCode 326: Power of Three"
summary: "LeetCode 326 note: divide by 3 while possible and check for 1; without loops, n is a power of three exactly when it divides 3^19"
description: "LeetCode 326 record from 2022-08-23"
date: 2022-08-23
tags: ["easy", "math", "recursion"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-23
- Submissions: Accepted (first try)

## Approach

`n <= 0` never qualifies. With a loop: divide by 3 while `n % 3 == 0` and check that 1 remains. Without loops: the largest power of three in 32 bits is `3^19 = 1162261467`, and since 3 is prime its divisors are exactly the powers of three: `n > 0 and 3**19 % n == 0` ([Number Theory]({{< relref "/algorithm/Number-Theory" >}})).

## My Solution

```python
class Solution:
    def isPowerOfThree(self, n: int) -> bool:
        return n > 0 and 3**19 % n == 0
```

## Complexity

Time `O(1)`, space `O(1)`.

## Mistakes to Avoid

- Exclude `0` and negatives.
- The trick works only for powers of a prime: with a composite base such as 4, divisors of the top power need not be powers of it; `2` divides `4^15` but is not a power of 4.

## Interview Explanation

Since 3 is prime, every divisor of 3^19, the largest power of three in 32 bits, is a power of three, so I check that n is positive and divides 3^19. Time `O(1)`.
