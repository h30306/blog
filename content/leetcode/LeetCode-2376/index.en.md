---
title: "LeetCode 2376: Count Special Integers"
summary: "LeetCode 2376 note: digit DP with state (pos, tight, started, mask); the mask records used digits, and leading zeros must not mark 0 as used"
description: "LeetCode 2376 record from 2026-09-05"
date: 2026-09-05
tags: ["hard", "dynamic-programming", "digit-dp", "math", "bitmask"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-09-05
- Submissions: Accepted ×2

## Approach

Count numbers in `[1, n]` whose digits are all distinct. A digit DP with state `(pos, tight, started, mask)`:

- `mask`: 10 bits of used digits; this position cannot choose a digit in `mask`.
- `started`: **leading zeros do not use up 0**. Before starting, a 0 leaves `mask` unchanged; recording begins with the first non-zero digit.
- At the end, only a `started` number counts as a positive integer.

## My Solution

```python
from functools import cache

class Solution:
    def countSpecialNumbers(self, n: int) -> int:
        s = str(n)

        @cache
        def dfs(i: int, tight: bool, started: bool, mask: int) -> int:
            if i == len(s):
                return 1 if started else 0
            hi = int(s[i]) if tight else 9
            count = 0
            for d in range(hi + 1):
                if mask >> d & 1:
                    continue                       # digit already used
                now_started = started or d != 0
                new_mask = mask | (1 << d) if now_started else mask   # leading zeros are not recorded
                count += dfs(i + 1, tight and d == hi, now_started, new_mask)
            return count

        return dfs(0, True, False, 0)
```

## Complexity

At most `10 × 2 × 2 × 2^10` states with 10 digits each, about `4 × 10^5`.

## Mistakes to Avoid

- Recording leading zeros as a used 0: numbers like `10` get misjudged.
- Both `mask` and `started` must be part of the cache key.

## Interview Explanation

A digit DP whose state is the position, whether it still matches `n`, whether the number has started, and a mask of used digits. A digit in the mask cannot be chosen; before starting, a 0 is not added to the mask, because leading zeros are not real digits. Only a started number counts at the end. There are `10 × 4 × 1024` states, very few.
