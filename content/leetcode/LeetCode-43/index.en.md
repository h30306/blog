---
title: "LeetCode 43: Multiply Strings"
summary: "LeetCode 43 note: num1[i] × num2[j] lands at position i + j + 1; accumulate into an array of length n + m and carry at the end"
description: "LeetCode 43 record from 2022-10-21"
date: 2022-10-21
tags: ["medium", "math", "string", "simulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-10-21
- Submissions: Runtime Error ×2 → Wrong Answer ×5 → Accepted

## Approach

Long multiplication ([Math]({{< relref "/algorithm/Math" >}}) Template 6): an `n`-digit times an `m`-digit number has at most `n + m` digits. Add `num1[i] * num2[j]` into `res[i + j + 1]` (counted from the left); **every pair of digits must be multiplied**, `n × m` products in all. Then carry from right to left and strip leading zeros, keeping one if everything is zero.

## My Attempts

This took 8 submissions:

- The 2022-10 versions used `zip(num1, num2)` and **multiplied only digits at matching positions**, which is not multiplication at all: `"4" × "12"` computed only `4 × 1` (or `4 × 2` after reversing), returning `"4"` and `"8"` instead of `"48"`. Earlier ones also appended integers to a string (TypeError) and returned the integer `0` instead of `"0"`.
- A 2022-11 rewrite did real long multiplication, one shifted partial product per digit, summed together. It still returned an integer the first time; returning `str` passed. **That version sums the partial products as Python `int`s**, which strictly sidesteps the no-conversion rule; the array approach above needs none.

## Solution

```python
class Solution:
    def multiply(self, num1: str, num2: str) -> str:
        n, m = len(num1), len(num2)
        res = [0] * (n + m)
        for i in range(n - 1, -1, -1):
            for j in range(m - 1, -1, -1):
                res[i + j + 1] += int(num1[i]) * int(num2[j])
        for k in range(n + m - 1, 0, -1):
            res[k - 1] += res[k] // 10
            res[k] %= 10
        s = "".join(map(str, res)).lstrip("0")
        return s or "0"
```

## Complexity

Time `O(nm)`, space `O(n + m)`.

## Mistakes to Avoid

- Multiplying digits only at matching positions is wrong; each digit multiplies every digit of the other number.
- Return a string, not an integer.
- Converting to integers is forbidden; summing partial products as `int` also sidesteps the rule.
- Strip leading zeros but keep `"0"`.

## Interview Explanation

I allocate n + m slots, add digit i of num1 times digit j of num2 into slot i + j + 1, carry from right to left once everything is added, and strip leading zeros. Time `O(nm)` without integer conversion.
