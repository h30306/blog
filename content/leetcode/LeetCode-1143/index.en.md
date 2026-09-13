---
title: "LeetCode 1143: Longest Common Subsequence"
summary: "LeetCode Problem Solving - 2D DP on two prefixes"
description: "LeetCode study note from 2026-07-11"
date: 2026-07-11
tags: ["leetcode", "medium", "dynamic-programming", "string"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-07-11
Source Note: `notes/day36-week7-day1-lcs-lps-acid-concrete-examples.md`

## Intuition

I define dp[i][j] as the LCS length between the prefixes text1[:i] and text2[:j]. The base row and base column are zero because an empty prefix cannot contribute any positive common subsequence. If the current characters

Pattern: 2D DP on two prefixes

## Approach

- **Pattern:** 2D DP on two prefixes.

## Why This Fits
At any pair of positions, the question is:
```text
what is the LCS length for the prefixes up to these two positions?
```

That naturally gives a 2D table over:
- prefix of `text1`
- prefix of `text2`

## Core State / Invariant
```text
dp[i][j] = length of the longest common subsequence between text1[:i] and text2[:j]
```

## Base Case
If either prefix is empty:
```text
dp[i][0] = 0
dp[0][j] = 0
```

Reason:
```text
an empty string has no common subsequence with positive length
```

## Transition
If the new characters match:
```text
text1[i - 1] == text2[j - 1]
=> dp[i][j] = dp[i - 1][j - 1] + 1
```

If they do not match:
```text
dp[i][j] = max(dp[i - 1][j], dp[i][j - 1])
```

## Why This Works
- match:
  - the matching characters can extend the best subsequence from the smaller prefixes
- mismatch:
  - one of the two last characters is not used, so drop one side and keep the better answer

## Complexity
```text
Time: O(m * n)
Space: O(m * n)
```

Can be compressed to:
```text
Space: O(n)
```

## Common Mistakes
- using substring instead of subsequence reasoning
- mixing character index with prefix length index
- forgetting that mismatch takes `max(up, left)`
- saying diagonal is used on every step

## Strong Spoken Explanation
I define `dp[i][j]` as the LCS length between the prefixes `text1[:i]` and `text2[:j]`. The base row and base column are zero because an empty prefix cannot contribute any positive common subsequence. If the current characters match, I extend the smaller-prefix answer from the diagonal by one. If they do not match, I drop one side and keep the better result from `up` or `left`. The final answer is `dp[m][n]`.

## Findings

- Keep the state meaning explicit before writing the transition.
- Check base cases and return value before trusting the recurrence.
- Explain why the iteration order or traversal order preserves the intended invariant.

## Encountered Problems

Captured from the learning note; no separate failure note was recorded.
