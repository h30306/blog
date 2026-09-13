---
title: "LeetCode 1312: Minimum Insertion Steps to Make a String Palindrome"
summary: "LeetCode note for Minimum Insertion Steps to Make a String Palindrome, rebuilt from the original learning note"
description: "Cleaned LeetCode 1312 article from 2026-07-21 with note repair points and final solution"
date: 2026-07-21
tags: ["hard", "dynamic-programming", "string", "palindrome"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-07-21
Source: Day 39 learning note

## Study Context

This article is rebuilt from the exact LeetCode section in the learning note. I kept the note's repair points, comparison points, and common mistakes, while removing unrelated non-LeetCode material from the same day.

## Related Reminders From The Note

- `LC 1312`: pass after repair
- explain `LC 1312` with exact interval state and why mismatch is `1 + min(...)`

## Learning Note Extract

#### Problem 2 - LC 1312 Minimum Insertion Steps to Make a String Palindrome
- **Pattern:** interval DP on substrings with minimum repair cost.

#### Why This Fits
The real question is:
```text
what is the minimum number of insertions needed
to make s[left:right+1] a palindrome?
```

That is an interval question because:
- the problem is about both ends of one substring
- each decision shrinks the interval

#### Core State / Invariant
```text
dp[left][right] = minimum insertions needed to make s[left:right+1] a palindrome
```

#### Base Cases
Single character:
```text
dp[i][i] = 0
```

Reason:
```text
a single character is already a palindrome
```

Empty interval can be treated as:
```text
0
```

#### Transition
If the ends already match:
```text
s[left] == s[right]
=> dp[left][right] = dp[left + 1][right - 1]
```

If they do not match:
```text
dp[left][right] = 1 + min(
    dp[left + 1][right],
    dp[left][right - 1]
)
```

#### Why This Works
If the ends match:
- no new insertion is needed at the boundary
- just repair the inner interval

If the ends do not match:
- one insertion is needed now
- either insert a copy of `s[left]` near the right side
- or insert a copy of `s[right]` near the left side

Then solve the remaining smaller interval.

#### Fill Order
Solve shorter intervals first, usually by:
- increasing interval length
- or moving `left` backward while `right` moves forward

#### Alternative View Through LPS
You can also say:
```text
answer = len(s) - LPS(s)
```

Reason:
```text
the longest palindromic subsequence is what you keep;
all missing mirrored characters must be inserted
```

Interview-safe rule:
- direct interval DP is the stronger Day 4 answer
- `n - LPS` is a good pattern-transfer remark if asked

#### Complexity
```text
Time: O(n^2)
Space: O(n^2)
```

#### Common Mistakes
- using substring-removal wording instead of insertion wording
- saying mismatch is `1 + dp[left + 1][right - 1]`
- forgetting that matching ends need no extra insertion
- using prefix DP when the real dependency is on an interval
- being unable to explain what the insertion is actually mirroring

#### Strong Spoken Explanation
I define `dp[left][right]` as the minimum insertions needed to make `s[left:right+1]` a palindrome. A single character needs zero insertions. If the two ends already match, I do not need a new insertion at the boundary and I just solve the inner interval. If they do not match, I must insert one mirrored character, so I choose the cheaper of repairing `s[left+1:right+1]` or `s[left:right]` and add one. I fill shorter intervals first and the final answer is `dp[0][n - 1]`.

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

```python
class Solution:
    def minInsertions(self, s: str) -> int:
        n = len(s)
        dp = [[0] * n for _ in range(n)]

        for length in range(2, n + 1):
            for l in range(n - length + 1):
                r = l + length - 1
                if s[l] == s[r]:
                    dp[l][r] = dp[l + 1][r - 1]
                else:
                    dp[l][r] = 1 + min(dp[l + 1][r], dp[l][r - 1])

        return dp[0][n - 1] if n else 0
```

## Complexity

Time O(n^2), Space O(n^2).

## Mistakes To Watch

- Confusing this with edit distance; only insertions are allowed.
- Filling intervals in the wrong order.

## Final Interview Explanation

Start from the state definition, then explain why the transition preserves that state. If there is a loop direction, state compression, or a similar-looking problem with a different answer shape, call that out explicitly because that is where this problem family usually breaks down.
