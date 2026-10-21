---
title: "LeetCode 424: Longest Repeating Character Replacement"
summary: "LeetCode 424 note: a variable sliding window where window length minus the top character count is the number of replacements; shrink when it exceeds k"
description: "LeetCode 424 record from 2022-10-28"
date: 2022-10-28
tags: ["medium", "hash-table", "string", "sliding-window"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-10-28
- Submissions: Accepted ×4 → Runtime Error → Accepted

## Approach

To make the window a single character, keep the most frequent one and replace the other `length - maxCount`. Extend the right end by one each step and shrink the left by one when the replacements needed exceed `k` ([Sliding Window]({{< relref "/algorithm/Sliding-Window" >}}) Template 2). With 26 letters, `max(count.values())` is `O(26)`.

## My Attempts

It passed in 2022; one 2026 rewrite raised an RE: `max(count)` returned a character key that was compared with an integer (TypeError), and shrinking used `count[i]` (the index, not the character). Fixing both passed.

## Solution

```python
class Solution:
    def characterReplacement(self, s: str, k: int) -> int:
        count = defaultdict(int)
        res = l = 0
        for r, ch in enumerate(s):
            count[ch] += 1
            while (r - l + 1) - max(count.values()) > k:
                count[s[l]] -= 1
                l += 1
            res = max(res, r - l + 1)
        return res
```

## Complexity

Time `O(26n)`, space `O(26)`.

## Mistakes to Avoid

- When shrinking, decrement `count[s[l]]` (the character), not `count[l]` (the index).
- `max(count)` is the largest key; the largest count is `max(count.values())`.

## Interview Explanation

I use a variable sliding window: window length minus the top character count is the number of replacements; when it exceeds k I shrink from the left, tracking the longest window. With 26 letters, time is `O(26n)`.
