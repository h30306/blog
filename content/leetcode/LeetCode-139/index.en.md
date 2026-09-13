---
title: "LeetCode 139: Word Break"
summary: "LeetCode note for Word Break, rebuilt from the original learning note"
description: "Cleaned LeetCode 139 article from 2026-04-28 with note repair points and final solution"
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

#### Problem 1 - LC 139 Word Break
- **Status:** Good enough after implementation repair.
- **Pattern:** Prefix DP / segmentation DP.

#### Why DP Fits
Whether a prefix can be segmented depends on whether a smaller prefix was already segmentable and whether the current suffix matches a dictionary word.

#### State
```text
dp[i] = whether s[:i] can be segmented using wordDict
```

#### Base Case
```text
dp[0] = True
```

Meaning:
```text
the empty prefix is segmentable
```

#### Transition
For each index `i` and each word:
```text
if i >= len(word) and dp[i - len(word)] and s[i - len(word):i] == word:
    dp[i] = True
```

#### Complexity
```text
Time: O(n * m * L)
Space: O(n)
```

Where:
```text
n = len(s)
m = len(wordDict)
L = word length / substring compare cost
```

#### Main Implementation Repairs
- `dp` size must be:
```python
[False] * (len(s) + 1)
```
- loop bound must use:
```python
range(1, len(s) + 1)
```
- index must use:
```python
dp[i - len(word)]
```
not:
```python
dp[i - word]
```

#### Interview-Ready Explanation
I define `dp[i]` as whether the prefix `s[:i]` can be segmented. The empty prefix is true. For each position, I try each dictionary word. If the prefix before that word is already segmentable and the current suffix equals the word, then the current prefix is segmentable too.

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

```python
from typing import List

class Solution:
    def wordBreak(self, s: str, wordDict: List[str]) -> bool:
        words = set(wordDict)
        max_len = max(map(len, words), default=0)
        n = len(s)
        dp = [False] * (n + 1)
        dp[0] = True

        for i in range(1, n + 1):
            for length in range(1, min(max_len, i) + 1):
                if dp[i - length] and s[i - length:i] in words:
                    dp[i] = True
                    break

        return dp[n]
```

## Complexity

Time O(n * maxWordLen) substring checks, Space O(n).

## Mistakes To Watch

- Greedily matching the longest word.
- Not bounding j by the maximum word length.

## Final Interview Explanation

Start from the state definition, then explain why the transition preserves that state. If there is a loop direction, state compression, or a similar-looking problem with a different answer shape, call that out explicitly because that is where this problem family usually breaks down.
