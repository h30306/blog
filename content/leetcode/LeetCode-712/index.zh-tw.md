---
title: "LeetCode 712: Minimum ASCII Delete Sum for Two Strings"
summary: "LeetCode 解題筆記：Minimum ASCII Delete Sum for Two Strings"
description: "2026-07-21 的 LeetCode 學習紀錄"
date: 2026-07-21
tags: ["leetcode", "medium", "dynamic-programming", "string"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-07-21
來源筆記：`notes/day39-week7-day4-ascii-delete-palindrome-deadlock-write-skew-oracle.md`

## 解題思路

這篇整理 Minimum ASCII Delete Sum for Two Strings 的解題筆記，重點放在 2D DP on two prefixes with weighted delete-only cost、狀態定義、轉移式與容易犯錯的地方。

## 解法

以下內容整理自當天的 learning note，保留英文關鍵句，方便之後直接拿來做面試口說複習。

- **Pattern:** 2D DP on two prefixes with weighted delete-only cost.

## Why This Fits
The real question is:
```text
what is the minimum total ASCII delete cost needed
to make s1[:i] and s2[:j] equal?
```

That is still a two-prefix table, but now:
- mismatch cost is not always `1`
- it depends on which character is deleted

## Core State / Invariant
```text
dp[i][j] = minimum ASCII delete cost needed to make s1[:i] and s2[:j] equal
```

## Base Cases
If `s2` is empty:
```text
dp[i][0] = sum(ASCII values of s1[:i])
```

Reason:
```text
every character in s1[:i] must be deleted
```

If `s1` is empty:
```text
dp[0][j] = sum(ASCII values of s2[:j])
```

Reason:
```text
every character in s2[:j] must be deleted
```

## Transition
If the current characters already match:
```text
s1[i - 1] == s2[j - 1]
=> dp[i][j] = dp[i - 1][j - 1]
```

If they do not match:
```text
dp[i][j] = min(
    dp[i - 1][j] + ASCII(s1[i - 1]),
    dp[i][j - 1] + ASCII(s2[j - 1])
)
```

## Why This Works
On mismatch, the final equal strings cannot keep both current characters.

So one of them must be deleted first:
- delete from `s1`
- or delete from `s2`

Then solve the smaller prefix problem.

Unlike `LC 72`, there is:
- no replace
- no insert

Unlike `LC 583`, the delete cost is:
- weighted by character value
- not unit cost

## Alternative View
There is also a relation to keeping the maximum ASCII-sum common subsequence:
```text
answer = sumASCII(s1) + sumASCII(s2) - 2 * maxKeptCommonASCII
```

Interview-safe rule:
- the direct delete-cost DP is easier to derive correctly in real time
- mention the reduction only if asked for a connection to `LCS`

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
- copying `LC 583` and leaving base cases as prefix lengths instead of ASCII prefix sums
- adding a diagonal mismatch branch because edit distance is still in your head
- saying `delete the cheaper side` greedily without DP
- forgetting that match means no extra delete cost
- mixing up character value with index value

## Strong Spoken Explanation
I define `dp[i][j]` as the minimum total ASCII delete cost needed to make `s1[:i]` and `s2[:j]` equal. If one prefix is empty, the only option is to delete every character from the other prefix, so the first row and first column are prefix ASCII sums, not prefix lengths. If the current characters match, I can keep both and take the diagonal with no extra cost. If they do not match, one of the two current characters must be deleted first, so I try deleting from `s1` or deleting from `s2` and add that character's ASCII value. The answer is `dp[m][n]`.

## 收穫

- 先講清楚 state meaning，再寫 recurrence。
- base case、迴圈方向、return value 要在 coding 前確認。
- 如果是 DP 壓縮、graph traversal、或 greedy frontier，要能說出 invariant 為什麼成立。

## 遇到的問題

原始筆記沒有另外紀錄失誤點。
