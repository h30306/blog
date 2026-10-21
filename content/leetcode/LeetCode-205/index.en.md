---
title: "LeetCode 205: Isomorphic Strings"
summary: "LeetCode 205 note: characters must map one to one; it holds when the distinct characters and distinct pairs all have the same count"
description: "LeetCode 205 record from 2022-08-21"
date: 2022-08-21
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
First Attempt: 2022-08-21
- Submissions: Wrong Answer ×2 → Accepted ×2 → Wrong Answer → Accepted ×2

## Approach

Isomorphism is a bijection: each character of `s` maps to one character of `t` and vice versa. `len(set(s)) == len(set(t)) == len(set(zip(s, t)))`: more pairs than distinct characters means some character maps to two ([Hash Table]({{< relref "/algorithm/Hash-Table" >}}) Template 5). Alternatively, replace each character with its first-occurrence index and compare the encodings.

## My Attempts

The first versions replaced each character with its first-occurrence index:

- Attempt 1 encoded `s` twice and never used `t`, always returning `True`, even for `"aa"`, `"ca"`.
- Attempt 2 encoded `t` but concatenated the numbers without a separator, **so two-digit indices collide**: the last two characters of `"abcdefghijkbl"` and `"abcdefghijklc"` encode as `1, 12` and `11, 2`, both `"112"`, returning `True` instead of `False`.
- Adding a space separator passed. A later one-line set version first forgot the `return`.

## Solution

```python
class Solution:
    def isIsomorphic(self, s: str, t: str) -> bool:
        return len(set(s)) == len(set(t)) == len(set(zip(s, t)))
```

## Complexity

Time `O(n)`, space `O(k)`.

## Mistakes to Avoid

- When encoding with indices, separate the numbers; otherwise `1` + `12` and `11` + `2` both read `112`.
- Encode both strings, not `s` twice.

## Interview Explanation

Isomorphism means one to one in both directions, so I check that the distinct characters of s, of t, and of the (s[i], t[i]) pairs all have the same count. Time `O(n)`.
