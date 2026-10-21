---
title: "LeetCode 3838: Weighted Word Mapping"
summary: "LeetCode 3838 note: sum each word's letter weights mod 26 and map backward: 0 -> z, i.e. chr(ord('z') - r)"
description: "LeetCode 3838 record from 2026-02-14"
date: 2026-02-14
tags: ["easy", "array", "string", "simulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2026-02-14
- Submissions: Accepted (first try)

## Approach

For each word compute its total weight `w` and `r = w % 26`. Reverse alphabetical order is `0 -> 'z'`, `1 -> 'y'`, ..., so the letter is `chr(ord('z') - r)` ([Array]({{< relref "/algorithm/Array" >}}) Template 5).

## My Solution

```python
class Solution:
    def mapWordWeights(self, words: List[str], weights: List[int]) -> str:
        return "".join(
            chr(ord("z") - sum(weights[ord(c) - ord("a")] for c in w) % 26)
            for w in words
        )
```

## Complexity

Time `O(total characters)`, space `O(number of words)`.

## Mistakes to Avoid

- The mapping is reversed: `0` maps to `z`, not `a`.

## Interview Explanation

For each word I sum the letter weights mod 26 and subtract the remainder from `ord('z')` for the reversed letter, then join. Time `O(total characters)`.
