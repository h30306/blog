---
title: "LeetCode 1768: Merge Strings Alternately"
summary: "LeetCode 1768 note: take characters in turn with one index, then append whatever remains of the longer string"
description: "LeetCode 1768 record from 2025-03-18"
date: 2025-03-18
tags: ["easy", "two-pointers", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2025-03-18
- Submissions: Accepted → Time Limit Exceeded → Accepted

## Approach

Starting with `word1`, take one character from each string in turn; once one runs out, append the rest of the other.

## My Attempts

The first version used `zip` until the shorter string ran out, then computed how many characters had been used with `round(len(res) / 2)` and appended both remainders. Correct, but computing the length with `round` is roundabout.

The second version used a hand-written index:

```python
idx = 0
while idx < len(word1) or idx < len(word2):
    res += word1[idx] + word2[idx]          # idx never increases
```

It **forgot `idx += 1`**, looping forever and timing out. And with `or`, it would also read past the end of the shorter string. Using `and` plus `idx += 1` passed.

## Solution

```python
class Solution:
    def mergeAlternately(self, word1: str, word2: str) -> str:
        res = []
        i = 0
        while i < len(word1) and i < len(word2):
            res.append(word1[i])
            res.append(word2[i])
            i += 1
        return "".join(res) + word1[i:] + word2[i:]
```

When the loop ends, at least one string is used up, so `word1[i:] + word2[i:]` appends only the one with characters left.

## Complexity

Time `O(n + m)`, space `O(n + m)`.

## Mistakes to Avoid

- Forgetting to advance the index inside a `while` loop.
- Using `or` in the condition: it reads past the end of the shorter string.
- Concatenating with `+=`: Python strings are immutable, so each step builds a new string; collect into a list and `join`.

## Interview Explanation

One index walks both strings, taking a character from each in turn until one runs out. At that point at least one side is exhausted, so I append both remainders. Collecting characters in a list and joining keeps it `O(n + m)`.
