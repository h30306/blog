---
title: "LeetCode 2697: Lexicographically Smallest Palindrome"
summary: "LeetCode 2697 note: converging pointers, setting both ends to the smaller character whenever they differ"
description: "LeetCode 2697 record from 2026-01-24"
date: 2026-01-24
tags: ["easy", "two-pointers", "string", "greedy"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2026-01-24
- Submissions: Accepted (first try)

## Approach

Make the string a palindrome with the fewest changes, and among those, the lexicographically smallest.

A palindrome needs every pair `(i, n - 1 - i)` to match. For each pair:

- Already equal: no change.
- Different: **at least one change is required**, and changing to the smaller character gives the smallest result.

Pairs are independent, so both goals are achieved together.

## My Solution

```python
class Solution:
    def makeSmallestPalindrome(self, s: str) -> str:
        chars = list(s)
        left, right = 0, len(chars) - 1
        while left < right:
            smaller = min(chars[left], chars[right])
            chars[left] = chars[right] = smaller
            left += 1
            right -= 1
        return "".join(chars)
```

My original handled "left is smaller" and "right is smaller" separately with `if / elif`; this version takes `min` directly.

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Changing to the larger character: the same number of changes, but a larger result.
- Changing both sides: only the larger side needs to change.

## Interview Explanation

A palindrome needs every symmetric pair to match, so I walk converging pointers pair by pair: when they differ, at least one must change, and changing to the smaller character keeps the change count minimal and the result smallest. Pairs do not affect each other, so time is `O(n)`.
