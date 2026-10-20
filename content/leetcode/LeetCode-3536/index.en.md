---
title: "LeetCode 3536: Maximum Product of Two Digits"
summary: "LeetCode 3536 note: multiply the largest and second-largest digits; when a new maximum appears, the old maximum must move to second place"
description: "LeetCode 3536 record from 2025-05-04"
date: 2025-05-04
tags: ["easy", "math", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2025-05-04
- Submissions: Runtime Error ×4 → Wrong Answer ×2 → Accepted

## Approach

The answer is the product of the two largest digits (a digit appearing twice may be used twice). Sorting the digits and taking the last two is simplest; in one scan, keep `max1 >= max2`:

- A digit `> max1`: **the old `max1` becomes `max2`** and the new digit becomes `max1`.
- Otherwise, if `> max2`: update `max2`.

## My Attempts

| Version | Problem |
|---|---|
| Four REs | `map(n, str)` had its arguments reversed; then type errors from comparing strings with the integer `0` and multiplying strings |
| Two WAs | Types fixed, but on a new maximum **the old maximum was not moved to second place**. For `n = 789` the answer is `9 × 8 = 72`; both returned 0. The first used `>=`, so the second 7 only overwrote first place, and `n = 707` returned 0 instead of 49 |
| AC | Changed to `max1, max2 = s, max1` |

## Solution

```python
class Solution:
    def maxProduct(self, n: int) -> int:
        digits = sorted(int(c) for c in str(n))
        return digits[-1] * digits[-2]
```

## Complexity

Time `O(d log d)` for `d` digits (at most 10), space `O(d)`.

## Mistakes to Avoid

- Comparing strings with integers.
- When tracking a top two, a new first place pushes the old first into second.

## Interview Explanation

The answer multiplies the two largest digits. I sort the digits and take the last two; in a single scan I would keep first and second place, demoting the old first whenever a new first appears. Time `O(d)`.
