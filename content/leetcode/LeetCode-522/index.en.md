---
title: "LeetCode 522: Longest Uncommon Subsequence II"
summary: "LeetCode 522 note: the longest uncommon subsequence is always a whole string; check strings from longest to shortest, and the first that is not a subsequence of any other long-enough string is the answer"
description: "LeetCode 522 record from 2026-04-05"
date: 2026-04-05
tags: ["medium", "two-pointers", "string", "sorting", "array", "hash-table"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-04-05
- Submissions: Accepted (first try)

## Approach

**Key observation: if some subsequence of a string is uncommon (not a subsequence of any other string), the whole string is uncommon too.** If the whole string fit inside another string, every one of its subsequences would fit as well. So only whole strings need checking.

`strs[i]` is uncommon when, for every `j != i`, `strs[i]` is not a subsequence of `strs[j]`.

- Strings shorter than `strs[i]` cannot contain it, so skip them.
- Sort by length descending; the first string that qualifies is the answer. If none does, return `-1`.

The subsequence check uses same-direction pointers: `i` walks the shorter string and advances only on a match, while the scan over the longer string advances every step; at the end, check whether `i` finished.

## My Solution

```python
class Solution:
    def findLUSlength(self, strs: List[str]) -> int:
        def is_subsequence(s: str, t: str) -> bool:    # is s a subsequence of t
            i = 0
            for ch in t:
                if i < len(s) and s[i] == ch:
                    i += 1
            return i == len(s)

        strs.sort(key=len, reverse=True)
        n = len(strs)
        for i in range(n):
            uncommon = True
            for j in range(n):
                if len(strs[j]) < len(strs[i]):
                    break                              # the rest are shorter and cannot contain strs[i]
                if i != j and is_subsequence(strs[i], strs[j]):
                    uncommon = False
                    break
            if uncommon:
                return len(strs[i])
        return -1
```

Duplicate strings are subsequences of each other, so they rule themselves out with no special handling.

## Complexity

Time `O(n^2 · L)`, where `L` is the string length; space `O(1)` apart from sorting.

## Mistakes to Avoid

- Enumerating every subsequence of each string: exponential.
- Comparing only with strictly longer strings: equal-length strings with the same content must be compared too.

## Interview Explanation

If a subsequence is uncommon, the whole string containing it is uncommon too, so the answer is always the length of a whole string. I sort strings by length descending and check whether each one is a subsequence of any other string at least as long, using two pointers. The first one that is not is the answer; otherwise I return `-1`. Time `O(n^2 · L)`.
