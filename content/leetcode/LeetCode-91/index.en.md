---
title: "LeetCode 91: Decode Ways"
summary: "LeetCode note for Decode Ways, rebuilt from the original learning note"
description: "Cleaned LeetCode 91 article from 2026-04-28 with note repair points and final solution"
date: 2026-04-28
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
First Attempt: 2026-04-28
Source: Day 15 learning note

## Study Context

This article is rebuilt from the exact LeetCode section in the learning note. I kept the note's repair points, comparison points, and common mistakes, while removing unrelated non-LeetCode material from the same day.

## Learning Note Extract

#### Problem 2 - LC 91 Decode Ways
- **Status:** Good enough after index repair.
- **Pattern:** Counting DP on prefixes.

#### Why DP Fits
The number of ways to decode a prefix depends on whether the last one-digit or two-digit chunk is valid, so the total count can be built from smaller prefixes.

#### State
```text
dp[i] = number of ways to decode s[:i]
```

#### Base Case
```text
dp[0] = 1
```

Meaning:
```text
there is one base way to decode the empty prefix for counting DP
```

Also:
```text
if s[0] == "0", return 0
```

#### Transition
```text
dp[i] = 0
if s[i - 1] is valid:
    dp[i] += dp[i - 1]
if s[i - 2:i] is valid:
    dp[i] += dp[i - 2]
```

Valid one-digit chunk:
```text
"1" to "9"
```

Valid two-digit chunk:
```text
"10" to "26"
```

#### Complexity
```text
Time: O(n)
Space: O(n)
```

#### Main Repair Today
The repeated slip was:
```text
mixing dp indexing with string indexing
```

Must remember:
- `dp[i]` corresponds to `s[:i]`
- one-digit check uses `s[i - 1]`
- two-digit check uses `s[i - 2:i]`

#### Interview-Ready Explanation
I define `dp[i]` as the number of ways to decode the prefix `s[:i]`. At each position, I check whether the last one-digit chunk is valid and add `dp[i-1]`, and whether the last two-digit chunk is valid and add `dp[i-2]`. This is a counting DP problem, so `dp[0] = 1` is the correct base for the empty prefix.

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

```python
class Solution:
    def numDecodings(self, s: str) -> int:
        if not s or s[0] == '0':
            return 0
        prev2, prev1 = 1, 1

        for i in range(1, len(s)):
            curr = 0
            if s[i] != '0':
                curr += prev1
            two = int(s[i - 1:i + 1])
            if 10 <= two <= 26:
                curr += prev2
            prev2, prev1 = prev1, curr

        return prev1
```

## Complexity

Time O(n), Space O(1).

## Mistakes To Watch

- Treating 0 as a valid standalone digit.
- Missing 10 and 20 as valid two-digit codes.

## Final Interview Explanation

Start from the state definition, then explain why the transition preserves that state. If there is a loop direction, state compression, or a similar-looking problem with a different answer shape, call that out explicitly because that is where this problem family usually breaks down.
