---
title: "LeetCode 344: Reverse String"
summary: "LeetCode 344 note: swap with two pointers and move inward to reverse in place"
description: "LeetCode 344 record from 2022-08-23"
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
- Submissions: Accepted ×2 → Runtime Error → Accepted

## Approach

Swap with two pointers and move inward until they meet ([Two Pointers]({{< relref "/algorithm/Two-Pointers" >}}) Template 1).

## My Attempts

A 2026 rewrite started the right pointer at `len(s)`, out of range.

## Solution

```python
class Solution:
    def reverseString(self, s: List[str]) -> None:
        l, r = 0, len(s) - 1
        while l < r:
            s[l], s[r] = s[r], s[l]
            l, r = l + 1, r - 1
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- The right pointer starts at `len(s) - 1`.

## Interview Explanation

Two pointers swap the ends and move inward, reversing in place. Time `O(n)`, space `O(1)`.
