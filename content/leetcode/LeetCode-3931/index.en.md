---
title: "LeetCode 3931: Check Adjacent Digit Differences"
summary: "LeetCode 3931 note: check that every pair of adjacent digits differs by at most 2"
description: "LeetCode 3931 record from 2026-05-17"
date: 2026-05-17
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
First Attempt: 2026-05-17
- Submissions: Accepted (first try)

## Approach

Convert characters to digits and compare each adjacent pair once ([String]({{< relref "/algorithm/String" >}}) Template 4). Any pair differing by more than 2 means `False`.

## My Solution

```python
class Solution:
    def isAdjacentDiffAtMostTwo(self, s: str) -> bool:
        return all(abs(int(a) - int(b)) <= 2 for a, b in zip(s, s[1:]))
```

## Complexity

Time `O(n)`, space `O(n)` (the `s[1:]` copy).

## Mistakes to Avoid

- Convert characters to digits before subtracting.

## Interview Explanation

I pair the string with itself shifted by one and return `True` when every adjacent pair differs by at most 2. Time `O(n)`.
