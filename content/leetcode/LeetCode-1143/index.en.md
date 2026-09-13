---
title: "LeetCode 1143: Longest Common Subsequence"
summary: "LeetCode note for Longest Common Subsequence, rebuilt from the original learning note"
description: "Cleaned LeetCode 1143 article from 2026-07-11 with note repair points and final solution"
date: 2026-07-11
tags: ["medium", "dynamic-programming", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-07-11
Source: Day 36 learning note

## Study Context

This article is rebuilt from the exact LeetCode section in the learning note. I kept the note's repair points, comparison points, and common mistakes, while removing unrelated non-LeetCode material from the same day.

## Related Reminders From The Note

- `LC 1143`: pass after mismatch-proof wording repair
- explain `LC 1143` with exact prefix-based state and mismatch transition

## Learning Note Extract

#### Problem 1 - LC 1143 Longest Common Subsequence
- **Pattern:** 2D DP on two prefixes.

#### Why This Fits
At any pair of positions, the question is:
```text
what is the LCS length for the prefixes up to these two positions?
```

That naturally gives a 2D table over:
- prefix of `text1`
- prefix of `text2`

#### Core State / Invariant
```text
dp[i][j] = length of the longest common subsequence between text1[:i] and text2[:j]
```

#### Base Case
If either prefix is empty:
```text
dp[i][0] = 0
dp[0][j] = 0
```

Reason:
```text
an empty string has no common subsequence with positive length
```

#### Transition
If the new characters match:
```text
text1[i - 1] == text2[j - 1]
=> dp[i][j] = dp[i - 1][j - 1] + 1
```

If they do not match:
```text
dp[i][j] = max(dp[i - 1][j], dp[i][j - 1])
```

#### Why This Works
- match:
  - the matching characters can extend the best subsequence from the smaller prefixes
- mismatch:
  - one of the two last characters is not used, so drop one side and keep the better answer

#### Complexity
```text
Time: O(m * n)
Space: O(m * n)
```

Can be compressed to:
```text
Space: O(n)
```

#### Common Mistakes
- using substring instead of subsequence reasoning
- mixing character index with prefix length index
- forgetting that mismatch takes `max(up, left)`
- saying diagonal is used on every step

#### Strong Spoken Explanation
I define `dp[i][j]` as the LCS length between the prefixes `text1[:i]` and `text2[:j]`. The base row and base column are zero because an empty prefix cannot contribute any positive common subsequence. If the current characters match, I extend the smaller-prefix answer from the diagonal by one. If they do not match, I drop one side and keep the better result from `up` or `left`. The final answer is `dp[m][n]`.

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

```python
class Solution:
    def longestCommonSubsequence(self, text1: str, text2: str) -> int:
        m, n = len(text1), len(text2)
        dp = [[0] * (n + 1) for _ in range(m + 1)]

        for i in range(1, m + 1):
            for j in range(1, n + 1):
                if text1[i - 1] == text2[j - 1]:
                    dp[i][j] = dp[i - 1][j - 1] + 1
                else:
                    dp[i][j] = max(dp[i - 1][j], dp[i][j - 1])

        return dp[m][n]
```

## Complexity

Time O(mn), Space O(mn), compressible to O(n).

## Mistakes To Watch

- Using substring logic; subsequence does not require contiguous characters.
- On mismatch, incorrectly taking diagonal.

## Final Interview Explanation

Start from the state definition, then explain why the transition preserves that state. If there is a loop direction, state compression, or a similar-looking problem with a different answer shape, call that out explicitly because that is where this problem family usually breaks down.
