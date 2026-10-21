---
title: "LeetCode 3798: Largest Even Number"
summary: "LeetCode 3798 note: parity depends only on the last digit, so just delete trailing 1s; keeping more digits is larger"
description: "LeetCode 3798 record from 2026-01-04"
date: 2026-01-04
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
First Attempt: 2026-01-04
- Submissions: Accepted (first try)

## Approach

The string has only `1`s and `2`s, and a number is even when its last digit is `2`. More digits mean a larger number, so delete only what is necessary: strip the trailing `1`s, and the rest is the largest even number. All `1`s gives the empty string.

## My Solution

```python
class Solution:
    def largestEven(self, s: str) -> str:
        return s.rstrip("1")
```

I originally deleted them one at a time in a while loop; `rstrip` does the same.

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Deleting middle digits only makes the number shorter and smaller; only the end matters.

## Interview Explanation

Parity depends only on the last digit, and keeping more digits is larger, so I just strip the trailing 1s. Time `O(n)`.
