---
title: "LeetCode 3750: Minimum Number of Flips to Reverse Binary String"
summary: "LeetCode 3750 note: compare the binary string with its reverse bit by bit; the number of mismatches is the answer"
description: "LeetCode 3750 record from 2025-11-22"
date: 2025-11-22
tags: ["easy", "two-pointers", "bit-manipulation", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2025-11-22
- Submissions: Accepted (first try)

## Approach

Write `n` as a binary string `s` without leading zeros and turn it into its own reverse, one bit flip at a time.

Position `i` must become `s[len - 1 - i]`, and needs one flip when they differ, so the answer is the number of positions where `s` and its reverse differ.

From a converging-pointer view: for each pair `i` and `len - 1 - i`, if the two characters differ, both must flip, so every mismatched pair contributes 2.

## My Solution

```python
class Solution:
    def minimumFlips(self, n: int) -> int:
        s = bin(n)[2:]
        return sum(a != b for a, b in zip(s, reversed(s)))
```

My original built the reversed string first and compared position by position in a loop, which is the same logic.

## Complexity

Time `O(log n)`, space `O(log n)`.

## Mistakes to Avoid

- Forgetting to strip the leading `0b` from `bin(n)`.
- Reversing into "another number" and comparing values: the comparison is bit by bit.

## Interview Explanation

I convert `n` to a binary string and compare it with its reverse position by position; the number of mismatches is the number of flips, since each mismatched bit needs exactly one flip. Time is proportional to the number of bits, `O(log n)`.
