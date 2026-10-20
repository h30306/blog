---
title: "LeetCode 2269: Find the K-Beauty of a Number"
summary: "LeetCode 2269 note: convert the number to a string and check every length-k substring; 0 cannot be a divisor"
description: "LeetCode 2269 record from 2026-01-04"
date: 2026-01-04
tags: ["easy", "sliding-window", "math", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2026-01-04
- Submissions: Runtime Error → Accepted

## Approach

Convert `num` to a string; each length-`k` substring is a fixed window. After converting back to an integer:

- Skip it if it is 0 (0 divides nothing and cannot be used as a divisor).
- Otherwise check `num % sub == 0`.

Leading zeros are allowed: `int("04")` is 4.

## My Attempts

Attempt 1 ended with `return len(res)`, but `res` was an integer counter, so `len()` raised TypeError. `return res` passed.

## Solution

```python
class Solution:
    def divisorSubstrings(self, num: int, k: int) -> int:
        s = str(num)
        count = 0
        for right in range(k - 1, len(s)):
            sub = int(s[right - k + 1:right + 1])
            if sub and num % sub == 0:             # 0 is never a divisor
                count += 1
        return count
```

`num` has at most 10 digits, so converting each slice is negligible; for strict `O(n)`, roll the value with `sub = sub * 10 + new_digit - old_digit * 10^k`.

## Complexity

Time `O(n · k)` with `n` digits, space `O(n)`.

## Mistakes to Avoid

- Dividing by a substring equal to 0: ZeroDivisionError.
- Calling `len()` on an integer.

## Interview Explanation

I turn the number into a string, convert every length-`k` substring back to an integer, and count it if it is non-zero and divides `num`. With at most 10 digits slicing is fast enough; to be strict, the substring value can be rolled forward instead.
