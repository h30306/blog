---
title: "LeetCode 91: Decode Ways"
summary: "LeetCode Problem Solving - Counting DP on prefixes"
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

I define dp[i] as the number of ways to decode the prefix s[:i]. At each position, I check whether the last onedigit chunk is valid and add dp[i1], and whether the last twodigit chunk is valid and add dp[i2]. This is a c

Pattern: Counting DP on prefixes

## Approach

- **Pattern:** Counting DP on prefixes.

## Why DP Fits
The number of ways to decode a prefix depends on whether the last one-digit or two-digit chunk is valid, so the total count can be built from smaller prefixes.

## State
```text
dp[i] = number of ways to decode s[:i]
```

## Base Case
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

## Transition
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

## Complexity
```text
Time: O(n)
Space: O(n)
```

## Main Repair Today
The repeated slip was:
```text
mixing dp indexing with string indexing
```

Must remember:
- `dp[i]` corresponds to `s[:i]`
- one-digit check uses `s[i - 1]`
- two-digit check uses `s[i - 2:i]`

## Interview-Ready Explanation
I define `dp[i]` as the number of ways to decode the prefix `s[:i]`. At each position, I check whether the last one-digit chunk is valid and add `dp[i-1]`, and whether the last two-digit chunk is valid and add `dp[i-2]`. This is a counting DP problem, so `dp[0] = 1` is the correct base for the empty prefix.

## Findings

- Keep the state meaning explicit before writing the transition.
- Check base cases and return value before trusting the recurrence.
- Explain why the iteration order or traversal order preserves the intended invariant.

## Encountered Problems

Good enough after index repair.
