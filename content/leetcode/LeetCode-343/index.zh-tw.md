---
title: "LeetCode 343: Integer Break"
summary: "LeetCode 解題筆記：Integer Break"
description: "2026-05-07 的 LeetCode 學習紀錄"
date: 2026-05-07
tags: ["medium", "dynamic-programming"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-05-07
來源筆記：`notes/day20-week4-weekend-day1-retry-safe-create-api.md`

## 解題思路

這篇整理 Integer Break 的解題筆記，重點放在 Partition DP / max-product DP、狀態定義、轉移式與容易犯錯的地方。

## 解法

以下內容整理自當天的 learning note，保留英文關鍵句，方便之後直接拿來做面試口說複習。

- **Pattern:** Partition DP / max-product DP.

## Why DP Fits
For each integer `i`, we try every split:
```text
i = j + (i - j)
```

The best product for `i` depends on smaller integers, so this has overlapping subproblems.

Important nuance:
```text
each side of the split may be kept raw or broken further
```

## State
```text
dp[i] = maximum product obtainable by breaking integer i into at least two positive integers
```

## Base Case
```text
dp[1] = 1
dp[2] = 1
```

## Transition
For each split `j` from `1` to `i - 1`:
```text
dp[i] = max(dp[i], max(j, dp[j]) * max(i - j, dp[i - j]))
```

Why `max(raw, dp)` matters:
- sometimes a side should stay as the raw number
- sometimes a side should be broken further

Counterexample to `dp[j] * dp[i-j]` only:
```text
i = 3, split = 2 + 1
correct product is 2 * 1 = 2
but dp[2] * dp[1] = 1 * 1 = 1
```

## Complexity
```text
Time: O(n^2)
Space: O(n)
```

## Common Mistakes
- forcing both sides to use `dp[...]` instead of allowing raw factors
- forgetting that the problem requires at least one break
- using `j = 0` split even though all parts must be positive

## Interview-Ready Explanation
This is partition DP. I define `dp[i]` as the maximum product obtainable by breaking integer `i` into at least two positive integers. For each `i`, I try every split `j` and `i - j`. For each side, I choose either to keep it as a raw number or break it further, so the transition is `dp[i] = max(dp[i], max(j, dp[j]) * max(i - j, dp[i - j]))`. The time complexity is `O(n^2)` and the space complexity is `O(n)`.

## 收穫

- 先講清楚 state meaning，再寫 recurrence。
- base case、迴圈方向、return value 要在 coding 前確認。
- 如果是 DP 壓縮、graph traversal、或 greedy frontier，要能說出 invariant 為什麼成立。

## 遇到的問題

Good enough.
