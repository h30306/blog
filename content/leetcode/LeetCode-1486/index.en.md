---
title: "LeetCode 1486: XOR Operation in an Array"
summary: "LeetCode 1486 note: generate start + 2i by definition and XOR them together"
description: "LeetCode 1486 record from 2025-12-18"
date: 2025-12-18
tags: ["easy", "math", "bit-manipulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2025-12-18
- Submissions: Accepted (Python) → Accepted (C++) → Wrong Answer (C++) → Accepted (C++)

## Approach

The `i`-th number is `start + 2 * i`, and `n` is at most 1000, so XOR them one by one.

## My Attempts

Both Python and C++ passed first; rewriting the C++ later, I typed `n * i` instead of `2 * i`. For `n = 5`, `start = 0` the answer is `0 ^ 2 ^ 4 ^ 6 ^ 8 = 8`; that version computed `0 ^ 5 ^ 10 ^ 15 ^ 20 = 20`.

## Solution

```python
class Solution:
    def xorOperation(self, n: int, start: int) -> int:
        res = 0
        for i in range(n):
            res ^= start + 2 * i
        return res
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- The step is a fixed 2, not `n`.

## Interview Explanation

Generate each `start + 2i` by definition and accumulate the XOR in one variable. `n` is small so `O(n)` is enough; for `O(1)` there is the periodic formula for `1 ^ 2 ^ ... ^ k`.
