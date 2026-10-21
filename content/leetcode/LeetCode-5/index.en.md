---
title: "LeetCode 5: Longest Palindromic Substring"
summary: "LeetCode 5 note: expand around centers, using each position as an odd and an even center; with interval DP, iterate i from large to small"
description: "LeetCode 5 record from 2022-10-20"
date: 2022-10-20
tags: ["medium", "two-pointers", "string", "dynamic-programming", "manacher"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-10-20
- Submissions: Accepted ×3 → Runtime Error → Accepted ×2 → Wrong Answer → Runtime Error → Wrong Answer → Accepted ×4 → Wrong Answer → Accepted

## Approach

Expand around centers: a palindrome is symmetric about a center that is a character (odd length) or a gap (even length), `2n - 1` centers in all. Expand each until the symmetry breaks and keep the longest, in `O(n²)` time and `O(1)` space.

Interval DP ([Interval DP]({{< relref "/algorithm/Interval-DP" >}})): `dp[i][j] = s[i] == s[j] and dp[i + 1][j - 1]`; since it depends on `i + 1`, **compute `i` from large to small**.

## My Attempts

I wrote this in both 2022 and 2026:

- Rewriting center expansion on 2022-11-15, the helper first returned a **length** and so did the function; after returning substrings, I assigned `res = longest` (an integer) instead of `res = length` (the substring).
- Practicing interval DP in 2026-08, one version iterated `i` upward, **reading `dp[i + 1][j - 1]` before it was computed**, and failed; iterating `i` downward passed.

## Solution

```python
class Solution:
    def longestPalindrome(self, s: str) -> str:
        def expand(l, r):
            while l >= 0 and r < len(s) and s[l] == s[r]:
                l, r = l - 1, r + 1
            return l + 1, r
        best = (0, 1)
        for i in range(len(s)):
            for l, r in (expand(i, i), expand(i, i + 1)):
                if r - l > best[1] - best[0]:
                    best = (l, r)
        return s[best[0]:best[1]]
```

## Complexity

Time `O(n²)`, space `O(1)`.

## Mistakes to Avoid

- Try even-length centers too.
- Return the substring, not its length.
- Interval DP depends on `dp[i + 1][j - 1]`, so iterate `i` backwards.

## Interview Explanation

I expand around every character and every gap between characters, keeping the longest palindrome, in `O(n²)` time and `O(1)` space. With interval DP, dp[i][j] depends on dp[i + 1][j - 1], so i runs backwards.
