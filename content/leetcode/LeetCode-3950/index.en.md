---
title: "LeetCode 3950: Exactly One Consecutive Set Bits Pair"
summary: "LeetCode 3950 note: each 1 in n & (n >> 1) marks a pair of adjacent ones, so exactly one pair means it has a single 1"
description: "LeetCode 3950 record from 2026-06-11"
date: 2026-06-11
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
First Attempt: 2026-06-11
- Submissions: Accepted (first try)

## Approach

`n >> 1` shifts every bit right by one; ANDing with `n`, bit `i` is 1 when bits `i` and `i + 1` of `n` are both 1 ([Bit Manipulation]({{< relref "/algorithm/Bit-Manipulation" >}}) Template 2). So the number of ones in `pairs = n & (n >> 1)` is the number of adjacent pairs; exactly one means `pairs` is non-zero with a single 1. Overlapping pairs count, e.g. `111` has two.

## My Solution

```python
class Solution:
    def consecutiveSetBits(self, n: int) -> bool:
        pairs = n & (n >> 1)
        return pairs != 0 and pairs & (pairs - 1) == 0
```

I originally converted `bin(n)` to a string and counted `"11"` position by position, which also counts overlaps.

## Complexity

Time `O(1)`, space `O(1)`.

## Mistakes to Avoid

- `str.count("11")` skips overlaps (`"111".count("11")` is 1); compare position by position or use bit operations.

## Interview Explanation

Each 1 in `n & (n >> 1)` marks one adjacent pair, so I check it is non-zero and that `x & (x - 1)` is 0, i.e. exactly one 1. Time `O(1)`.
