---
title: "LeetCode 231: Power of Two"
summary: "LeetCode 231 note: a power of two has exactly one set bit, and n & (n - 1) clears the lowest one, so the result is 0 exactly then; n must be positive"
description: "LeetCode 231 record from 2022-08-22"
date: 2022-08-22
tags: ["easy", "math", "bit-manipulation", "recursion"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-22
- Submissions: Wrong Answer ×3 → Accepted → Wrong Answer → Accepted

## Approach

`n & (n - 1)` clears the lowest set bit ([Bit Manipulation]({{< relref "/algorithm/Bit-Manipulation" >}})). A power of two has a single 1, so the result is 0. Zero and negatives are not powers of two and must be excluded.

## My Attempts

- Attempt 1 wrote `(n > 0) & (n & (n - 1)) == 0`; **`&` binds tighter than `==`**, so `n = 0` became `(False & 0) == 0` and returned `True`.
- The next dropped `== 0`, meaning "`n & (n - 1)` is nonzero", **the opposite**: `4` returned 0. A 2022-11 rewrite repeated `n > 0 and n & (n - 1)`; adding `not` passed.

## Solution

```python
class Solution:
    def isPowerOfTwo(self, n: int) -> bool:
        return n > 0 and n & (n - 1) == 0
```

## Complexity

Time `O(1)`, space `O(1)`.

## Mistakes to Avoid

- Python's `&` binds **tighter** than `==`: `(n > 0) & (n & (n - 1)) == 0` means `((n > 0) & (n & (n - 1))) == 0`. Join the conditions with `and`.
- It is a power of two when `n & (n - 1)` is 0, not the other way around.

## Interview Explanation

A power of two has one set bit, and n & (n - 1) clears the lowest one, so I check that n is positive and n & (n - 1) is 0. Time `O(1)`.
