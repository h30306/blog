---
title: "String DP"
summary: "Prefix tables, edit operations, subsequences, and interval palindrome DP"
description: "Algorithm Learning"
date: 2026-09-13
tags: ["dynamic-programming", "string", "lcs", "palindrome"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Introduction

String DP usually falls into two families:

- prefix DP over one or two strings
- interval DP over one substring

The state definition must say whether we are matching prefixes, deleting characters, editing source into target, or repairing an interval.

## Two-Prefix DP

For LCS:

```text
dp[i][j] = LCS length between text1[:i] and text2[:j]
```

If the current characters match:

```text
dp[i][j] = dp[i - 1][j - 1] + 1
```

If they do not match:

```text
dp[i][j] = max(dp[i - 1][j], dp[i][j - 1])
```

## Edit Distance

For edit distance, the direction matters:

```text
dp[i][j] = minimum operations to convert word1[:i] into word2[:j]
```

On mismatch, the three operations are:

- delete from source
- insert target character
- replace source character

## Delete-Only DP

For delete-only problems, replacement and insertion are not legal. On mismatch, choose which side to delete:

```text
1 + min(delete from word1, delete from word2)
```

Weighted delete problems use character cost instead of unit cost.

## Interval Palindrome DP

For palindrome subsequence or insertion problems:

```text
dp[left][right] = answer for s[left:right+1]
```

Fill shorter intervals first. If the ends match, use the inner interval. If they do not, drop or repair one side depending on the problem.

## Common Mistakes

- Mixing substring and subsequence.
- Forgetting that `dp[i][j]` uses prefix lengths, while characters use `i - 1` and `j - 1`.
- Mixing insert/delete direction in edit distance.
- Adding a replace branch to delete-only problems.
- Filling interval DP in the wrong order.

## Related LeetCode

- `LC 72` Edit Distance
- `LC 97` Interleaving String
- `LC 115` Distinct Subsequences
- `LC 139` Word Break
- `LC 516` Longest Palindromic Subsequence
- `LC 583` Delete Operation for Two Strings
- `LC 712` Minimum ASCII Delete Sum for Two Strings
- `LC 1092` Shortest Common Supersequence
- `LC 1143` Longest Common Subsequence
- `LC 1312` Minimum Insertion Steps to Make a String Palindrome
