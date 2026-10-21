---
title: "LeetCode 3713: Longest Balanced Substring I"
summary: "LeetCode 3713 note: fix the start and extend right; "every character has the same count" means "highest count × kinds = length", an O(1) check per step"
description: "LeetCode 3713 record from 2026-06-22"
date: 2026-06-22
tags: ["medium", "hash-table", "string", "counting", "enumeration"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-06-22
- Submissions: Time Limit Exceeded → Accepted (1.9 s)

## Approach

With `n <= 1000`, enumerating all substrings is `O(n²)`. Fix the start and extend right, maintaining each character's count incrementally ([String]({{< relref "/algorithm/String" >}}) Template 5).

Checking "every character has the same count" does not require comparing all counts: if each appears `f` times, the length is `f × kinds`; conversely, if the highest count is `f` and the length equals `f × kinds`, every kind must be exactly `f`. So track `max_freq` and the number of kinds for an `O(1)` check per step.

## My Attempts

Attempt 1 wrapped everything in an extra loop over "number of kinds, 1 to 26", doing 26 times the work, TLE. Removing it passed, but checking `len(set(freq.values()))` each step still took 1.9 s.

## Solution

```python
class Solution:
    def longestBalanced(self, s: str) -> int:
        n, best = len(s), 0
        for i in range(n):
            cnt = Counter()
            max_freq = 0
            for j in range(i, n):
                cnt[s[j]] += 1
                max_freq = max(max_freq, cnt[s[j]])
                if max_freq * len(cnt) == j - i + 1:
                    best = max(best, j - i + 1)
        return best
```

## Complexity

Time `O(n²)`, space `O(1)` (at most 26 characters).

## Mistakes to Avoid

- Do not add an unnecessary layer of enumeration.
- Building a `set` of counts each step is `O(26)`; "highest count × kinds = length" is `O(1)`.

## Interview Explanation

I fix the start and extend right, tracking counts, the highest count, and the number of kinds. All counts are equal exactly when the highest count times the number of kinds equals the length, an `O(1)` check per step, `O(n²)` overall.
