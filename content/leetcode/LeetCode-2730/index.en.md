---
title: "LeetCode 2730: Find the Longest Semi-Repetitive Substring"
summary: "LeetCode 2730 note: the window holds at most one adjacent equal pair; when a new pair arrives, shrink the left until the previous pair leaves"
description: "LeetCode 2730 record from 2026-01-11"
date: 2026-01-11
tags: ["medium", "sliding-window", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-11
- Submissions: Accepted (first try)

## Approach

A window is valid ⇔ it contains at most one adjacent equal pair (`s[i] == s[i + 1]`).

- When `s[right]` is added and `s[right] == s[right - 1]`, the pair count goes up by 1.
- With more than one pair, shrink the left. When `s[left]` leaves and `s[left] == s[left + 1]`, that pair leaves too, so the count goes down by 1.

## My Solution

```python
class Solution:
    def longestSemiRepetitiveSubstring(self, s: str) -> int:
        left = pairs = best = 0
        for right in range(len(s)):
            if right > 0 and s[right] == s[right - 1]:
                pairs += 1
            while pairs > 1:
                if s[left] == s[left + 1]:
                    pairs -= 1                     # this pair leaves the window
                left += 1
            best = max(best, right - left + 1)
        return best
```

With `pairs > 1` the window holds at least two pairs, so `left + 1 <= right` and `s[left + 1]` stays in range.

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- When the left leaves, check the pair `s[left]`, `s[left + 1]`, not `s[left - 1]`.

## Interview Explanation

The window may contain at most one adjacent equal pair. Adding a character equal to the previous one adds a pair; with more than one, I shrink the left, and when the leaving character equals the next one, that pair is gone. Tracking the longest length gives `O(n)`.
