---
title: "LeetCode 728: Self Dividing Numbers"
summary: "LeetCode 728 note: check every number in the range; each digit must be nonzero and divide the number"
description: "LeetCode 728 record from 2022-08-31"
date: 2022-08-31
tags: ["easy", "math"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-31
- Submissions: Wrong Answer ×2 → Runtime Error ×3 → Wrong Answer → Runtime Error ×7 → Accepted ×2 → Runtime Error ×2 → Accepted

## Approach

The range is small (at most `10^4`), so check each number. Peel digits with `% 10` and `// 10` ([Math]({{< relref "/algorithm/Math" >}}) Template 5): any **0** digit disqualifies it (no division by zero, and the problem forbids zeros), otherwise require `x % d == 0`.

## My Attempts

This took 18 submissions:

- Attempt 1 forgot the `return`; attempt 2 tested divisibility with `//`, and `i // d != 0` is almost always true, so every two-digit number was excluded: `(2, 11)` lost `11`.
- After switching to `%`, numbers with a 0 such as `10` raised ZeroDivisionError for a dozen more tries. One version skipped the 0 digit instead, **which let `10` in**, though a number containing 0 is never self-dividing.
- A helper that returns `False` on a 0 digit finally passed.

## Solution

```python
class Solution:
    def selfDividingNumbers(self, left: int, right: int) -> List[int]:
        def ok(x):
            n = x
            while n:
                d = n % 10
                if d == 0 or x % d:
                    return False
                n //= 10
            return True
        return [x for x in range(left, right + 1) if ok(x)]
```

## Complexity

Time `O((right - left) · log right)`, space `O(1)` excluding output.

## Mistakes to Avoid

- Divisibility needs `%`, not `//`.
- A number containing 0 is disqualified, not just that digit skipped.

## Interview Explanation

I check each number in the range, peeling digits with modulo; a zero digit or a non-divisor disqualifies it. Time is the range length times the digit count.
