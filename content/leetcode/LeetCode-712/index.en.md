---
title: "LeetCode 712: Minimum ASCII Delete Sum for Two Strings"
summary: "LeetCode note for Minimum ASCII Delete Sum for Two Strings, rebuilt from the original learning note"
description: "Cleaned LeetCode 712 article from 2026-07-21 with note repair points and final solution"
date: 2026-07-21
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
First Attempt: 2026-07-21
Source: Day 39 learning note

## Study Context

This article is rebuilt from the exact LeetCode section in the learning note. I kept the note's repair points, comparison points, and common mistakes, while removing unrelated non-LeetCode material from the same day.

## Related Reminders From The Note

- `LC 712`: pass after repair
- explain `LC 712` with exact weighted delete-cost state, ASCII-sum base cases, and mismatch branches

## Learning Note Extract

#### Problem 1 - LC 712 Minimum ASCII Delete Sum for Two Strings
- **Pattern:** 2D DP on two prefixes with weighted delete-only cost.

#### Why This Fits
The real question is:
```text
what is the minimum total ASCII delete cost needed
to make s1[:i] and s2[:j] equal?
```

That is still a two-prefix table, but now:
- mismatch cost is not always `1`
- it depends on which character is deleted

#### Core State / Invariant
```text
dp[i][j] = minimum ASCII delete cost needed to make s1[:i] and s2[:j] equal
```

#### Base Cases
If `s2` is empty:
```text
dp[i][0] = sum(ASCII values of s1[:i])
```

Reason:
```text
every character in s1[:i] must be deleted
```

If `s1` is empty:
```text
dp[0][j] = sum(ASCII values of s2[:j])
```

Reason:
```text
every character in s2[:j] must be deleted
```

#### Transition
If the current characters already match:
```text
s1[i - 1] == s2[j - 1]
=> dp[i][j] = dp[i - 1][j - 1]
```

If they do not match:
```text
dp[i][j] = min(
    dp[i - 1][j] + ASCII(s1[i - 1]),
    dp[i][j - 1] + ASCII(s2[j - 1])
)
```

#### Why This Works
On mismatch, the final equal strings cannot keep both current characters.

So one of them must be deleted first:
- delete from `s1`
- or delete from `s2`

Then solve the smaller prefix problem.

Unlike `LC 72`, there is:
- no replace
- no insert

Unlike `LC 583`, the delete cost is:
- weighted by character value
- not unit cost

#### Alternative View
There is also a relation to keeping the maximum ASCII-sum common subsequence:
```text
answer = sumASCII(s1) + sumASCII(s2) - 2 * maxKeptCommonASCII
```

Interview-safe rule:
- the direct delete-cost DP is easier to derive correctly in real time
- mention the reduction only if asked for a connection to `LCS`

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
- copying `LC 583` and leaving base cases as prefix lengths instead of ASCII prefix sums
- adding a diagonal mismatch branch because edit distance is still in your head
- saying `delete the cheaper side` greedily without DP
- forgetting that match means no extra delete cost
- mixing up character value with index value

#### Strong Spoken Explanation
I define `dp[i][j]` as the minimum total ASCII delete cost needed to make `s1[:i]` and `s2[:j]` equal. If one prefix is empty, the only option is to delete every character from the other prefix, so the first row and first column are prefix ASCII sums, not prefix lengths. If the current characters match, I can keep both and take the diagonal with no extra cost. If they do not match, one of the two current characters must be deleted first, so I try deleting from `s1` or deleting from `s2` and add that character's ASCII value. The answer is `dp[m][n]`.

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

```python
class Solution:
    def minimumDeleteSum(self, s1: str, s2: str) -> int:
        n = len(s2)
        dp = [0] * (n + 1)
        for j in range(1, n + 1):
            dp[j] = dp[j - 1] + ord(s2[j - 1])

        for i in range(1, len(s1) + 1):
            prev_diag = dp[0]
            dp[0] += ord(s1[i - 1])
            for j in range(1, n + 1):
                old = dp[j]
                if s1[i - 1] == s2[j - 1]:
                    dp[j] = prev_diag
                else:
                    dp[j] = min(dp[j] + ord(s1[i - 1]), dp[j - 1] + ord(s2[j - 1]))
                prev_diag = old

        return dp[n]
```

## Complexity

Time O(mn), Space O(n).

## Mistakes To Watch

- Using unit-cost LC 583 recurrence.
- Forgetting weighted base cases.

## Final Interview Explanation

Start from the state definition, then explain why the transition preserves that state. If there is a loop direction, state compression, or a similar-looking problem with a different answer shape, call that out explicitly because that is where this problem family usually breaks down.
