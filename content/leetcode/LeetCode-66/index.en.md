---
title: "LeetCode 66: Plus One"
summary: "LeetCode 66 note: add one from the last digit, turning 9s into 0s while carrying, and prepend 1 when every digit was 9"
description: "LeetCode 66 record from 2022-05-11"
date: 2022-05-11
tags: ["easy", "array", "math"]
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
- Submissions: Runtime Error ×3 → Wrong Answer → Accepted ×4 → Runtime Error ×2 → Accepted → Wrong Answer ×4 → Accepted ×3

## Approach

Column addition ([Math]({{< relref "/algorithm/Math" >}}) Template 6): from the last digit, a non-9 digit just increments and we return; a 9 becomes 0 and the carry moves left. If the loop finishes, every digit was 9, so prepend a 1.

## My Attempts

The early versions all converted to an integer, added one and split it back:

- 2022-05: `''.join(digits)` on integers raised TypeError; after fixing that, `str(...).split()` **splits on whitespace, so the whole number is one element**: `[9]` returned `[10]` instead of `[1, 0]`.
- 2022-08 computed `digits[i] * 10 ** k` by hand: first as `10^k`, **but `^` is XOR in Python**: `[1]` returned `[1, 1]`; then `10**len(digits)-1-i` **lacked parentheses** and meant `10**len - 1 - i`: `[1]` returned `[1, 0]`.
- In 2022-10 I switched to the digit-by-digit carry above.

## Solution

```python
class Solution:
    def plusOne(self, digits: List[int]) -> List[int]:
        for i in range(len(digits) - 1, -1, -1):
            if digits[i] < 9:
                digits[i] += 1
                return digits
            digits[i] = 0
        return [1] + digits
```

## Complexity

Time `O(n)`, space `O(1)` apart from the new array when every digit is 9.

## Mistakes to Avoid

- `10^k` is XOR in Python; powers are `10**k`, and `10**len - 1 - i` needs parentheses.
- Return a list of digits; `str(...).split()` produces a single element.

## Interview Explanation

I carry from the last digit: a non-9 increments and returns, a 9 becomes 0 and the carry continues, and an all-9 array gets a leading 1. Time `O(n)` without converting to an integer.
