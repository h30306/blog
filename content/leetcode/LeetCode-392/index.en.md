---
title: "LeetCode 392: Is Subsequence"
summary: "LeetCode 392 note: two pointers; the pointer on t always advances, and the one on s advances on a match; bound-check both"
description: "LeetCode 392 record from 2022-08-23"
date: 2022-08-23
tags: ["easy", "two-pointers", "string", "dynamic-programming"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-23
- Submissions: Runtime Error ×2 → Accepted ×2 → Runtime Error → Accepted ×2 → Runtime Error → Wrong Answer → Accepted ×3 → Runtime Error → Wrong Answer → Runtime Error ×2 → Accepted

## Approach

One pointer per string ([Two Pointers]({{< relref "/algorithm/Two-Pointers" >}}) Template 2): `j` scans `t`, and `i` advances when `t[j] == s[i]`. Loop while `i < len(s) and j < len(t)`, and succeed if `i == len(s)`. Empty `s` or `t` then needs no special case. For the follow-up with many `s`, store the positions of each character of `t` and binary search for the next one per `s`.

## My Attempts

I wrote this many times (2022, 2025, 2026), and almost every error was about empty strings and bounds:

- 2022-08 used a queue with `pop(0)`; with an empty `s`, `queue[0]` was out of range.
- 2022-11 wrote `if not t or not s: return False`, **but an empty `s` should be `True`**: `('', '')` returned `False`.
- In 2025 the inner `while t[r] != s[l]` raised IndexError for an empty `t`; adding `if not t: return False` broke `('', '')` again, and `r += 1` after a match was never bound-checked: `('bb', 'b')` raised IndexError.
- The 2026 version checked `right == m` only on a mismatch, so an empty `t` overran on the first comparison; putting both bounds in the `while` condition passed.

## Solution

```python
class Solution:
    def isSubsequence(self, s: str, t: str) -> bool:
        i = 0
        for c in t:
            if i < len(s) and s[i] == c:
                i += 1
        return i == len(s)
```

## Complexity

Time `O(n + m)`, space `O(1)`.

## Mistakes to Avoid

- An empty `s` is always a subsequence, even of an empty `t`.
- Bound-check `j` before reading `t[j]`, including right after a match advances it.

## Interview Explanation

With two pointers I scan t and advance s's pointer on each match; s is a subsequence if its pointer reaches the end. Time `O(n + m)`, space `O(1)`.
