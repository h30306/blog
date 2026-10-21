---
title: "LeetCode 28: Find the Index of the First Occurrence in a String"
summary: "LeetCode 28 note: try matching needle at every start, or use str.find; index raises when not found"
description: "LeetCode 28 record from 2022-05-11"
date: 2022-05-11
tags: ["easy", "two-pointers", "string", "string-matching", "z-algorithm"]
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
- Submissions: Accepted ×3 → Runtime Error → Accepted ×2

## Approach

Try `haystack[i:i + m] == needle` at every start `i` ([String]({{< relref "/algorithm/String" >}}) Template 2), with starts up to `n - m`. In an interview present this `O(nm)` approach first and mention KMP's `O(n + m)` if needed. Python's `str.find` returns `-1` when not found, exactly as required; `str.index` raises `ValueError`.

## My Attempts

Earlier submissions used the built-in `in` plus `index`. One in 2022-10 called only `haystack.index(needle)`, which raises `ValueError` when not found.

## Solution

```python
class Solution:
    def strStr(self, haystack: str, needle: str) -> int:
        n, m = len(haystack), len(needle)
        for i in range(n - m + 1):
            if haystack[i:i + m] == needle:
                return i
        return -1
```

## Complexity

Time `O(nm)`, space `O(m)` (slicing).

## Mistakes to Avoid

- There are `n - m + 1` starting positions.
- With built-ins, `index` raises when not found; use `find`.

## Interview Explanation

I try needle at every possible start and return the first match, or -1, in `O(nm)`; for better bounds KMP precomputes needle's failure function for `O(n + m)`.
