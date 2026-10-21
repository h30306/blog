---
title: "LeetCode 459: Repeated Substring Pattern"
summary: "LeetCode 459 note: s is a repetition of a substring exactly when s occurs in s + s with its first and last characters removed"
description: "LeetCode 459 record from 2022-08-24"
date: 2022-08-24
tags: ["easy", "string", "string-matching", "z-algorithm", "knuth-morris-pratt-algorithm"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-24
- Submissions: Accepted (first try)

## Approach

Direct approach: for each length `L` dividing `n`, check `s[:L] * (n // L) == s`. Shorter: drop the first and last characters of `s + s`; if `s` still occurs, `s` equals one of its own nontrivial rotations, which means it has a repeating period ([String]({{< relref "/algorithm/String" >}}) Template 2).

## My Attempts

Passed on the first try with `s in s[1:] + s[:-1]`, which is the same string as `(s + s)[1:-1]`.

## Solution

```python
class Solution:
    def repeatedSubstringPattern(self, s: str) -> bool:
        return s in (s + s)[1:-1]
```

## Complexity

Time `O(n²)` worst case for the built-in search, space `O(n)`.

## Mistakes to Avoid

- Remove both ends, or `s` is always found at the start or end of `s + s`.

## Interview Explanation

If s repeats a substring, rotating it by the period gives itself, so I check whether s occurs in s + s with both ends trimmed. In an interview I would also mention enumerating divisors of the length as the period and verifying each.
