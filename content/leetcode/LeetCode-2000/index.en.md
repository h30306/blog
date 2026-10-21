---
title: "LeetCode 2000: Reverse Prefix of Word"
summary: "LeetCode 2000 note: find the first index i of ch, reverse word[:i + 1] and append the rest; return the word unchanged if ch is absent"
description: "LeetCode 2000 record from 2024-05-01"
date: 2024-05-01
tags: ["easy", "two-pointers", "string", "stack"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2024-05-01
- Submissions: Accepted (first try)

## Approach

`i = word.find(ch)` is -1 when absent; then `word[:0]` is empty and appending all of `word` returns it unchanged, so no special case is needed. By hand, swap `[0, i]` with converging pointers ([Two Pointers]({{< relref "/algorithm/Two-Pointers" >}}) Template 1).

## My Solution

```python
class Solution:
    def reversePrefix(self, word: str, ch: str) -> str:
        i = word.find(ch)
        return word[:i + 1][::-1] + word[i + 1:]
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- `index` raises when not found; `find` returns -1.

## Interview Explanation

I find ch's first index, reverse the prefix through it and append the rest; when absent, find returns -1, the prefix is empty, and the word comes back unchanged. Time `O(n)`.
