---
title: "LeetCode 405: Convert a Number to Hexadecimal"
summary: "LeetCode 405 note: add 2^32 to a negative number to get its two's complement, then take 4 bits at a time (% 16); handle 0 separately"
description: "LeetCode 405 record from 2022-08-23"
date: 2022-08-23
tags: ["easy", "math", "string", "bit-manipulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-23
- Submissions: Runtime Error ×2 → Wrong Answer ×2 → Accepted

## Approach

Each hex digit is 4 bits ([Bit Manipulation]({{< relref "/algorithm/Bit-Manipulation" >}}); also base conversion from [Math]({{< relref "/algorithm/Math" >}}) Template 7). Negatives use 32-bit two's complement, and `num & 0xffffffff` (adding `2^32`) gives the matching non-negative value. Then repeatedly look up `num & 15` and shift `num >>= 4` until 0. For `num = 0` the loop never runs, so return `"0"`.

## My Attempts

- Attempt 1 looped while `num > 15`, **dropping the last digit**, and returned an empty string for `num = 0`.
- After adding the `0` case, **negatives were unhandled**: `-9` returned an empty string instead of `"fffffff7"`. Adding `num += 2**32` passed.

## Solution

```python
class Solution:
    def toHex(self, num: int) -> str:
        if num == 0:
            return "0"
        num &= 0xFFFFFFFF
        digits = "0123456789abcdef"
        res = []
        while num:
            res.append(digits[num & 15])
            num >>= 4
        return "".join(reversed(res))
```

## Complexity

Time `O(8)`, space `O(1)`.

## Mistakes to Avoid

- Convert negatives to 32-bit two's complement first.
- Loop while `num > 0`; `num > 15` drops the last digit.
- `0` returns `"0"`.

## Interview Explanation

I AND negatives with 0xffffffff to get the two's-complement value, then repeatedly map the lowest 4 bits and shift by 4, reversing at the end; 0 returns directly. At most 8 digits.
