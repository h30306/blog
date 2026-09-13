---
title: "LeetCode 879: Profitable Schemes"
summary: "LeetCode 解題筆記：Profitable Schemes"
description: "2026-08-19 的 LeetCode 學習紀錄"
date: 2026-08-19
tags: ["hard", "dynamic-programming", "knapsack"]
categories: ["leetcode"]
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

這篇整理 Profitable Schemes 的解題筆記，重點放在 counting `0/1` knapsack with member capacity and capped profit threshold、狀態定義、轉移式與容易犯錯的地方。

## 解法

以下內容整理自當天的 learning note，保留英文關鍵句，方便之後直接拿來做面試口說複習。

- **Pattern:** counting `0/1` knapsack with member capacity and capped profit threshold.

## Why This Fits
Each crime can be:
```text
taken once or skipped
```

It consumes:
- some members

It contributes:
- some profit

The question is not to maximize profit.

It is:
```text
how many subsets satisfy members <= n and profit >= minProfit?
```

## Core State / Invariant
For the implemented version used today:
```text
dp[p][m] = number of schemes that achieve at least profit p using at most m members
```

Profit is capped into:
```text
0..minProfit
```

## Base Case
For every member limit `m`:
```text
dp[0][m] = 1
```

Reason:
```text
the empty set already achieves profit at least 0 and fits under any member cap
```

## Transition
For a crime needing `g` members and giving profit `earn`:
```text
prevProfit = max(0, p - earn)
dp[p][m] += dp[prevProfit][m - g]
```

with modulo.

## Why Profit Is Capped
Once a scheme already achieves:
```text
profit >= minProfit
```

extra profit does not create a new validity category.

So all larger profits can be merged into:
```text
the minProfit bucket
```

## Complexity
```text
Time: O(len(group) * n * minProfit)
Space: O(n * minProfit)
```

## Common Mistakes
- mixing `exactly m members` with `at most m members`
- using a state explanation that does not match the code
- forgetting why `dp[0][m] = 1` is valid in the `at most` formulation
- not capping profit at `minProfit`

## Strong Spoken Explanation
This is a counting `0/1` knapsack. Each crime can be taken once, it consumes some members, and it contributes profit. The state I used is `dp[p][m] = number of schemes that achieve at least profit p using at most m members`. I cap the profit dimension at `minProfit` because once a scheme reaches that threshold, extra profit does not change whether it is valid. I initialize `dp[0][m] = 1` for all member limits because the empty set already satisfies profit at least `0`. Then for each crime I iterate both dimensions backward and add the previous-state count from `dp[max(0, p - earn)][m - g]`.

## 收穫

- 先講清楚 state meaning，再寫 recurrence。
- base case、迴圈方向、return value 要在 coding 前確認。
- 如果是 DP 壓縮、graph traversal、或 greedy frontier，要能說出 invariant 為什麼成立。

## 遇到的問題

原始筆記沒有另外紀錄失誤點。
