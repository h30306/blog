---
title: "LeetCode 1143: Longest Common Subsequence"
summary: "LeetCode 解題筆記：Longest Common Subsequence"
description: "2026-07-11 的 LeetCode 學習紀錄"
date: 2026-07-11
tags: ["leetcode", "medium", "dynamic-programming", "string"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-07-11
來源筆記：`notes/day36-week7-day1-lcs-lps-acid-concrete-examples.md`

## 解題思路

這篇整理 Longest Common Subsequence 的解題筆記，重點放在 2D DP on two prefixes、狀態定義、轉移式與容易犯錯的地方。

## 解法

以下內容整理自當天的 learning note，保留英文關鍵句，方便之後直接拿來做面試口說複習。

- **Pattern:** 2D DP on two prefixes.

## Why This Fits
At any pair of positions, the question is:
```text
what is the LCS length for the prefixes up to these two positions?
```

That naturally gives a 2D table over:
- prefix of `text1`
- prefix of `text2`

## Core State / Invariant
```text
dp[i][j] = length of the longest common subsequence between text1[:i] and text2[:j]
```

## Base Case
If either prefix is empty:
```text
dp[i][0] = 0
dp[0][j] = 0
```

Reason:
```text
an empty string has no common subsequence with positive length
```

## Transition
If the new characters match:
```text
text1[i - 1] == text2[j - 1]
=> dp[i][j] = dp[i - 1][j - 1] + 1
```

If they do not match:
```text
dp[i][j] = max(dp[i - 1][j], dp[i][j - 1])
```

## Why This Works
- match:
  - the matching characters can extend the best subsequence from the smaller prefixes
- mismatch:
  - one of the two last characters is not used, so drop one side and keep the better answer

## Complexity
```text
Time: O(m * n)
Space: O(m * n)
```

Can be compressed to:
```text
Space: O(n)
```

## Common Mistakes
- using substring instead of subsequence reasoning
- mixing character index with prefix length index
- forgetting that mismatch takes `max(up, left)`
- saying diagonal is used on every step

## Strong Spoken Explanation
I define `dp[i][j]` as the LCS length between the prefixes `text1[:i]` and `text2[:j]`. The base row and base column are zero because an empty prefix cannot contribute any positive common subsequence. If the current characters match, I extend the smaller-prefix answer from the diagonal by one. If they do not match, I drop one side and keep the better result from `up` or `left`. The final answer is `dp[m][n]`.

## 收穫

- 先講清楚 state meaning，再寫 recurrence。
- base case、迴圈方向、return value 要在 coding 前確認。
- 如果是 DP 壓縮、graph traversal、或 greedy frontier，要能說出 invariant 為什麼成立。

## 遇到的問題

原始筆記沒有另外紀錄失誤點。
