---
title: "LeetCode 583: Delete Operation for Two Strings"
summary: "LeetCode note for Delete Operation for Two Strings, rebuilt from the original learning note"
description: "Cleaned LeetCode 583 article from 2026-07-19 with note repair points and final solution"
date: 2026-07-19
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
First Attempt: 2026-07-19
Source: Day 38 learning note

## Study Context

This article is rebuilt from the exact LeetCode section in the learning note. I kept the note's repair points, comparison points, and common mistakes, while removing unrelated non-LeetCode material from the same day.

## Related Reminders From The Note

- explain `LC 583` as delete-only DP and say why mismatch has only two branches
- rebuild the full `LC 72` table from memory and compare it cleanly with `LC 583`
- `LC 583` vs `LC 72`

## Learning Note Extract

#### Problem 2 - LC 583 Delete Operation for Two Strings
- **Pattern:** 2D DP on two prefixes with delete-only cost.

#### Why This Fits
The real question is:
```text
what is the minimum number of deletions needed to make word1[:i] and word2[:j] equal?
```

That is still a two-prefix table, but now the table stores:
- minimum cost
- not boolean validity
- not count of ways

#### Core State / Invariant
```text
dp[i][j] = minimum deletions needed to make word1[:i] and word2[:j] equal
```

#### Base Cases
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

#### Transition
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

#### Why This Works
On mismatch, replacement is not allowed.

So one deletion must happen first:
- either delete from `word1`
- or delete from `word2`

Then solve the smaller subproblem.

#### Alternative View Through LCS
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
- accidentally adding a replace branch from `LC 72`
- forgetting the answer is deletions across both strings, not one string only
- saying mismatch is `min(diagonal, up, left)` because edit distance is in your head
- using LCS reduction without being able to justify it
- drifting into substring instead of subsequence / deletion reasoning

#### Strong Spoken Explanation
I define `dp[i][j]` as the minimum deletions needed to make `word1[:i]` and `word2[:j]` equal. If one prefix is empty, I must delete every character from the other prefix, so the first row and first column are just their lengths. If the current characters match, I keep them both and take the diagonal. If they do not match, replacement is not allowed, so one deletion must happen first: either delete the current character from `word1` or delete the current character from `word2`, then take the cheaper result and add one. The answer is `dp[m][n]`.

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

```python
class Solution:
    def minDistance(self, word1: str, word2: str) -> int:
        m, n = len(word1), len(word2)
        dp = [0] * (n + 1)

        for i in range(1, m + 1):
            prev_diag = 0
            for j in range(1, n + 1):
                old = dp[j]
                if word1[i - 1] == word2[j - 1]:
                    dp[j] = prev_diag + 1
                else:
                    dp[j] = max(dp[j], dp[j - 1])
                prev_diag = old

        lcs = dp[n]
        return m + n - 2 * lcs
```

## Complexity

Time O(mn), Space O(n).

## Mistakes To Watch

- Using edit distance with replace; only deletes are allowed.
- Forgetting both strings pay deletions.

## Final Interview Explanation

Start from the state definition, then explain why the transition preserves that state. If there is a loop direction, state compression, or a similar-looking problem with a different answer shape, call that out explicitly because that is where this problem family usually breaks down.
