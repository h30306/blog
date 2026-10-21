---
title: "LeetCode 3541: Find Most Frequent Vowel and Consonant"
summary: "LeetCode 3541 note: count characters, take the maximum among vowels and among consonants and add them; a missing class counts as 0"
description: "LeetCode 3541 record from 2025-05-10"
date: 2025-05-10
tags: ["easy", "hash-table", "string", "counting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2025-05-10
- Submissions: Accepted (first try)

## Approach

Count characters with `Counter`, then take the maximum within vowels and within consonants ([String]({{< relref "/algorithm/String" >}}) Template 4). A class with no characters counts as 0, via `max(..., default=0)`.

## My Solution

I originally sorted the `Counter` by count before scanning it; the sort is unnecessary, just take the maximums:

```python
class Solution:
    def maxFreqSum(self, s: str) -> int:
        vowels = set("aeiou")
        cnt = Counter(s)
        best_v = max((v for c, v in cnt.items() if c in vowels), default=0)
        best_c = max((v for c, v in cnt.items() if c not in vowels), default=0)
        return best_v + best_c
```

## Complexity

Time `O(n)`, space `O(1)` (at most 26 characters).

## Mistakes to Avoid

- With no characters in a class, `max` on an empty sequence raises; pass `default=0`.

## Interview Explanation

I count each character, take the maximum among vowels and among consonants, and return their sum, using 0 for a missing class. Time `O(n)`.
