---
title: "LeetCode 1208: Get Equal Substrings Within Budget"
summary: "LeetCode 1208 note: each position costs |s[i] - t[i]|, so the problem becomes the longest subarray with sum <= maxCost"
description: "LeetCode 1208 record from 2026-01-10"
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

Position `i` costs `|ord(s[i]) - ord(t[i])|`, always non-negative. The problem becomes: **the longest subarray of costs with sum `<= maxCost`**.

With non-negative costs, a larger window has a larger sum, so the condition is monotonic: use the "longest" sliding window.

## My Solution

```python
class Solution:
    def equalSubstring(self, s: str, t: str, maxCost: int) -> int:
        left = cost = best = 0
        for right in range(len(s)):
            cost += abs(ord(s[right]) - ord(t[right]))
            while cost > maxCost:
                cost -= abs(ord(s[left]) - ord(t[left]))
                left += 1
            best = max(best, right - left + 1)
        return best
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- With negative costs a sliding window would not work, but these are absolute values, so they are never negative.

## Interview Explanation

Turning each position into a cost `|s[i] - t[i]|` makes this the longest subarray with sum at most `maxCost`. Costs are non-negative, so a sliding window works: shrink the left when over budget and track the longest length. Time `O(n)`.
