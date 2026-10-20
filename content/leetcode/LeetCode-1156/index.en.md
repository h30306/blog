---
title: "LeetCode 1156: Swap For Longest Repeated Character Substring"
summary: "LeetCode 1156 note: for each character c, find the longest window with at most one non-c; the swapped-in c must come from elsewhere, so the length is capped at the total count of c"
description: "LeetCode 1156 record from 2026-01-23"
date: 2026-01-23
tags: ["medium", "sliding-window", "hash-table", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-23
- Submissions: Accepted (first try)

## Approach

With at most one swap, the final run is some character `c`. Handle each `c` separately:

- Find the longest window with **at most one character that is not `c`**; that character can be swapped with a `c` elsewhere.
- But the swapped-in `c` must come from outside the window. If every `c` is already inside, none can come in, and the best is to move an edge `c` inward, giving the total count of `c`.
- So this `c` contributes `min(window length, total[c])`.

At most 26 characters, each with one `O(n)` sliding window.

## My Solution

```python
class Solution:
    def maxRepOpt1(self, text: str) -> int:
        total = Counter(text)
        best = 0
        for c in total:
            left = other = 0
            for right, ch in enumerate(text):
                other += ch != c
                while other > 1:                   # at most one non-c
                    other -= text[left] != c
                    left += 1
                best = max(best, min(right - left + 1, total[c]))
        return best
```

## Complexity

Time `O(26 · n)`, space `O(26)`.

## Mistakes to Avoid

- Forgetting the cap at the total count of `c`: `"aaabaaa"` has only 6 `a`s, so the answer is 6, not 7.

## Interview Explanation

The final run is some character `c`, so for each character I find the longest window with at most one non-`c`, which can be swapped for a `c` elsewhere. That `c` has to come from outside, so the length is capped at the total count of `c`, and I take the smaller. One window per character: `O(26n)`.
