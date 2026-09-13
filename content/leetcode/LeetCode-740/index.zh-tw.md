---
title: "LeetCode 740: Delete and Earn"
summary: "LeetCode 解題筆記：Delete and Earn"
description: "2026-04-25 的 LeetCode 學習紀錄"
date: 2026-04-25
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
第一次嘗試：2026-04-25
來源筆記：`notes/day11-week3-day3-delete-and-earn-cert-validation.md`

## 解題思路

這篇整理 Delete and Earn 的解題筆記，重點放在 Value bucketing -> House Robber、狀態定義、轉移式與容易犯錯的地方。

## 解法

以下內容整理自當天的 learning note，保留英文關鍵句，方便之後直接拿來做面試口說複習。

- **Pattern:** Value bucketing -> House Robber.
- **Key insight:** The conflict is between values `x`, `x - 1`, and `x + 1`, not between original array positions.

## Why House Robber
If I take value `x`, I cannot take `x - 1` or `x + 1`.

That is the same shape as:
```text
take current bucket -> skip adjacent bucket
skip current bucket -> keep previous answer
```

So first convert:
```text
points[x] = x * frequency(x)
```

Then solve House Robber on the `points` array.

## State
```text
dp[i] = maximum points we can earn using values from 0 to i
```

## Base Case
```text
dp[0] = 0
dp[1] = points[1]
```

## Transition
```text
dp[i] = max(dp[i - 1], dp[i - 2] + points[i])
```

## Complexity
```text
Time: O(n + m)
Space: O(m)
```

Where:
```text
n = len(nums)
m = max(nums)
```

## Interview-Ready Explanation
I group equal values first, because taking a value deletes only its neighboring values, not neighboring positions in the original array. I build `points[x]` as the total points from taking all `x`s. After that, the problem becomes House Robber on values: if I take `x`, I cannot take `x - 1`, so the transition is `max(skip current, take current)`.

## 收穫

- 先講清楚 state meaning，再寫 recurrence。
- base case、迴圈方向、return value 要在 coding 前確認。
- 如果是 DP 壓縮、graph traversal、或 greedy frontier，要能說出 invariant 為什麼成立。

## 遇到的問題

Completed.
