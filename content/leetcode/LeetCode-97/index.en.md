---
title: "LeetCode 97: Interleaving String"
summary: "LeetCode note for Interleaving String, rebuilt from the original learning note"
description: "Cleaned LeetCode 97 article from 2026-07-16 with note repair points and final solution"
date: 2026-07-16
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
First Attempt: 2026-07-16
Source: Day 37 learning note

## Study Context

This article is rebuilt from the exact LeetCode section in the learning note. I kept the note's repair points, comparison points, and common mistakes, while removing unrelated non-LeetCode material from the same day.

## Related Reminders From The Note

- `LC 97`: pass after repair
- `LC 97` greedy-vs-DP explanation: pass after repair
- compare `LC 72` vs `LC 97` state and transition shape in one clean answer

## Learning Note Extract

#### Problem 2 - LC 97 Interleaving String
- **Pattern:** 2D DP on two prefixes with a derived third-string index.

#### Why This Fits
The real question is:
```text
can the prefix s3[:i + j] be formed by interleaving s1[:i] and s2[:j]?
```

That gives a 2D boolean table because:
- once `i` and `j` are known
- the third prefix length is already determined

#### Core State / Invariant
```text
dp[i][j] = whether s3[:i + j] can be formed by interleaving s1[:i] and s2[:j]
```

#### Required Guard
Before any DP:
```text
if len(s1) + len(s2) != len(s3):
    return False
```

Reason:
```text
an interleaving must consume every character exactly once
```

#### Base Case
```text
dp[0][0] = True
```

Reason:
```text
two empty prefixes can form the empty prefix of s3
```

#### Transition
Let:
```text
k = i + j - 1
```

Then:
```text
dp[i][j] is true if either:
1. dp[i - 1][j] is true and s1[i - 1] == s3[k]
2. dp[i][j - 1] is true and s2[j - 1] == s3[k]
```

#### Why This Works
At the last consumed position of `s3`, the character must have come from exactly one of:
- the end of the used prefix of `s1`
- the end of the used prefix of `s2`

If either smaller state is valid and the matching character fits, the current state is valid.

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
- forgetting the length guard
- using `i + j` instead of `i + j - 1` for the current character index
- treating interleaving like substring alternation instead of order-preserving merge
- failing to explain why both transitions can be true at once
- losing track of what `dp[i][j]` means when speaking

#### Strong Spoken Explanation
I define `dp[i][j]` as whether the first `i + j` characters of `s3` can be formed by interleaving the first `i` characters of `s1` and the first `j` characters of `s2`. I first reject if the total lengths do not add up. The empty-empty state is true. For each cell, the last consumed character of `s3` must come either from `s1[i - 1]` or from `s2[j - 1]`, so I check whether either smaller state was already valid and that chosen source character matches the current character in `s3`. The final answer is `dp[len(s1)][len(s2)]`.

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

```python
class Solution:
    def isInterleave(self, s1: str, s2: str, s3: str) -> bool:
        m, n = len(s1), len(s2)
        if m + n != len(s3):
            return False

        dp = [False] * (n + 1)
        dp[0] = True
        for j in range(1, n + 1):
            dp[j] = dp[j - 1] and s2[j - 1] == s3[j - 1]

        for i in range(1, m + 1):
            dp[0] = dp[0] and s1[i - 1] == s3[i - 1]
            for j in range(1, n + 1):
                k = i + j - 1
                dp[j] = (dp[j] and s1[i - 1] == s3[k]) or (dp[j - 1] and s2[j - 1] == s3[k])

        return dp[n]
```

## Complexity

Time O(mn), Space O(n).

## Mistakes To Watch

- Forgetting the length check.
- Using i+j instead of i+j-1 for the s3 index.

## Final Interview Explanation

Start from the state definition, then explain why the transition preserves that state. If there is a loop direction, state compression, or a similar-looking problem with a different answer shape, call that out explicitly because that is where this problem family usually breaks down.
