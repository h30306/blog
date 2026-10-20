---
title: "LeetCode 940: Distinct Subsequences II"
summary: "LeetCode 940 note: group by last character; distinct subsequences ending with c = every current distinct subsequence with c appended, plus c itself, replacing the old value"
description: "LeetCode 940 record from 2026-09-12"
date: 2026-09-12
tags: ["hard", "dynamic-programming", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-09-12
- Submissions: Accepted (first try)

## Approach

"Pick or skip each character" counts identical subsequences many times (in `"aa"`, picking either `a` gives `"a"`).

**Group by last character**: `end[c]` = the number of distinct subsequences ending with `c`. On a new character `c`:

- Every current distinct subsequence (`sum(end.values())` of them) can have `c` appended, giving subsequences ending with `c`.
- Plus `"c"` on its own.

These new ones **already include every old subsequence ending with `c`** (the old ones extended earlier subsequences, which are all still present), so overwrite `end[c]` rather than adding.

The answer is `sum(end.values())`.

## My Solution

```python
class Solution:
    def distinctSubseqII(self, s: str) -> int:
        MOD = 10 ** 9 + 7
        end = {}                                   # distinct subsequences ending with each character
        for c in s:
            end[c] = (sum(end.values()) + 1) % MOD # append c to all, plus "c" itself
        return sum(end.values()) % MOD
```

## Complexity

Time `O(26 · n)`, space `O(26)`.

## Mistakes to Avoid

- Overwrite `end[c]`, do not accumulate it: accumulating recounts the old subsequences ending with `c`.
- Only non-empty subsequences count, so do not add the empty string.

## Interview Explanation

I group distinct subsequences by their last character. On character `c`, appending `c` to every current distinct subsequence, plus `c` alone, gives every distinct subsequence ending in `c`, already including the old ones, so I overwrite. The answer sums the 26 groups. Time `O(26n)`.
