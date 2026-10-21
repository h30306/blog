---
title: "LeetCode 290: Word Pattern"
summary: "LeetCode 290 note: pattern characters and words must correspond one to one; use two dicts or compare set sizes"
description: "LeetCode 290 record from 2022-08-23"
date: 2022-08-23
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
First Attempt: 2022-08-23
- Submissions: Accepted (first try)

## Approach

A bijection as in LC 205: each character maps to one word and each word to one character. The lengths must match, and the numbers of distinct characters, distinct words and distinct `(character, word)` pairs must all be equal ([Hash Table]({{< relref "/algorithm/Hash-Table" >}}) Template 5).

## My Attempts

Passed on the first try, by recording the position list of every character and every word and comparing the two collections of position lists.

## Solution

```python
class Solution:
    def wordPattern(self, pattern: str, s: str) -> bool:
        words = s.split()
        if len(pattern) != len(words):
            return False
        return len(set(pattern)) == len(set(words)) == len(set(zip(pattern, words)))
```

## Complexity

Time `O(n + m)`, space `O(n + m)`.

## Mistakes to Avoid

- Rule out different lengths first; `zip` silently truncates.
- Both directions must be one to one: `"ab"` with `"dog dog"` fails.

## Interview Explanation

This is a bijection: after checking the lengths match, I compare the counts of distinct characters, distinct words and distinct pairs. Time `O(n + m)`.
