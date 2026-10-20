---
title: "LeetCode 3775: Reverse Words With Same Vowel Count"
summary: "LeetCode 3775 note: count the first word's vowels, then reverse every later word with the same count"
description: "LeetCode 3775 record from 2026-01-24"
date: 2026-01-24
tags: ["medium", "string", "simulation", "two-pointers"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-24
- Submissions: Accepted (first try)

## Approach

1. Split the string on spaces.
2. Count the vowels of the first word, `target`.
3. Leave the first word alone; reverse each later word whose vowel count equals `target`.

Reversing a word can use slicing, `word[::-1]`, or converging pointers.

## My Solution

```python
class Solution:
    def reverseWords(self, s: str) -> str:
        def vowels(word: str) -> int:
            return sum(ch in "aeiou" for ch in word)

        words = s.split(" ")
        target = vowels(words[0])
        return " ".join([words[0]] + [w[::-1] if vowels(w) == target else w for w in words[1:]])
```

My original counted vowels by calling `word.count(v)` once per vowel, scanning the word five times; this version scans once. It also detected the first word by checking whether `res` was empty; here the first word is handled separately.

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Reversing the first word too: only the words after it are processed.

## Interview Explanation

I split on spaces, count the first word's vowels, reverse each later word with the same count and keep the others, then join with spaces. Each character is looked at a constant number of times, so time is `O(n)`.
