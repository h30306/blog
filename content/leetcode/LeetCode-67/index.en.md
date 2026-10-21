---
title: "LeetCode 67: Add Binary"
summary: "LeetCode 67 note: add from the ends of both strings digit by digit, with carry sum // 2 and digit sum % 2"
description: "LeetCode 67 record from 2022-05-11"
date: 2022-05-11
tags: ["easy", "math", "string", "bit-manipulation", "simulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-05-11
- Submissions: Runtime Error ×2 → Wrong Answer ×5 → Accepted → Wrong Answer ×4 → Accepted

## Approach

The same column addition as in decimal ([Math]({{< relref "/algorithm/Math" >}}) Template 6) with base 2: from the ends, `total = a + b + carry`, write `total % 2` and carry `total // 2`, treating a finished string as 0, and append any final carry.

## My Attempts

This took 13 submissions:

- The 2022-05 approach was unusual: add the strings **as decimal numbers**, then turn each digit 2 or 3 into a carry. But result bits of 0 were never written: `"0" + "0"` returned an empty string and `"0" + "10"` returned `"1"`. Handling the 0 case passed.
- In 2022-08 I switched to digit-by-digit addition but padded with `ljust`, **on the right**, misaligning the digits, and the sum-0 branch also set the carry to 1: `"1" + "1"` returned `"0"`. `rjust` plus the final carry passed.

## Solution

```python
class Solution:
    def addBinary(self, a: str, b: str) -> str:
        i, j, carry, res = len(a) - 1, len(b) - 1, 0, []
        while i >= 0 or j >= 0 or carry:
            total = carry
            if i >= 0:
                total += int(a[i])
                i -= 1
            if j >= 0:
                total += int(b[j])
                j -= 1
            res.append(str(total % 2))
            carry = total // 2
        return "".join(reversed(res))
```

## Complexity

Time `O(max(n, m))`, space `O(max(n, m))`.

## Mistakes to Avoid

- Pad the shorter string on the **left** (`rjust`), not the right.
- Handle every sum (0, 1, 2, 3), including writing a 0.
- Append the final carry.

## Interview Explanation

As in decimal addition I add from the ends, writing the sum mod 2 and carrying the sum divided by 2, treating a finished string as 0 and appending the final carry. Time `O(max(n, m))`.
