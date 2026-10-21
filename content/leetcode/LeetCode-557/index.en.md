---
title: "LeetCode 557: Reverse Words in a String III"
summary: "LeetCode 557 note: split on spaces, reverse each word, and join with spaces"
description: "LeetCode 557 record from 2022-08-27"
date: 2022-08-27
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
First Attempt: 2022-08-27
- Submissions: Accepted ×2

## Approach

Words are separated by single spaces with none at the ends, so `split(" ")`, reverse each word, and join with spaces ([Two Pointers]({{< relref "/algorithm/Two-Pointers" >}}) Template 1's reversal, via slicing in Python).

## My Solution

```python
class Solution:
    def reverseWords(self, s: str) -> str:
        return " ".join(w[::-1] for w in s.split(" "))
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Reverse each word, not the order of words.

## Interview Explanation

I split into words, reverse each, and join them with spaces. Time `O(n)`.
