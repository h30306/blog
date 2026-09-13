---
title: "LeetCode 1449: Form Largest Integer With Digits That Add Up To Target"
summary: "LeetCode 解題筆記：Form Largest Integer With Digits That Add Up To Target"
description: "2026-08-19 的 LeetCode 學習紀錄"
date: 2026-08-19
tags: ["leetcode", "hard", "dynamic-programming", "knapsack"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-08-19
來源筆記：`notes/day46-week8-day4-profitable-schemes-form-largest-integer-redis-vs-query-fix.md`

## 解題思路

這篇整理 Form Largest Integer With Digits That Add Up To Target 的解題筆記，重點放在 unbounded knapsack optimization plus greedy reconstruction、狀態定義、轉移式與容易犯錯的地方。

## 解法

以下內容整理自當天的 learning note，保留英文關鍵句，方便之後直接拿來做面試口說複習。

- **Pattern:** unbounded knapsack optimization plus greedy reconstruction.

## Why This Fits
Each digit `1..9` has:
- a cost
- unlimited reuse

The objective is not just:
```text
can I hit target?
```

It is:
```text
form the numerically largest integer whose total cost is target
```

That means:
1. maximize digit count first
2. among equal-length answers, reconstruct the lexicographically largest digit sequence

## Core State / Invariant
```text
dp[t] = maximum number of digits we can build with total cost t
```

Use a very negative sentinel for unreachable states.

## Base Case
```text
dp[0] = 0
```

Reason:
```text
cost 0 can form a number with 0 digits
```

## Transition
For a digit with cost `c`:
```text
dp[t] = max(dp[t], dp[t - c] + 1)
```

Iterate target cost forward because digit reuse is allowed.

## Reconstruction
After DP, rebuild from digit `9` down to `1`.

Greedy rule:
```text
take digit d if its cost fits and dp[remaining] == dp[remaining - cost[d]] + 1
```

This preserves max length while making the leftmost digits as large as possible.

## Complexity
```text
Time: O(9 * target)
Space: O(target)
```

## Common Mistakes
- solving only feasibility and forgetting reconstruction
- optimizing digit value directly instead of digit count first
- using backward loop and accidentally turning it into `0/1`
- not handling unreachable target cleanly

## Strong Spoken Explanation
This is an unbounded knapsack on digit cost. I first use DP to maximize how many digits can be formed for each total cost, because any number with more digits is always numerically larger than a shorter valid number. So `dp[t]` stores the maximum digit count for cost `t`, with `dp[0] = 0` and unreachable states set to negative infinity. Since digits can be reused, the transition is unbounded: `dp[t] = max(dp[t], dp[t - cost] + 1)`. After I know the maximum digit count for the target, I reconstruct greedily from digit `9` down to `1`, taking a digit whenever it preserves the optimal count. That gives the lexicographically largest number among all max-length answers.

## 收穫

- 先講清楚 state meaning，再寫 recurrence。
- base case、迴圈方向、return value 要在 coding 前確認。
- 如果是 DP 壓縮、graph traversal、或 greedy frontier，要能說出 invariant 為什麼成立。

## 遇到的問題

原始筆記沒有另外紀錄失誤點。
