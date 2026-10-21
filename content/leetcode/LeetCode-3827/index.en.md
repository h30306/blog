---
title: "LeetCode 3827: Count Monobit Integers"
summary: "LeetCode 3827 note: the only numbers with all-equal bits are 0 and 2^k - 1, so the count is (n + 1).bit_length()"
description: "LeetCode 3827 record from 2026-02-01"
date: 2026-02-01
tags: ["easy", "bit-manipulation", "enumeration"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2026-02-01
- Submissions: Accepted (first try)

## Approach

All bits equal: all zeros is only 0, and all ones is `1, 3, 7, 15, ...`, i.e. `2^k - 1` ([Bit Manipulation]({{< relref "/algorithm/Bit-Manipulation" >}}) Template 3). `2^k - 1 <= n` means `2^k <= n + 1`, so `k` runs from 1 to `(n + 1).bit_length() - 1`; adding 0 gives `(n + 1).bit_length()` in total.

## My Solution

```python
class Solution:
    def countMonobit(self, n: int) -> int:
        return (n + 1).bit_length()
```

I originally looped, adding `2^power` starting from 1 to generate 1, 3, 7, ..., counting those `<= n` plus 0; same result.

## Complexity

Time `O(1)`, space `O(1)`.

## Mistakes to Avoid

- Do not forget that 0 counts.

## Interview Explanation

Numbers with all-equal bits are just 0 and `2^k - 1`. There are `(n + 1).bit_length() - 1` values of `k` with `2^k - 1 <= n`, plus 0. Time `O(1)`.
