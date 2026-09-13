---
title: "LeetCode 583: Delete Operation for Two Strings"
summary: "LeetCode Problem Solving - 2D DP on two prefixes with delete-only cost"
description: "LeetCode study note from 2026-07-19"
date: 2026-07-19
tags: ["leetcode", "medium", "dynamic-programming", "string"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-07-19
Source Note: `notes/day38-week7-day3-distinct-subsequences-delete-operation-mvcc-locking.md`

## Intuition

I define dp[i][j] as the minimum deletions needed to make word1[:i] and word2[:j] equal. If one prefix is empty, I must delete every character from the other prefix, so the first row and first column are just their lengt

Pattern: 2D DP on two prefixes with delete-only cost

## Approach

- **Pattern:** 2D DP on two prefixes with delete-only cost.

## Why This Fits
The real question is:
```text
what is the minimum number of deletions needed to make word1[:i] and word2[:j] equal?
```

That is still a two-prefix table, but now the table stores:
- minimum cost
- not boolean validity
- not count of ways

## Core State / Invariant
```text
dp[i][j] = minimum deletions needed to make word1[:i] and word2[:j] equal
```

## Base Cases
If `word2` is empty:
```text
dp[i][0] = i
```

Reason:
```text
delete all i characters from word1
```

If `word1` is empty:
```text
dp[0][j] = j
```

Reason:
```text
delete all j characters from word2
```

## Transition
If the current characters already match:
```text
word1[i - 1] == word2[j - 1]
=> dp[i][j] = dp[i - 1][j - 1]
```

If they do not match:
```text
dp[i][j] = 1 + min(
    dp[i - 1][j],  # delete word1[i - 1]
    dp[i][j - 1]   # delete word2[j - 1]
)
```

## Why This Works
On mismatch, replacement is not allowed.

So one deletion must happen first:
- either delete from `word1`
- or delete from `word2`

Then solve the smaller subproblem.

## Alternative View Through LCS
This problem can also be defended as:
```text
answer = len(word1) + len(word2) - 2 * LCS(word1, word2)
```

Reason:
```text
the longest common subsequence is the part both strings keep;
everything else must be deleted
```

Interview-safe rule:
- direct DP is usually easier if you want one self-contained recurrence
- LCS reduction is good if the interviewer asks for relation between patterns

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
- accidentally adding a replace branch from `LC 72`
- forgetting the answer is deletions across both strings, not one string only
- saying mismatch is `min(diagonal, up, left)` because edit distance is in your head
- using LCS reduction without being able to justify it
- drifting into substring instead of subsequence / deletion reasoning

## Strong Spoken Explanation
I define `dp[i][j]` as the minimum deletions needed to make `word1[:i]` and `word2[:j]` equal. If one prefix is empty, I must delete every character from the other prefix, so the first row and first column are just their lengths. If the current characters match, I keep them both and take the diagonal. If they do not match, replacement is not allowed, so one deletion must happen first: either delete the current character from `word1` or delete the current character from `word2`, then take the cheaper result and add one. The answer is `dp[m][n]`.

## Findings

- Keep the state meaning explicit before writing the transition.
- Check base cases and return value before trusting the recurrence.
- Explain why the iteration order or traversal order preserves the intended invariant.

## Encountered Problems

Captured from the learning note; no separate failure note was recorded.
