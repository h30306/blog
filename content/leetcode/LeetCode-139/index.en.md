---
title: "LeetCode 139: Word Break"
summary: "LeetCode Problem Solving - Prefix DP / segmentation DP"
description: "LeetCode study note from 2026-04-28"
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
Source Note: `notes/day15-week4-day1-word-break-rest-basics.md`

## Intuition

I define dp[i] as whether the prefix s[:i] can be segmented. The empty prefix is true. For each position, I try each dictionary word. If the prefix before that word is already segmentable and the current suffix equals th

Pattern: Prefix DP / segmentation DP

## Approach

- **Pattern:** Prefix DP / segmentation DP.

## Why DP Fits
Whether a prefix can be segmented depends on whether a smaller prefix was already segmentable and whether the current suffix matches a dictionary word.

## State
```text
dp[i] = whether s[:i] can be segmented using wordDict
```

## Base Case
```text
dp[0] = True
```

Meaning:
```text
the empty prefix is segmentable
```

## Transition
For each index `i` and each word:
```text
if i >= len(word) and dp[i - len(word)] and s[i - len(word):i] == word:
    dp[i] = True
```

## Complexity
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

## Main Implementation Repairs
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

## Interview-Ready Explanation
I define `dp[i]` as whether the prefix `s[:i]` can be segmented. The empty prefix is true. For each position, I try each dictionary word. If the prefix before that word is already segmentable and the current suffix equals the word, then the current prefix is segmentable too.

## Findings

- Keep the state meaning explicit before writing the transition.
- Check base cases and return value before trusting the recurrence.
- Explain why the iteration order or traversal order preserves the intended invariant.

## Encountered Problems

Good enough after implementation repair.
