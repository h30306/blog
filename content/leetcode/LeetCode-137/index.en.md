---
title: "LeetCode 137: Single Number II"
summary: "LeetCode 137 note: with everything else appearing three times, count the 1s at each bit modulo 3; the leftover bits form the answer, minding negatives"
description: "LeetCode 137 record from 2022-11-10"
date: 2022-11-10
tags: ["medium", "array", "bit-manipulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-11-10
- Submissions: Accepted (first try)

## Approach

XOR cancels pairs only. Count per bit instead ([Bit Manipulation]({{< relref "/algorithm/Bit-Manipulation" >}})): summing bit `b` over all numbers, each triple contributes a multiple of 3, so `count % 3` is the answer's bit. Python integers are unbounded, so work in 32 bits: if bit 31 is set the answer is negative, so subtract `2^32`.

## My Attempts

Passed on the first try by sorting and checking groups of three with `nums[i] != nums[i + 2]`, the first broken group holding the answer; sorting is `O(n log n)`, missing the linear-time requirement.

## Solution

```python
class Solution:
    def singleNumber(self, nums: List[int]) -> int:
        res = 0
        for b in range(32):
            if sum((x >> b) & 1 for x in nums) % 3:
                res |= 1 << b
        return res - (1 << 32) if res >> 31 else res
```

## Complexity

Time `O(32n)`, space `O(1)`.

## Mistakes to Avoid

- Python's right shift of a negative fills with 1s, so `(x >> b) & 1` for `b < 32` is exactly the two's-complement bit.
- Convert a result with bit 31 set back to a negative number.

## Interview Explanation

Since the others appear three times, I count each bit's 1s across all numbers and take it modulo 3 to get the answer's bit; with unbounded Python integers, a result with bit 31 set is converted back to a negative. Time `O(32n)`, space `O(1)`.
