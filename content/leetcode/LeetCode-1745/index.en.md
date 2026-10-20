---
title: "LeetCode 1745: Palindrome Partitioning IV"
summary: "LeetCode 1745 note: build is_pal[i][j] with interval DP, then try both cut points; three palindromic parts means true, O(n^2)"
description: "LeetCode 1745 record from 2026-06-27"
date: 2026-06-27
tags: ["hard", "dynamic-programming", "interval-dp", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-06-27
- Submissions: Wrong Answer ×2 → Accepted (brute force) → Accepted ×2 (palindrome table)

## Approach

1. Build `is_pal[i][j]` with interval DP: `s[i] == s[j]` and the inside is a palindrome (immediate for length `<= 2`), filled from short to long.
2. Try both cut points: part 1 `[0, i]`, part 2 `[i + 1, j]`, part 3 `[j + 1, n - 1]`, all non-empty: `0 <= i < j < n - 1`.

## My Attempts

The first three versions sliced the string and checked `s == s[::-1]`, `O(n^3)`. Both WAs were about the cut ranges:

| Version | Problem |
|---|---|
| Attempt 1 | Skipped `j == n - 1` (`j` is where part 3 starts), missing a one-character last part. For `s = "aab"`, `"a" + "a" + "b"` works, so the answer is `True`; it returned `False` |
| Attempt 2 | Removed that restriction, but `j` started at `i`, allowing an empty middle part. For `s = "abab"`, `"aba" + "" + "b"` was accepted; the answer is `False` and it returned `True` |
| Attempt 3, AC | Started `j` at `i + 1`, but the slicing brute force took 8 seconds |

Building the palindrome table first made it `O(n^2)`.

## Solution

```python
class Solution:
    def checkPartitioning(self, s: str) -> bool:
        n = len(s)
        is_pal = [[False] * n for _ in range(n)]
        for i in range(n - 1, -1, -1):
            for j in range(i, n):
                is_pal[i][j] = s[i] == s[j] and (j - i < 2 or is_pal[i + 1][j - 1])

        for i in range(n - 2):                     # part 1 is [0, i]
            if not is_pal[0][i]:
                continue
            for j in range(i + 1, n - 1):          # part 2 is [i+1, j], part 3 is [j+1, n-1]
                if is_pal[i + 1][j] and is_pal[j + 1][n - 1]:
                    return True
        return False
```

## Complexity

Time `O(n^2)`, space `O(n^2)`.

## Mistakes to Avoid

- All three parts must be non-empty; spell out the cut ranges.
- Slicing and checking each time: `O(n^3)`.

## Interview Explanation

I build a palindrome table with interval DP: `s[i]` equal to `s[j]` with a palindromic inside makes a palindrome. Then I try both cut points, keeping all three parts non-empty, and return `True` if all three are palindromes. Both steps are `O(n^2)`.
