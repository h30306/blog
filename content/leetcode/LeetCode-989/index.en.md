---
title: "LeetCode 989: Add to Array-Form of Integer"
summary: "LeetCode 989 note: treat k as the carry, add from the last element backwards, and keep prepending digits while k remains"
description: "LeetCode 989 record from 2022-09-26"
date: 2022-09-26
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
First Attempt: 2022-09-26
- Submissions: Runtime Error ×2 → Wrong Answer → Runtime Error → Accepted

## Approach

A column-addition trick ([Math]({{< relref "/algorithm/Math" >}}) Template 6): treat all of `k` as the carry. From the last element, `k += num[i]`, the digit is `k % 10`, and `k //= 10` carries on. If `k` remains after the array, prepend its digits.

## My Attempts

As in LC 66, the first attempts converted to an integer, added `k` and split back: `''.join(num)` on integers raised TypeError, then `str(...).split()` **produced a single element**: `[0]`, `22` returned `[22]` instead of `[2, 2]`. Using `list(str(...))` passed.

## Solution

```python
class Solution:
    def addToArrayForm(self, num: List[int], k: int) -> List[int]:
        res = []
        i = len(num) - 1
        while i >= 0 or k:
            if i >= 0:
                k += num[i]
                i -= 1
            res.append(k % 10)
            k //= 10
        return res[::-1]
```

## Complexity

Time `O(max(n, log k))`, space `O(max(n, log k))`.

## Mistakes to Avoid

- `k` may have more digits than the array; keep processing it after the array ends.
- Return a list of digits, not one element from splitting a string.

## Interview Explanation

I treat k as the carry, add from the last element, emit the ones digit and carry the rest, keep going while k remains, and reverse. Time `O(max(n, log k))` without building a big integer.
