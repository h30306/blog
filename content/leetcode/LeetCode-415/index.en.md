---
title: "LeetCode 415: Add Strings"
summary: "LeetCode 415 note: add digit by digit from the ends with two pointers, tracking the carry, and append any leftover carry after the loop"
description: "LeetCode 415 record from 2022-08-24"
date: 2022-08-24
tags: ["easy", "math", "string", "simulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-24
- Submissions: Runtime Error ×4 → Wrong Answer ×2 → Accepted

## Approach

Column addition ([Math]({{< relref "/algorithm/Math" >}}) Template 6): `i` and `j` walk from the ends of the two strings, treating a finished one as 0. Each step computes `total = a + b + carry`, writes `total % 10` and carries `total // 10`. **If a carry remains after the loop**, append one more digit. Reverse at the end.

## My Attempts

This took 7 submissions:

- Attempt 1 was a syntax error, then `i = j = len(num1) - 1, len(num2) - 1` **made both variables the same tuple** (TypeError); the next two forgot to convert characters to `int`.
- After that **the final carry was dropped**: `"8" + "6"` returned `"4"`. The next version appended `total` instead of the carry `temp`, returning `"44"`. Appending `temp` passed.

## Solution

```python
class Solution:
    def addStrings(self, num1: str, num2: str) -> str:
        i, j, carry = len(num1) - 1, len(num2) - 1, 0
        res = []
        while i >= 0 or j >= 0 or carry:
            a = int(num1[i]) if i >= 0 else 0
            b = int(num2[j]) if j >= 0 else 0
            carry, d = divmod(a + b + carry, 10)
            res.append(str(d))
            i, j = i - 1, j - 1
        return "".join(reversed(res))
```

## Complexity

Time `O(max(n, m))`, space `O(max(n, m))`.

## Mistakes to Avoid

- Append the final carry: `"8" + "6"` is `"14"`.
- Append the carry, not the last `total`.
- `i = j = a, b` makes both variables tuples.

## Interview Explanation

Two pointers add digits from the ends, treating a finished string as 0 and tracking the carry; putting the carry in the loop condition keeps the final one, and I reverse the result. Time `O(max(n, m))`.
