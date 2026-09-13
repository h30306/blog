---
title: "LeetCode 516: Longest Palindromic Subsequence"
summary: "LeetCode note for Longest Palindromic Subsequence, rebuilt from the original learning note"
description: "Cleaned LeetCode 516 article from 2026-07-11 with note repair points and final solution"
date: 2026-07-11
tags: ["medium", "dynamic-programming", "string", "palindrome"]
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

- `LC 516` tests whether you can switch from prefix-style DP to interval-style DP cleanly.
- `LC 516`: partial pass after teaching repair
- explain `LC 516` with exact interval-based state and fill order

## Learning Note Extract

#### Problem 2 - LC 516 Longest Palindromic Subsequence
- **Pattern:** interval DP on substrings.

#### Why This Fits
This is not a two-string prefix table.

The right question is:
```text
what is the longest palindromic subsequence inside s[left:right+1]?
```

That naturally gives an interval DP.

#### Core State / Invariant
```text
dp[left][right] = length of the longest palindromic subsequence inside s[left:right+1]
```

#### Base Cases
Single character:
```text
dp[i][i] = 1
```

Reason:
```text
one character is already a palindrome of length 1
```

#### Transition
If the two ends match:
```text
s[left] == s[right]
=> dp[left][right] = dp[left + 1][right - 1] + 2
```

If they do not match:
```text
dp[left][right] = max(dp[left + 1][right], dp[left][right - 1])
```

#### Fill Order
The interval depends on smaller inner intervals, so fill by:
- increasing substring length
or
- `left` decreasing, `right` increasing

#### Complexity
```text
Time: O(n^2)
Space: O(n^2)
```

#### Common Mistakes
- confusing subsequence with substring
- filling the table in the wrong order
- forgetting `dp[i][i] = 1`
- assuming matching ends always means the whole interval is a palindrome substring

#### Strong Spoken Explanation
I define `dp[left][right]` as the length of the longest palindromic subsequence inside that substring interval. A single character is length `1`, so `dp[i][i] = 1`. If the two ends match, I can wrap the best inner answer with those two characters and add `2`. If they do not match, one of the ends is not used in the optimal subsequence, so I take the better answer from dropping the left side or dropping the right side. The key implementation detail is fill order, because each state depends on smaller inner intervals.

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

```python
class Solution:
    def longestPalindromeSubseq(self, s: str) -> int:
        n = len(s)
        dp = [[0] * n for _ in range(n)]

        for l in range(n - 1, -1, -1):
            dp[l][l] = 1
            for r in range(l + 1, n):
                if s[l] == s[r]:
                    dp[l][r] = 2 + dp[l + 1][r - 1]
                else:
                    dp[l][r] = max(dp[l + 1][r], dp[l][r - 1])

        return dp[0][n - 1] if n else 0
```

## Complexity

Time O(n^2), Space O(n^2).

## Mistakes To Watch

- Using substring logic instead of subsequence logic.
- Filling intervals in the wrong order.

## Final Interview Explanation

Start from the state definition, then explain why the transition preserves that state. If there is a loop direction, state compression, or a similar-looking problem with a different answer shape, call that out explicitly because that is where this problem family usually breaks down.
