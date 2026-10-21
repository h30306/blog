---
title: "LeetCode 520: Detect Capital"
summary: "LeetCode 520 note: only three forms are valid: all caps, all lowercase, or only the first letter capitalized"
description: "LeetCode 520 record from 2022-08-25"
date: 2022-08-25
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
First Attempt: 2022-08-25
- Submissions: Accepted (first try)

## Approach

Check the three valid forms directly ([String]({{< relref "/algorithm/String" >}}) Template 4): `word.isupper()`, `word.islower()`, or `word[0].isupper() and word[1:].islower()`. For a single character `word[1:]` is empty and `"".islower()` is `False`, but a single letter is already covered by the first two checks; `word.istitle()` is an equivalent third check for a single word.

## My Solution

```python
class Solution:
    def detectCapitalUse(self, word: str) -> bool:
        return word.isupper() or word.islower() or word.istitle()
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- The third form is "first uppercase and **all the rest** lowercase".

## Interview Explanation

Only all caps, all lowercase or a capitalized first letter are valid, so I check isupper, islower and istitle. Time `O(n)`.
