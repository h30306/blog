---
title: "LeetCode 461: Hamming Distance"
summary: "LeetCode 461 note: each 1 in x ^ y is a differing bit, so count the ones"
description: "LeetCode 461 record from 2022-08-24"
date: 2022-08-24
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
First Attempt: 2022-08-24
- Submissions: Accepted ×2

## Approach

XOR is 1 exactly where the bits differ, so the Hamming distance is the number of 1s in `x ^ y` ([Bit Manipulation]({{< relref "/algorithm/Bit-Manipulation" >}})). Count them with `bin(z).count("1")` or by repeating `z &= z - 1`, which clears the lowest 1 each time.

## My Solution

```python
class Solution:
    def hammingDistance(self, x: int, y: int) -> int:
        z, count = x ^ y, 0
        while z:
            z &= z - 1
            count += 1
        return count
```

## Complexity

Time `O(number of bits)`, space `O(1)`.

## Mistakes to Avoid

- `z & (z - 1)` clears one 1 per step, so the loop runs once per set bit.

## Interview Explanation

XOR marks differing bits, so I compute x XOR y and count its 1s by clearing one at a time with z & (z - 1). Time is the number of set bits.
