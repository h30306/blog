---
title: "LeetCode 7: Reverse Integer"
summary: "LeetCode 7 note: remember the sign, reverse the digits of the absolute value, and return 0 when the result leaves the signed 32-bit range"
description: "LeetCode 7 record from 2019-09-16"
date: 2019-09-16
tags: ["medium", "math"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2019-09-16
- Submissions: Wrong Answer → Accepted ×8

## Approach

Remember the sign, reverse the digits of `abs(x)` with `% 10` and `// 10` ([Math]({{< relref "/algorithm/Math" >}}) Template 5), then restore the sign. Return 0 if the result leaves `[-2^31, 2^31 - 1]`. Python integers do not overflow, so checking at the end is fine; in C++ or Java check before each multiplication by 10.

## My Attempts

In 2019 the first version dropped the minus sign via `str(x)[:0:-1]` **and never put it back**: `-29` returned `92`. Restoring the sign passed.

## Solution

```python
class Solution:
    def reverse(self, x: int) -> int:
        sign = -1 if x < 0 else 1
        x, rev = abs(x), 0
        while x:
            rev = rev * 10 + x % 10
            x //= 10
        rev *= sign
        return rev if -2**31 <= rev <= 2**31 - 1 else 0
```

## Complexity

Time `O(log x)`, space `O(1)`.

## Mistakes to Avoid

- Restore the minus sign after reversing a negative number.
- Check the range on the reversed result.

## Interview Explanation

I save the sign, reverse the absolute value digit by digit, restore the sign, and return 0 outside the signed 32-bit range. Python cannot overflow, so a final check suffices; other languages must check before each multiplication by 10.
