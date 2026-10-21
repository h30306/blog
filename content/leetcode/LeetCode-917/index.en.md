---
title: "LeetCode 917: Reverse Only Letters"
summary: "LeetCode 917 note: two pointers each skip non-letters and swap when both point at letters; convert the string to a list first"
description: "LeetCode 917 record from 2022-09-25"
date: 2022-09-25
tags: ["easy", "two-pointers", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-09-25
- Submissions: Wrong Answer → Runtime Error ×3 → Time Limit Exceeded ×2 → Wrong Answer ×2 → Runtime Error → Wrong Answer → Runtime Error → Wrong Answer ×9 → Runtime Error → Wrong Answer → Accepted → Wrong Answer ×2 → Accepted ×2

## Approach

The same two pointers as LC 125 ([Two Pointers]({{< relref "/algorithm/Two-Pointers" >}}) Template 1): move left past non-letters, move right past non-letters, and swap only when both are letters. Python strings are immutable, so convert to a list and `join` at the end.

## My Attempts

This took 27 submissions, the most in this batch:

- Attempt 1 started both pointers at 0 (`i = j = 0`), so the loop never ran, and it tried to swap characters inside a string.
- Then came many "store the letters and fill them back" variants with off-by-one errors: a single `"z"` returned an empty string or `"zz"`, and `"a7"` lost its letter, returning `"7"`.
- The 2026 rewrite with two pointers got it right in one go.

## Solution

```python
class Solution:
    def reverseOnlyLetters(self, s: str) -> str:
        a = list(s)
        l, r = 0, len(a) - 1
        while l < r:
            if not a[l].isalpha():
                l += 1
            elif not a[r].isalpha():
                r -= 1
            else:
                a[l], a[r] = a[r], a[l]
                l, r = l + 1, r - 1
        return "".join(a)
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Strings cannot be modified in place; use a list.
- The pointers start at the head and the tail.

## Interview Explanation

I convert to a list and move two pointers that skip non-letters, swapping when both are letters, then join back. Time `O(n)`.
