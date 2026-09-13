---
title: "String DP"
summary: "Prefix table、edit operations、subsequence 與 interval palindrome DP"
description: "演算法學習"
date: 2026-09-13
tags: ["dynamic-programming", "string", "lcs", "palindrome"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 介紹

String DP 通常分成兩大家族：

- 一個或兩個字串上的 prefix DP
- 單一字串區間上的 interval DP

state definition 必須講清楚：是在比對 prefixes、刪字元、把 source edit 成 target，還是在修一個 interval。

## Two-Prefix DP

LCS 的 state 是：

```text
dp[i][j] = text1[:i] 和 text2[:j] 的 LCS 長度
```

如果目前字元相同：

```text
dp[i][j] = dp[i - 1][j - 1] + 1
```

如果不同：

```text
dp[i][j] = max(dp[i - 1][j], dp[i][j - 1])
```

## Edit Distance

Edit distance 一定要講清楚方向：

```text
dp[i][j] = 把 word1[:i] 轉成 word2[:j] 的最少操作數
```

mismatch 時三個操作是：

- 從 source delete
- insert target character
- replace source character

## Delete-Only DP

Delete-only 題目不能 replace，也不能 insert。mismatch 時只能選刪哪一邊：

```text
1 + min(delete from word1, delete from word2)
```

如果是 weighted delete，成本不是 `1`，而是 character value。

## Interval Palindrome DP

Palindrome subsequence 或 insertion 題目的 state 是：

```text
dp[left][right] = s[left:right+1] 這段 interval 的答案
```

要先填短 interval。兩端相同時看 inner interval；兩端不同時，根據題目選擇 drop 或 repair 某一邊。

## 常見錯誤

- 混淆 substring 和 subsequence。
- 忘記 `dp[i][j]` 是 prefix length，但字元 index 是 `i - 1` 和 `j - 1`。
- Edit distance 混淆 insert/delete 的 source-to-target 方向。
- Delete-only 題目誤加 replace branch。
- Interval DP fill order 錯。

## 相關 LeetCode

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
