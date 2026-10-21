---
title: "LeetCode 762: Prime Number of Set Bits in Binary Representation"
summary: "LeetCode 762 note: numbers are below 10^6 < 2^20, so the set-bit count is at most 19; check it against a small set of primes"
description: "LeetCode 762 record from 2022-09-06"
date: 2022-09-06
tags: ["easy", "math", "bit-manipulation", "primality-test"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-09-06
- Submissions: Accepted (first try)

## Approach

With `right <= 10^6 < 2^20`, a set-bit count is at most 19, and the primes up to that are `2, 3, 5, 7, 11, 13, 17, 19`. Count each number's bits ([Bit Manipulation]({{< relref "/algorithm/Bit-Manipulation" >}})) and test membership.

## My Solution

```python
class Solution:
    def countPrimeSetBits(self, left: int, right: int) -> int:
        primes = {2, 3, 5, 7, 11, 13, 17, 19}
        return sum(bin(x).count("1") in primes for x in range(left, right + 1))
```

## Complexity

Time `O((right - left) · log right)`, space `O(1)`.

## Mistakes to Avoid

- 1 is not prime.

## Interview Explanation

Numbers in range have at most 20 bits, so the count is at most 19; I put the primes up to 19 in a set and check each number's count. Time is the range length times the bit count.
