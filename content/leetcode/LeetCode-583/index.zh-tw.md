---
title: "LeetCode 583: Delete Operation for Two Strings"
summary: "LeetCode 解題筆記：Delete Operation for Two Strings"
description: "2026-07-19 的 LeetCode 學習紀錄"
date: 2026-07-19
tags: ["leetcode", "medium", "dynamic-programming", "string"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-07-19
來源筆記：`notes/day38-week7-day3-distinct-subsequences-delete-operation-mvcc-locking.md`

## 解題思路

這篇整理 Delete Operation for Two Strings 的解題筆記，重點放在 2D DP on two prefixes with delete-only cost、狀態定義、轉移式與容易犯錯的地方。

## 解法

以下內容整理自當天的 learning note，保留英文關鍵句，方便之後直接拿來做面試口說複習。

- **Pattern:** 2D DP on two prefixes with delete-only cost.

## Why This Fits
The real question is:
```text
what is the minimum number of deletions needed to make word1[:i] and word2[:j] equal?
```

That is still a two-prefix table, but now the table stores:
- minimum cost
- not boolean validity
- not count of ways

## Core State / Invariant
```text
dp[i][j] = minimum deletions needed to make word1[:i] and word2[:j] equal
```

## Base Cases
If `word2` is empty:
```text
dp[i][0] = i
```

Reason:
```text
delete all i characters from word1
```

If `word1` is empty:
```text
dp[0][j] = j
```

Reason:
```text
delete all j characters from word2
```

## Transition
If the current characters already match:
```text
word1[i - 1] == word2[j - 1]
=> dp[i][j] = dp[i - 1][j - 1]
```

If they do not match:
```text
dp[i][j] = 1 + min(
    dp[i - 1][j],  # delete word1[i - 1]
    dp[i][j - 1]   # delete word2[j - 1]
)
```

## Why This Works
On mismatch, replacement is not allowed.

So one deletion must happen first:
- either delete from `word1`
- or delete from `word2`

Then solve the smaller subproblem.

## Alternative View Through LCS
This problem can also be defended as:
```text
answer = len(word1) + len(word2) - 2 * LCS(word1, word2)
```

Reason:
```text
the longest common subsequence is the part both strings keep;
everything else must be deleted
```

Interview-safe rule:
- direct DP is usually easier if you want one self-contained recurrence
- LCS reduction is good if the interviewer asks for relation between patterns

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
- accidentally adding a replace branch from `LC 72`
- forgetting the answer is deletions across both strings, not one string only
- saying mismatch is `min(diagonal, up, left)` because edit distance is in your head
- using LCS reduction without being able to justify it
- drifting into substring instead of subsequence / deletion reasoning

## Strong Spoken Explanation
I define `dp[i][j]` as the minimum deletions needed to make `word1[:i]` and `word2[:j]` equal. If one prefix is empty, I must delete every character from the other prefix, so the first row and first column are just their lengths. If the current characters match, I keep them both and take the diagonal. If they do not match, replacement is not allowed, so one deletion must happen first: either delete the current character from `word1` or delete the current character from `word2`, then take the cheaper result and add one. The answer is `dp[m][n]`.

## 收穫

- 先講清楚 state meaning，再寫 recurrence。
- base case、迴圈方向、return value 要在 coding 前確認。
- 如果是 DP 壓縮、graph traversal、或 greedy frontier，要能說出 invariant 為什麼成立。

## 遇到的問題

原始筆記沒有另外紀錄失誤點。
