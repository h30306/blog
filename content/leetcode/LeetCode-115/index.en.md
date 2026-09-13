---
title: "LeetCode 115: Distinct Subsequences"
summary: "LeetCode Problem Solving - 2D DP on two prefixes with counting"
description: "LeetCode study note from 2026-07-19"
date: 2026-07-19
tags: ["leetcode", "hard", "dynamic-programming", "string"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-07-19
Source Note: `notes/day38-week7-day3-distinct-subsequences-delete-operation-mvcc-locking.md`

## Intuition

I define dp[i][j] as the number of ways the source prefix s[:i] can form the target prefix t[:j] as a subsequence. The empty target has exactly one formation from any source prefix, so dp[i][0] = 1. A nonempty target can

Pattern: 2D DP on two prefixes with counting

## Approach

- **Pattern:** 2D DP on two prefixes with counting.

## Why This Fits
The real question is:
```text
how many ways can s[:i] form t[:j] by deleting characters from s?
```

That gives a counting table over:
- source prefix of `s`
- target prefix of `t`

## Core State / Invariant
```text
dp[i][j] = number of distinct subsequences of s[:i] that equal t[:j]
```

## Base Cases
Empty target:
```text
dp[i][0] = 1
```

Reason:
```text
there is exactly one way to form the empty subsequence:
delete everything
```

Empty source but non-empty target:
```text
dp[0][j] = 0 for j > 0
```

Reason:
```text
an empty source cannot form a non-empty target
```

## Transition
If the current characters match:
```text
s[i - 1] == t[j - 1]
=> dp[i][j] = dp[i - 1][j] + dp[i - 1][j - 1]
```

Why two branches:
- skip `s[i - 1]`
- or use `s[i - 1]` to match the last character of `t[:j]`

If they do not match:
```text
dp[i][j] = dp[i - 1][j]
```

Reason:
```text
the current source character cannot help, so the only option is to skip it
```

## Why This Works
At each source character, there are only two meaningful decisions:
- do not use it
- use it if and only if it matches the needed target character

The DP counts all valid choices without double counting because the two branches differ on whether the current source character is consumed.

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
- forgetting that `dp[i][0] = 1`, not `0`
- using `dp[i][j - 1]` on mismatch
- saying `at least one way` instead of exact count
- mixing substring reasoning into a subsequence problem
- losing track of which string is the source and which is the target

## Strong Spoken Explanation
I define `dp[i][j]` as the number of ways the source prefix `s[:i]` can form the target prefix `t[:j]` as a subsequence. The empty target has exactly one formation from any source prefix, so `dp[i][0] = 1`. A non-empty target cannot be formed from an empty source, so `dp[0][j] = 0` for `j > 0`. If the current characters match, I either skip the current source character or use it to match the current target character, so I add `dp[i - 1][j]` and `dp[i - 1][j - 1]`. If they do not match, I can only skip the current source character, so I carry `dp[i - 1][j]`. The answer is `dp[len(s)][len(t)]`.

## Findings

- Keep the state meaning explicit before writing the transition.
- Check base cases and return value before trusting the recurrence.
- Explain why the iteration order or traversal order preserves the intended invariant.

## Encountered Problems

Captured from the learning note; no separate failure note was recorded.
