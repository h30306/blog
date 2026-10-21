---
title: "LeetCode 3813: Vowel-Consonant Score"
summary: "LeetCode 3813 note: count letters only, split into vowels and consonants; the score is 0 with no consonants, otherwise integer division"
description: "LeetCode 3813 record from 2026-01-18"
date: 2026-01-18
tags: ["easy", "string", "simulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2026-01-18
- Submissions: Accepted (first try)

## Approach

The string also contains spaces and digits; only letters count ([String]({{< relref "/algorithm/String" >}}) Template 4). With `v` vowels and `c` consonants, the score is `v // c` when `c > 0`, otherwise 0.

## My Solution

I originally checked letters with `97 <= ord(c) <= 97 + 26` (the upper bound actually lets in `{`, which never appears) and used `floor(v / c)`. Here with `isalpha` and integer division:

```python
class Solution:
    def vowelConsonantScore(self, s: str) -> int:
        v = sum(ch in "aeiou" for ch in s)
        c = sum(ch.isalpha() and ch not in "aeiou" for ch in s)
        return v // c if c else 0
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Spaces and digits are not consonants.
- Do not divide when there are no consonants.

## Interview Explanation

I count only letters, vowels and consonants separately. With no consonants I return 0; otherwise the integer quotient. Time `O(n)`.
