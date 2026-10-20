---
title: "LeetCode 3794: Reverse String Prefix"
summary: "LeetCode 3794 note: one line with slicing; a hand-written two-pointer version must convert the string to a list first"
description: "LeetCode 3794 record from 2026-01-03"
date: 2026-01-03
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
First Attempt: 2026-01-03
- Submissions: Accepted (slicing) → Runtime Error ×2 → Accepted (two pointers, 2026-01-24)

## Approach

Reverse the first `k` characters. Python slicing does it in one line: `s[:k][::-1] + s[k:]`.

## My Attempts: rewriting with two pointers for practice

When I came back in late January to rewrite it with two pointers, two Runtime Errors followed:

1. `right = len(k) - 1`: `k` is an integer and has no `len`; it should be `k - 1`.
2. After that, `s[left], s[right] = s[right], s[left]` failed: **Python strings cannot be modified**, so convert with `list(s)` first and `"".join(...)` at the end.

## Solution

```python
class Solution:
    def reversePrefix(self, s: str, k: int) -> str:
        chars = list(s)
        left, right = 0, k - 1
        while left < right:
            chars[left], chars[right] = chars[right], chars[left]
            left += 1
            right -= 1
        return "".join(chars)
```

## Complexity

Time `O(n)`, space `O(n)` (strings are immutable, so a new one is always built).

## Mistakes to Avoid

- Assigning to characters of a string: Python strings are immutable.
- Calling `len` on an integer.

## Interview Explanation

Python strings are immutable, so I convert to a list and swap with two pointers from index 0 and index `k - 1` toward the middle, then join back into a string. Slicing, `s[:k][::-1] + s[k:]`, also works; both are `O(n)`.
