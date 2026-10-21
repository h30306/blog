---
title: "LeetCode 58: Length of Last Word"
summary: "LeetCode 58 note: split() with no argument ignores trailing spaces; return the length of the last word"
description: "LeetCode 58 record from 2022-05-11"
date: 2022-05-11
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
First Attempt: 2022-05-11
- Submissions: Accepted ×3 → Wrong Answer → Accepted ×3 → Runtime Error → Accepted ×3

## Approach

`s.split()` drops leading and trailing spaces and merges runs of spaces, so its last element is the last word ([String]({{< relref "/algorithm/String" >}}) Template 6). Without splitting everything, scan from the end: skip spaces, then count non-spaces.

## My Attempts

One 2022-05 version used `split(" ")[-1]`, **whose last element is empty when the string ends with a space**: `"a "` returned 0 instead of 1. A 2022-08 rewrite put the `-1` inside `split(-1)` (TypeError).

## Solution

```python
class Solution:
    def lengthOfLastWord(self, s: str) -> int:
        i = len(s) - 1
        while s[i] == " ":
            i -= 1
        n = 0
        while i >= 0 and s[i] != " ":
            n += 1
            i -= 1
        return n
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- The string may end with spaces; `split(" ")[-1]` yields an empty string.

## Interview Explanation

From the end I skip trailing spaces and count the following non-space characters, in `O(1)` space; taking the last element of split() also works.
