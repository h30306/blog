---
title: "LeetCode 115: Distinct Subsequences"
summary: "LeetCode note for Distinct Subsequences, rebuilt from the original learning note"
description: "Cleaned LeetCode 115 article from 2026-07-19 with note repair points and final solution"
date: 2026-07-19
tags: ["hard", "dynamic-programming", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-07-19
Source: Day 38 learning note

## Study Context

This article is rebuilt from the exact LeetCode section in the learning note. I kept the note's repair points, comparison points, and common mistakes, while removing unrelated non-LeetCode material from the same day.

## Related Reminders From The Note

- `LC 115`: pass after repair
- explain `LC 115` with the exact counting state and the `dp[i][0] = 1` base case
- `LC 115` vs `LC 1143`

## Learning Note Extract

#### Problem 1 - LC 115 Distinct Subsequences
- **Pattern:** 2D DP on two prefixes with counting.

#### Why This Fits
The real question is:
```text
how many ways can s[:i] form t[:j] by deleting characters from s?
```

That gives a counting table over:
- source prefix of `s`
- target prefix of `t`

#### Core State / Invariant
```text
dp[i][j] = number of distinct subsequences of s[:i] that equal t[:j]
```

#### Base Cases
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

#### Transition
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

#### Why This Works
At each source character, there are only two meaningful decisions:
- do not use it
- use it if and only if it matches the needed target character

The DP counts all valid choices without double counting because the two branches differ on whether the current source character is consumed.

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
- forgetting that `dp[i][0] = 1`, not `0`
- using `dp[i][j - 1]` on mismatch
- saying `at least one way` instead of exact count
- mixing substring reasoning into a subsequence problem
- losing track of which string is the source and which is the target

#### Strong Spoken Explanation
I define `dp[i][j]` as the number of ways the source prefix `s[:i]` can form the target prefix `t[:j]` as a subsequence. The empty target has exactly one formation from any source prefix, so `dp[i][0] = 1`. A non-empty target cannot be formed from an empty source, so `dp[0][j] = 0` for `j > 0`. If the current characters match, I either skip the current source character or use it to match the current target character, so I add `dp[i - 1][j]` and `dp[i - 1][j - 1]`. If they do not match, I can only skip the current source character, so I carry `dp[i - 1][j]`. The answer is `dp[len(s)][len(t)]`.

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

```python
class Solution:
    def numDistinct(self, s: str, t: str) -> int:
        n = len(t)
        dp = [0] * (n + 1)
        dp[0] = 1

        for c in s:
            for j in range(n, 0, -1):
                if c == t[j - 1]:
                    dp[j] += dp[j - 1]

        return dp[n]
```

## Complexity

Time O(len(s)*len(t)), Space O(len(t)).

## Mistakes To Watch

- Iterating j forward and reusing the same source character twice.
- Forgetting dp[0] = 1 for the empty target.

## Final Interview Explanation

Start from the state definition, then explain why the transition preserves that state. If there is a loop direction, state compression, or a similar-looking problem with a different answer shape, call that out explicitly because that is where this problem family usually breaks down.
