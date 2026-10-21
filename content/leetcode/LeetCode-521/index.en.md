---
title: "LeetCode 521: Longest Uncommon Subsequence I"
summary: "LeetCode 521 note: identical strings give -1; otherwise the longer string itself is the answer"
description: "LeetCode 521 record from 2022-08-25"
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

If `a == b`, every subsequence of one is a subsequence of the other, so the answer is `-1`. Otherwise the longer string as a whole cannot be a subsequence of the other (it is longer, or equally long but different), so the answer is `max(len(a), len(b))`.

## My Solution

```python
class Solution:
    def findLUSlength(self, a: str, b: str) -> int:
        return -1 if a == b else max(len(a), len(b))
```

## Complexity

Time `O(n)` to compare the strings, space `O(1)`.

## Mistakes to Avoid

- With equal lengths but different contents, either whole string works.

## Interview Explanation

Identical strings have no answer, so -1; otherwise the longer string as a whole cannot be a subsequence of the other, so the answer is the longer length.
