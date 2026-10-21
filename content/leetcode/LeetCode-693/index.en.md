---
title: "LeetCode 693: Binary Number with Alternating Bits"
summary: "LeetCode 693 note: alternating bits means the binary string has neither 00 nor 11; in bits, n ^ (n >> 1) is all ones"
description: "LeetCode 693 record from 2022-08-30"
date: 2022-08-30
tags: ["easy", "bit-manipulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-30
- Submissions: Wrong Answer → Accepted ×4

## Approach

With strings: `bin(n)` must contain neither `"00"` nor `"11"`. With bits ([Bit Manipulation]({{< relref "/algorithm/Bit-Manipulation" >}})): alternating bits make every bit of `x = n ^ (n >> 1)` a 1, and `x & (x + 1) == 0` checks that it is all ones.

## My Attempts

Attempt 1 wrote `'00' in s or '11' in s`, **the exact opposite**: `2` (`10`) returned `False`. `not in ... and not in` passed.

## Solution

```python
class Solution:
    def hasAlternatingBits(self, n: int) -> bool:
        x = n ^ (n >> 1)
        return x & (x + 1) == 0
```

## Complexity

Time `O(1)`, space `O(1)`.

## Mistakes to Avoid

- The condition is **no** `00` **and no** `11`; do not invert it.

## Interview Explanation

With alternating bits, n XOR (n >> 1) is all ones, which I verify with x & (x + 1) == 0. Time `O(1)`.
