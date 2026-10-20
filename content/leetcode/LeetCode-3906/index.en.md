---
title: "LeetCode 3906: Count Good Integers on a Grid Path"
summary: "LeetCode 3906 note: the range reaches 9 × 10^15, so no per-number checks; a digit DP carries both lower and upper tight flags, plus the previous digit on the path since path cells must be non-decreasing"
description: "LeetCode 3906 record from 2026-04-19"
date: 2026-04-19
tags: ["hard", "dynamic-programming", "digit-dp"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-04-19
- Submissions: Time Limit Exceeded → Accepted (2026-07-29)

## Approach

Each number is padded to 16 digits in a 4 × 4 grid and walked from the top-left following `directions`; the 7 visited digits must be **non-decreasing**.

First compute the path's cell indices (`D` is `+4`, `R` is `+1`) as a set `path`. The task becomes: count 16-digit strings (leading zeros allowed) in `[l, r]` whose digits at the `path` positions are non-decreasing.

A **digit DP** with state `(pos, tight_low, tight_high, prev)`:

- `tight_low` / `tight_high`: whether the prefix still matches `l` / `r`, setting this digit's lower and upper limits.
- `prev`: the previous digit on the path. If `pos` is on the path, this digit must be at least `prev`, and `prev` updates after choosing.

With a fixed 16-digit width, leading zeros are ordinary 0 digits, so no `started` state is needed.

## My Attempts

Attempt 1 checked every number from `l` to `r`, a range up to `9 × 10^15`: TLE. Three months later a digit DP passed.

## Solution

```python
from functools import cache

class Solution:
    def countGoodIntegersOnPath(self, l: int, r: int, directions: str) -> int:
        low = list(map(int, str(l).zfill(16)))
        high = list(map(int, str(r).zfill(16)))
        path = {0}
        idx = 0
        for d in directions:
            idx += 4 if d == "D" else 1
            path.add(idx)

        @cache
        def dfs(pos: int, tight_low: bool, tight_high: bool, prev: int) -> int:
            if pos == 16:
                return 1
            lo = low[pos] if tight_low else 0
            hi = high[pos] if tight_high else 9
            if pos in path:
                lo = max(lo, prev)                 # non-decreasing along the path
            total = 0
            for d in range(lo, hi + 1):
                total += dfs(pos + 1,
                             tight_low and d == low[pos],
                             tight_high and d == high[pos],
                             d if pos in path else prev)
            return total

        return dfs(0, True, True, 0)
```

## Complexity

`16 × 2 × 2 × 10` states with 10 digits each: constant time.

## Mistakes to Avoid

- Checking every number in the range.
- Compare the lower tight flag with `low[pos]` and the upper with `high[pos]`; they cannot share one.
- Positions off the path do not update `prev`.

## Interview Explanation

The range is too large, so I use a digit DP. I first compute which positions the path visits; the state is the position, tight flags for both bounds, and the previous digit on the path. At path positions the lower limit rises to that previous digit. Numbers are padded to 16 digits, so leading zeros are plain 0s. The state count is constant.
