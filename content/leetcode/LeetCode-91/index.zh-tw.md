---
title: "LeetCode 91: Decode Ways"
summary: "LeetCode 解題筆記：Decode Ways"
description: "2026-04-28 的 LeetCode 學習紀錄"
date: 2026-04-28
tags: ["leetcode", "medium", "dynamic-programming", "string"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-04-28
來源筆記：`notes/day15-week4-day1-word-break-rest-basics.md`

## 解題思路

這篇整理 Decode Ways 的解題筆記，重點放在 Counting DP on prefixes、狀態定義、轉移式與容易犯錯的地方。

## 解法

以下內容整理自當天的 learning note，保留英文關鍵句，方便之後直接拿來做面試口說複習。

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

## 收穫

- 先講清楚 state meaning，再寫 recurrence。
- base case、迴圈方向、return value 要在 coding 前確認。
- 如果是 DP 壓縮、graph traversal、或 greedy frontier，要能說出 invariant 為什麼成立。

## 遇到的問題

Good enough after index repair.
