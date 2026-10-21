---
title: "LeetCode 125: Valid Palindrome"
summary: "LeetCode 125 note: two pointers skip non-alphanumeric characters and compare lowercase letters, with digits included"
description: "LeetCode 125 record from 2022-08-16"
date: 2022-08-16
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
First Attempt: 2022-08-16
- Submissions: Runtime Error ×2 → Accepted ×2 → Wrong Answer ×2 → Accepted ×8 → Wrong Answer → Accepted ×2

## Approach

Move two pointers inward ([Two Pointers]({{< relref "/algorithm/Two-Pointers" >}}) Template 1): each skips characters that are not **letters or digits**, then compare lowercase forms.

## My Attempts

In 2022-08 I first wrote "filter with `isalnum`, lowercase, compare with the reverse"; the first two versions were generator typos (a missing `in s`, then `sif`), and fixing them passed. Two later rewrites, a 2022-10 `isalpha` filter (which also forgot to lowercase) and a 2026 two-pointer version with a hand-written letters-only check, both **ignored digits**: `"1A"` compares `1` with `a`, so the answer is `False`; it returned `True`.

## Solution

```python
class Solution:
    def isPalindrome(self, s: str) -> bool:
        l, r = 0, len(s) - 1
        while l < r:
            if not s[l].isalnum():
                l += 1
            elif not s[r].isalnum():
                r -= 1
            elif s[l].lower() != s[r].lower():
                return False
            else:
                l, r = l + 1, r - 1
        return True
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- The problem says alphanumeric: **digits count too**, not just letters.

## Interview Explanation

Two pointers move inward, skipping non-alphanumeric characters and comparing the rest in lowercase; any mismatch means no. Time `O(n)`, space `O(1)`.
