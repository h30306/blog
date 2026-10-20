---
title: "LeetCode 3805: Count Caesar Cipher Pairs"
summary: "LeetCode 3805 note: shift each string so its first letter is a, making Caesar-equivalent strings identical, then count pairs per normalized form"
description: "LeetCode 3805 record from 2026-01-11"
date: 2026-01-11
tags: ["medium", "math", "hash-table", "string", "counting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-11
- Submissions: Accepted (first try)

## Approach

Two strings become equal by shifting ⇔ **every position differs from the first letter by the same amount (mod 26)**.

So **normalize** each string: shift it so the first letter is `a`, i.e. record each letter as `(c - word[0]) mod 26`. Equivalent strings get the same form; count each form with a hash map, and pairs are `c × (c - 1) / 2`.

## My Solution

```python
class Solution:
    def countPairs(self, words: List[str]) -> int:
        cnt = Counter()
        pairs = 0
        for w in words:
            key = tuple((ord(c) - ord(w[0])) % 26 for c in w)   # shift so the first letter is a
            pairs += cnt[key]                      # pair with every earlier equivalent
            cnt[key] += 1
        return pairs
```

My original built the shifted string with `chr` and branches for wrapping around, then computed `v * (v - 1) / 2` (float division converted back to int). A tuple of `% 26` values as the key is cleaner and avoids floats.

## Complexity

Time `O(n · m)`, space `O(n · m)`.

## Mistakes to Avoid

- Shifts wrap around: after `z` comes `a`, so use `% 26`.
- Count pairs with integer arithmetic.

## Interview Explanation

Two strings are Caesar-equivalent when every letter's difference from the first letter, mod 26, matches. I normalize each string to that difference sequence as a key and, while scanning, add how many earlier strings had the same key. Time `O(n · m)`.
