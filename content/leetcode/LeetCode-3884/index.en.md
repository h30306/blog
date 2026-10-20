---
title: "LeetCode 3884: First Matching Character From Both Ends"
summary: "LeetCode 3884 note: compare from both ends toward the middle; the first match is the answer, and odd lengths always match in the middle"
description: "LeetCode 3884 record from 2026-03-29"
date: 2026-03-29
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
First Attempt: 2026-03-29
- Submissions: Accepted (first try)

## Approach

Find the smallest `i` with `s[i] == s[n - 1 - i]`. Check from `i = 0` toward the middle; the first match is the answer.

Checking up to the middle is enough: past the middle, the pair `(i, n - 1 - i)` was already checked.

Observation: **with an odd length, the middle character is compared with itself and always matches**, so odd lengths always have an answer; only even lengths can return `-1`.

## My Solution

```python
class Solution:
    def firstMatchingIndex(self, s: str) -> int:
        n = len(s)
        for i in range((n + 1) // 2):
            if s[i] == s[n - 1 - i]:
                return i
        return -1
```

My original looped to `n`, with the same result (when nothing matches, the second half just rechecks the same pairs); this version stops at the middle.

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Looping only to `n // 2`: with an odd length, the middle character is missed.

## Interview Explanation

I check `s[i]` against `s[n - 1 - i]` from `i = 0` toward the middle and return the first match; the middle is far enough, since later pairs were already seen. With an odd length the middle character always matches itself, so only even lengths can fail. Time `O(n)`.
