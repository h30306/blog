---
title: "LeetCode 72: Edit Distance"
summary: "LeetCode Problem Solving - 2D DP on two prefixes with edit operations"
description: "LeetCode study note from 2026-07-16"
date: 2026-07-16
tags: ["leetcode", "medium", "dynamic-programming", "string"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-07-16
Source Note: `notes/day37-week7-day2-edit-distance-interleaving-isolation-levels.md`

## Intuition

I define dp[i][j] as the minimum edits needed to convert word1[:i] into word2[:j]. The first column is i because converting a nonempty source prefix into an empty target means deleting all source characters. The first ro

Pattern: 2D DP on two prefixes with edit operations

## Approach

- **Pattern:** 2D DP on two prefixes with edit operations.

## Why This Fits
At each table cell, the question is:
```text
what is the minimum number of edits needed to convert word1[:i] into word2[:j]?
```

That naturally gives a 2D table over:
- source prefix of `word1`
- target prefix of `word2`

## Core State / Invariant
```text
dp[i][j] = minimum number of operations needed to convert word1[:i] into word2[:j]
```

The direction matters:
- source = `word1`
- target = `word2`

## Base Cases
If the target is empty:
```text
dp[i][0] = i
```

Reason:
```text
delete all i source characters
```

If the source is empty:
```text
dp[0][j] = j
```

Reason:
```text
insert all j target characters
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
    dp[i - 1][j],     # delete word1[i - 1]
    dp[i][j - 1],     # insert word2[j - 1]
    dp[i - 1][j - 1]  # replace word1[i - 1] with word2[j - 1]
)
```

## Why This Works
- delete:
  - remove the last source character and solve the smaller source prefix
- insert:
  - create the last target character after solving the smaller target prefix
- replace:
  - align the last source character to the last target character in one step

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
- mixing up insert and delete because the source / target direction was never stated
- writing the right recurrence but being unable to explain what each branch means
- forgetting that the diagonal stays unchanged on a character match
- using vague language like `change one side`
- returning the wrong cell instead of `dp[m][n]`

## Strong Spoken Explanation
I define `dp[i][j]` as the minimum edits needed to convert `word1[:i]` into `word2[:j]`. The first column is `i` because converting a non-empty source prefix into an empty target means deleting all source characters. The first row is `j` because converting an empty source into a non-empty target means inserting all target characters. If the current characters match, no extra edit is needed and I take the diagonal. Otherwise I try the three edit choices from the source-to-target point of view: delete the current source character, insert the current target character, or replace the current source character with the current target character. The answer is `dp[m][n]`.

## Findings

- Keep the state meaning explicit before writing the transition.
- Check base cases and return value before trusting the recurrence.
- Explain why the iteration order or traversal order preserves the intended invariant.

## Encountered Problems

Captured from the learning note; no separate failure note was recorded.
