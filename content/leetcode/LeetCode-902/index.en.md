---
title: "LeetCode 902: Numbers At Most N Given Digit Set"
summary: "LeetCode 902 note: digit DP with state (pos, tight, started); before starting, a position can be skipped, representing numbers with fewer digits than n"
description: "LeetCode 902 record from 2026-07-27"
date: 2026-07-27
tags: ["hard", "dynamic-programming", "digit-dp", "math", "binary-search", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-07-27
- Submissions: Accepted (first try)

## Approach

Count positive integers `<= n` using only the given digits (no 0). A digit DP with state `(pos, tight, started)`:

- `tight`: whether the prefix still matches `n`. While tight, this digit must be `<= n[pos]`.
- `started`: whether the number has begun. **Before starting, a position may be skipped**, giving a number with fewer digits than `n`; that is always smaller than `n`, so `tight` becomes `False`.
- At the end, only a `started` number counts (not the empty one).

## My Solution

```python
from functools import cache

class Solution:
    def atMostNGivenDigitSet(self, digits: List[str], n: int) -> int:
        s = str(n)

        @cache
        def dfs(i: int, tight: bool, started: bool) -> int:
            if i == len(s):
                return 1 if started else 0
            res = 0
            if not started:
                res += dfs(i + 1, False, False)    # skip: a number with fewer digits
            for d in digits:                       # digits are sorted
                if tight and d > s[i]:
                    break
                res += dfs(i + 1, tight and d == s[i], True)
            return res

        return dfs(0, True, False)
```

My accepted version did not check `started` at the end; it only allowed skipping before the last position (`index != len - 1`), which also avoids counting the empty number.

Alternatively, count directly: numbers with fewer digits than `n` total `Σ |D|^k`, and equal-length numbers are compared digit by digit.

## Complexity

Time `O(len(n) · |digits|)`, space `O(len(n))`.

## Mistakes to Avoid

- After skipping a position, `tight` must become `False`.
- "Skip every position" is not a number.

## Interview Explanation

A digit DP whose state is the position, whether it still matches `n`, and whether the number has started. Before starting, skipping a position represents a shorter number, which is always below `n`; once started, each position picks from the given digits, not exceeding `n`'s digit while tight. Only a started number counts at the end. Time `O(len(n) · |digits|)`.
