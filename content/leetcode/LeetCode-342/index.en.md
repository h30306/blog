---
title: "LeetCode 342: Power of Four"
summary: "LeetCode 342 note: confirm a power of two, then that the single 1 sits at an even position: n & 0x55555555 != 0, or n % 3 == 1"
description: "LeetCode 342 record from 2022-08-23"
date: 2022-08-23
tags: ["easy", "math", "bit-manipulation", "recursion"]
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

A power of four is a power of two whose single 1 sits at bit 0, 2, 4, ... ([Bit Manipulation]({{< relref "/algorithm/Bit-Manipulation" >}})). `0x55555555` is `0101...01` in binary, exactly the even positions, so test `n & 0x55555555 != 0`. Alternatively `4^k = (3 + 1)^k ≡ 1 (mod 3)` while `2 × 4^k ≡ 2 (mod 3)`.

## My Attempts

Passed on the first try with `n > 0 and n & (n - 1) == 0 and n % 3 == 1`, the mod-3 test.

## Solution

```python
class Solution:
    def isPowerOfFour(self, n: int) -> bool:
        return n > 0 and n & (n - 1) == 0 and n & 0x55555555 != 0
```

## Complexity

Time `O(1)`, space `O(1)`.

## Mistakes to Avoid

- Checking a power of two is not enough: `2` and `8` are not powers of four.

## Interview Explanation

A power of four is a power of two with its 1 at an even position, so I check for a single bit with n & (n - 1) and its position by AND-ing with 0x55555555. Time `O(1)`.
