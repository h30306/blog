---
title: "LeetCode 3913: Sort Vowels by Frequency"
summary: "LeetCode 3913 note: extract only the vowels, sort by (-count, first occurrence), and put them back into the vowel positions"
description: "LeetCode 3913 record from 2026-04-26"
date: 2026-04-26
tags: ["medium", "string", "sorting", "counting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-04-26
- Submissions: Accepted (first try)

## Approach

Consonants stay put; only vowels are rearranged ([String]({{< relref "/algorithm/String" >}}) Template 4):

1. Scan once, recording each vowel's count and first position.
2. Extract the vowels in order and sort by `(-count, first position)`: higher counts first, ties by earlier first appearance.
3. Scan again and fill each vowel position with the next sorted vowel.

## My Solution

```python
class Solution:
    def sortVowels(self, s: str) -> str:
        vowels = set("aeiou")
        count, first = Counter(), {}
        for i, ch in enumerate(s):
            if ch in vowels:
                count[ch] += 1
                first.setdefault(ch, i)
        ordered = sorted((ch for ch in s if ch in vowels), key=lambda ch: (-count[ch], first[ch]))
        it = iter(ordered)
        return "".join(next(it) if ch in vowels else ch for ch in s)
```

## Complexity

Time `O(n log n)`, space `O(n)`. With only 5 vowels, expanding each vowel's count in order gives `O(n)`.

## Mistakes to Avoid

- Ties are broken by **first occurrence**, not alphabetical order.
- Only vowel positions change; consonants stay where they are.

## Interview Explanation

I count each vowel and record its first position, extract the vowels and sort them by (negative count, first position), then put them back into the vowel positions in order. Time `O(n log n)`, or `O(n)` since there are only 5 vowels.
