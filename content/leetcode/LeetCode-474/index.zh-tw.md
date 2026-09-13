---
title: "LeetCode 474: Ones and Zeroes"
summary: "LeetCode 解題筆記：Ones and Zeroes"
description: "2026-08-19 的 LeetCode 學習紀錄"
date: 2026-08-19
tags: ["leetcode", "medium", "dynamic-programming", "knapsack"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-08-19
來源筆記：`notes/day45-week8-day3-ones-and-zeroes-last-stone-redis-cache-aside.md`

## 解題思路

這篇整理 Ones and Zeroes 的解題筆記，重點放在 two-capacity `0/1` knapsack maximization、狀態定義、轉移式與容易犯錯的地方。

## 解法

以下內容整理自當天的 learning note，保留英文關鍵句，方便之後直接拿來做面試口說複習。

- **Pattern:** two-capacity `0/1` knapsack maximization.

## Why This Fits
Each string can be picked:
```text
at most once
```

Each picked string consumes:
- some zeros
- some ones

The value of picking it is:
```text
+1 string in the subset
```

## Core State / Invariant
```text
dp[i][j] = maximum number of strings we can pick from the strings processed so far
using at most i zeros and j ones
```

## Base Case
Initialize the whole table to:
```text
0
```

Reason:
```text
before processing any strings, the best answer is 0
```

## Transition
For a string with `zeros` and `ones`:
```text
dp[i][j] = max(dp[i][j], dp[i - zeros][j - ones] + 1)
```

## Why Both Loops Go Backward
The transition reads:
```text
dp[i - zeros][j - ones]
```

That source state must still belong to:
```text
previous strings only
```

If either capacity loop goes forward, the same string can be reused again in the same iteration.

## Complexity
```text
Time: O(len(strs) * m * n)
Space: O(m * n)
```

## Common Mistakes
- forgetting this is two-capacity, not one-capacity
- saying the value is zeros or ones instead of number of strings chosen
- going forward in one dimension and backward in the other
- omitting `processed so far` from the invariant

## Strong Spoken Explanation
This is a two-capacity `0/1` knapsack. Each string is an item, its cost is `(zeroCount, oneCount)`, and its value is `1` because taking that string increases the answer by one. I use `dp[i][j]` to mean the maximum number of strings I can pick from the strings processed so far using at most `i` zeros and `j` ones. For each string, I count its zeros and ones, then iterate both capacities backward and update `dp[i][j] = max(dp[i][j], dp[i - zeros][j - ones] + 1)`. Both loops must go backward so the current string is only used once.

## 收穫

- 先講清楚 state meaning，再寫 recurrence。
- base case、迴圈方向、return value 要在 coding 前確認。
- 如果是 DP 壓縮、graph traversal、或 greedy frontier，要能說出 invariant 為什麼成立。

## 遇到的問題

原始筆記沒有另外紀錄失誤點。
