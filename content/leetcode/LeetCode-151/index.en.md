---
title: "LeetCode 151: Reverse Words in a String"
summary: "LeetCode 151 note: split() with no argument treats runs of spaces as one separator and drops leading and trailing spaces; reverse and join with single spaces"
description: "LeetCode 151 record from 2022-11-12"
date: 2022-11-12
tags: ["medium", "two-pointers", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-11-12
- Submissions: Accepted ×3 → Runtime Error → Wrong Answer ×5 → Accepted

## Approach

`str.split()` **with no argument** splits on runs of whitespace of any length and drops leading and trailing spaces, giving exactly the word list. Reverse it and `join` with single spaces. With an `O(1)`-space requirement on a character array, reverse everything and then each word ([Two Pointers]({{< relref "/algorithm/Two-Pointers" >}}) Template 1).

## My Attempts

It passed in 2022. A 2026 rewrite used `split(" ")`, **which produces empty strings for consecutive spaces**: `"b  b"` returned `"b  b"` (still two spaces) and `"b "` returned `" b"`; one version also forgot the separating space, turning `"a b"` into `"ba"`.

## Solution

```python
class Solution:
    def reverseWords(self, s: str) -> str:
        return " ".join(reversed(s.split()))
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- `split(" ")` produces empty strings for consecutive spaces; `split()` does not.

## Interview Explanation

Calling `split()` with no argument yields the words with all extra spaces handled, and I join them reversed with single spaces. Time `O(n)`.
