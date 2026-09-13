---
title: "LeetCode 416: Partition Equal Subset Sum"
summary: "LeetCode 解題筆記：Partition Equal Subset Sum"
description: "2026-08-23 的 LeetCode 學習紀錄"
date: 2026-08-23
tags: ["leetcode", "medium", "dynamic-programming", "knapsack", "subset-sum"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-08-23
來源筆記：`notes/day43-week8-day1-partition-coin-change-replication-lag.md`

## 解題思路

這篇整理 Partition Equal Subset Sum 的解題筆記，重點放在 `0/1` knapsack / subset-sum reachability、狀態定義、轉移式與容易犯錯的地方。

## 解法

以下內容整理自當天的 learning note，保留英文關鍵句，方便之後直接拿來做面試口說複習。

- **Pattern:** `0/1` knapsack / subset-sum reachability

## Why This Fits
Each number can be used:
```text
either once or not at all
```

The question becomes:
```text
can I reach total / 2?
```

That is classic `0/1` subset selection.

## Core State / Invariant
2D form:
```text
dp[i][s] = whether some subset from the first i numbers can make sum s
```

Compressed form:
```text
dp[s] = whether the numbers processed so far can make sum s
```

## Base Case
```text
dp[0] = true
```

Reason:
```text
choosing nothing always makes sum 0
```

## Transition
For each `num`:
```text
dp[s] = dp[s] or dp[s - num]
```

when:
```text
s >= num
```

## Why Loop Direction Matters
In 1D compression, iterate `s` backward:
```text
for s from target down to num
```

Reason:
```text
backward iteration prevents the current number from being reused in the same round
```

## Complexity
```text
Time: O(n * target)
Space: O(target)
```

## Common Mistakes
- forgetting the odd-total early exit
- iterating `s` forward and accidentally reusing one number in the same round
- saying `dp[s]` is a best value instead of a reachable-state boolean
- failing to explain why `dp[0] = true`

## Strong Spoken Explanation
I first reduce the problem to whether some subset reaches `total / 2`, because equal partition means both sides must sum the same. Then I use `0/1` subset-sum DP where `dp[s]` means whether the processed numbers can make sum `s`. The base case is `dp[0] = true`, since choosing nothing makes sum zero. For each number I update the target sum backward so the current number is used at most once. If `dp[target]` is true at the end, an equal partition exists.

## 收穫

- 先講清楚 state meaning，再寫 recurrence。
- base case、迴圈方向、return value 要在 coding 前確認。
- 如果是 DP 壓縮、graph traversal、或 greedy frontier，要能說出 invariant 為什麼成立。

## 遇到的問題

原始筆記沒有另外紀錄失誤點。
