---
title: "LeetCode 824: Goat Latin"
summary: "LeetCode 824 note: split into words and convert each: move a leading consonant to the end, then append ma and i + 1 copies of a"
description: "LeetCode 824 record from 2022-09-15"
date: 2022-09-15
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
First Attempt: 2022-09-15
- Submissions: Accepted ×2

## Approach

Split into words and convert each ([String]({{< relref "/algorithm/String" >}}) Template 6): leave a word starting with a vowel (either case) unchanged, otherwise move its first letter to the end; then append `"ma"` and `i + 1` copies of `"a"` (with `i` the 0-based word index).

## My Solution

```python
class Solution:
    def toGoatLatin(self, sentence: str) -> str:
        res = []
        for i, w in enumerate(sentence.split()):
            if w[0] not in "aeiouAEIOU":
                w = w[1:] + w[0]
            res.append(w + "ma" + "a" * (i + 1))
        return " ".join(res)
```

## Complexity

Time `O(n + w²)` for `w` words, since the appended `a`s total `O(w²)`; space likewise.

## Mistakes to Avoid

- Vowels include uppercase.
- The first word gets one `a`, not zero.

## Interview Explanation

I split the sentence, move a leading consonant to the end, append ma plus index + 1 copies of a, and join with spaces.
