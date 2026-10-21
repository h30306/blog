---
title: "LeetCode 3803: Count Residue Prefixes"
summary: "LeetCode 3803 note: add characters to a set while scanning; count a prefix when its distinct count equals its length % 3"
description: "LeetCode 3803 record from 2026-01-11"
date: 2026-01-11
tags: ["easy", "hash-table", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2026-01-11
- Submissions: Accepted (first try)

## Approach

The prefix grows one character at a time, so maintain its distinct characters in a set ([String]({{< relref "/algorithm/String" >}}) Template 4). Its length is `i + 1`; compare `len(seen) == (i + 1) % 3`.

## My Solution

```python
class Solution:
    def residuePrefixes(self, s: str) -> int:
        seen, res = set(), 0
        for i, ch in enumerate(s):
            seen.add(ch)
            res += len(seen) == (i + 1) % 3
        return res
```

## Complexity

Time `O(n)`, space `O(1)` (at most 26 characters).

## Mistakes to Avoid

- The length is `i + 1`, not `i`.

## Interview Explanation

I scan left to right with a set of the prefix's characters and compare its size to the prefix length mod 3 at each step. Time `O(n)`. Since `length % 3` is at most 2, once the prefix has more than 2 distinct characters it can never hold again, so the scan can stop early.
