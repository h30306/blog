---
title: "LeetCode 345: Reverse Vowels of a String"
summary: "LeetCode 345 note: the same two pointers as LC 917, with the condition switched to \"is a vowel\" (both cases)"
description: "LeetCode 345 record from 2022-08-23"
date: 2022-08-23
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
First Attempt: 2022-08-23
- Submissions: Accepted ×3

## Approach

Two pointers each skip non-vowels and swap when both point at vowels ([Two Pointers]({{< relref "/algorithm/Two-Pointers" >}}) Template 1). Vowels include uppercase, so test against the set `"aeiouAEIOU"`.

## My Solution

```python
class Solution:
    def reverseVowels(self, s: str) -> str:
        vowels = set("aeiouAEIOU")
        a = list(s)
        l, r = 0, len(a) - 1
        while l < r:
            if a[l] not in vowels:
                l += 1
            elif a[r] not in vowels:
                r -= 1
            else:
                a[l], a[r] = a[r], a[l]
                l, r = l + 1, r - 1
        return "".join(a)
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Uppercase vowels count too.

## Interview Explanation

Two pointers skip non-vowels and swap when both are vowels, then move inward. Time `O(n)`.
