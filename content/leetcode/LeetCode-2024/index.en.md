---
title: "LeetCode 2024: Maximize the Confusion of an Exam"
summary: "LeetCode 2024 note: a window is valid when the rarer of T and F appears at most k times (flip all of them); shrink the left when it is not"
description: "LeetCode 2024 record from 2026-01-10"
date: 2026-01-10
tags: ["medium", "sliding-window", "string", "binary-search", "prefix-sum"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-10
- Submissions: Accepted (first try)

## Approach

Making a stretch of answers all the same needs at least **as many changes as the rarer of T and F**. So a window is valid ⇔ `min(count of T, count of F) <= k`.

The rarer count only grows or stays as the window grows, so the condition is monotonic: use the "longest" sliding window and shrink the left when invalid.

## My Solution

```python
class Solution:
    def maxConsecutiveAnswers(self, answerKey: str, k: int) -> int:
        cnt = Counter()
        left = best = 0
        for right, c in enumerate(answerKey):
            cnt[c] += 1
            while min(cnt["T"], cnt["F"]) > k:     # invalid only if both exceed k
                cnt[answerKey[left]] -= 1
                left += 1
            best = max(best, right - left + 1)
        return best
```

My original counted only `T`, with the condition `count_true > k and (length - count_true) > k`, which means the same thing.

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Running two passes, one for "all T" and one for "all F", also works, but one window looking at the rarer letter is enough.

## Interview Explanation

To make a stretch identical, the fewest changes is the rarer of T and F, so a window is valid when that count is `<= k`. The condition is monotonic in the window size, so I slide a window, shrink the left when invalid, and track the longest length. Time `O(n)`.
