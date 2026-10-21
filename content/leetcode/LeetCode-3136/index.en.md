---
title: "LeetCode 3136: Valid Word"
summary: "LeetCode 3136 note: length at least 3, alphanumeric only, at least one vowel and at least one consonant; digits are not consonants"
description: "LeetCode 3136 record from 2024-05-05"
date: 2024-05-05
tags: ["easy", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2024-05-05
- Submissions: Wrong Answer → Accepted → Wrong Answer → Accepted

## Approach

Check the four conditions one by one ([String]({{< relref "/algorithm/String" >}}) Template 4): length `>= 3`, every character alphanumeric, at least one vowel (either case), and at least one consonant. **A consonant is a letter that is not a vowel**; digits do not count.

## My Attempts

- The first 2024 version treated every non-vowel character as a consonant, **so digits counted**: `"a3E"` has only vowels and a digit, so the answer is `False`; it returned `True`.
- A 2025 rewrite tested vowels with `w in "aeiou"`, **missing uppercase vowels**: `"bEE"` returned `False` instead of `True`. Using `w.lower()` passed.

## Solution

```python
class Solution:
    def isValid(self, word: str) -> bool:
        if len(word) < 3 or not all(c.isalnum() for c in word):
            return False
        vowels = set("aeiouAEIOU")
        has_vowel = any(c in vowels for c in word)
        has_consonant = any(c.isalpha() and c not in vowels for c in word)
        return has_vowel and has_consonant
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Digits are not consonants; check that the character is a letter.
- Uppercase vowels are vowels too.

## Interview Explanation

I check length at least 3 and all characters alphanumeric, then require a vowel and a consonant, where a consonant must be a non-vowel letter. Time `O(n)`.
