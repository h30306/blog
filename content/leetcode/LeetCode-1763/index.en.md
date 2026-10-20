---
title: "LeetCode 1763: Longest Nice Substring"
summary: "LeetCode 1763 note: a character whose other case never appears cannot be in the answer, so split on it and recurse, preferring the left side on ties"
description: "LeetCode 1763 record from 2026-01-17"
date: 2026-01-17
tags: ["easy", "sliding-window", "divide-and-conquer", "hash-table", "string", "bit-manipulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2026-01-17
- Submissions: Wrong Answer ×3 → Accepted (sliding window) → Accepted (divide and conquer)

## Approach

The same family as [LeetCode 395]({{< relref "/leetcode/LeetCode-395" >}}): "both cases of every letter appear" is not monotonic.

**Divide and conquer**: if a character's other case appears nowhere in the string, the answer cannot contain it. Split on it, recurse on both sides, and take the longer result, the left one on a tie (the problem wants the earliest).

With `n <= 100`, enumerating every substring in `O(n^2 · 26)` also works.

## My Attempts

My first four versions used 395's approach: enumerate the number of letters in the window (ignoring case), slide with that fixed, and check whether the uppercase and lowercase letter sets match. All three WAs were in the update when the left character leaves:

| Version | Problem |
|---|---|
| Attempt 1 | Decremented the distinct count as soon as one case's count hit zero, though the other case might still be in the window. For `s = "AabAAa"` the answer is `"AAa"`; it returned `"Aa"` |
| Attempt 2 | Decremented only when both cases hit zero, but when one hit zero while the other remained, **the key was not deleted**, so comparing `keys()` included zero-count keys. For `s = "acAbB"`, `"AbB"` has no lowercase `a` but was judged nice; the answer is `"bB"` |
| Attempt 3 | Compared whole dicts, which also required the uppercase and lowercase **counts** to match. For `s = "AaA"` the answer is `"AaA"`; it returned `"Aa"` |
| Attempt 4, AC | Deleted keys at zero and decremented the distinct count only when both cases were gone |

Switching to divide and conquer afterwards was much simpler.

## Solution

```python
class Solution:
    def longestNiceSubstring(self, s: str) -> str:
        chars = set(s)
        for i, c in enumerate(s):
            if c.swapcase() not in chars:          # c cannot be in the answer
                left = self.longestNiceSubstring(s[:i])
                right = self.longestNiceSubstring(s[i + 1:])
                return left if len(left) >= len(right) else right   # left wins ties
        return s
```

## Complexity

Time `O(n^2)` (one split per level, at most `n` levels of `O(n)`), space `O(n)` recursion depth.

## Mistakes to Avoid

- On equal lengths, return the earliest substring.
- When comparing `dict.keys()`, delete keys whose count reaches zero.

## Interview Explanation

A character whose other case never appears cannot be in the answer, so I split the string on it, recurse on both sides, and take the longer result, the left one on a tie. When every character has its pair, the whole string is the answer. With `n` only 100, the worst case `O(n^2)` is fine.
