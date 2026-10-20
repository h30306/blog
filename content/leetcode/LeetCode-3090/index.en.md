---
title: "LeetCode 3090: Maximum Length Substring With Two Occurrences"
summary: "LeetCode 3090 note: a longest-window slide that shrinks the left whenever the newly added character appears more than twice"
description: "LeetCode 3090 record from 2026-01-10"
date: 2026-01-10
tags: ["easy", "sliding-window", "hash-table", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2026-01-10
- Submissions: Accepted (first try)

## Approach

A window is valid ⇔ every character appears at most twice. Each time the right boundary adds a character, **only that character can exceed the limit**, so shrink the left until it is back to two.

[LeetCode 2958]({{< relref "/leetcode/LeetCode-2958" >}}) is the same problem with `k` in place of 2.

## My Solution

```python
class Solution:
    def maximumLengthSubstring(self, s: str) -> int:
        cnt = Counter()
        left = best = 0
        for right, c in enumerate(s):
            cnt[c] += 1
            while cnt[c] > 2:                      # only the new c can exceed
                cnt[s[left]] -= 1
                left += 1
            best = max(best, right - left + 1)
        return best
```

## Complexity

Time `O(n)`, space `O(1)` (at most 26 characters).

## Mistakes to Avoid

- Checking the whole count table every time: only the newly added character can break the rule.

## Interview Explanation

A longest-window slide where each character appears at most twice. After adding a character on the right, only it can exceed two, so I shrink the left until it is back to two and track the longest length. Time `O(n)`.
