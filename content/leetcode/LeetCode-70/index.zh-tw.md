---
title: "LeetCode 70: Climbing Stairs"
summary: "LeetCode 解題筆記：Climbing Stairs"
description: "2026-04-20 的 LeetCode 學習紀錄"
date: 2026-04-20
tags: ["leetcode", "easy", "dynamic-programming"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2026-04-20
來源筆記：`notes/day9-week3-dp-intro-tls-load-balancing.md`

## 解題思路

這篇整理 Climbing Stairs 的解題筆記，重點放在 Fibonacci-style 1D DP、狀態定義、轉移式與容易犯錯的地方。

## 解法

以下內容整理自當天的 learning note，保留英文關鍵句，方便之後直接拿來做面試口說複習。

- **Pattern:** Fibonacci-style 1D DP.

## State
```text
dp[i] = number of distinct ways to reach step i
```

## Base Case
```text
dp[0] = 1
dp[1] = 1
```

`dp[0] = 1` means there is one way to start before taking any steps: do nothing.

## Transition
```text
dp[i] = dp[i - 1] + dp[i - 2]
```

To reach step `i`, the last move must come from step `i - 1` with one step or from step `i - 2` with two steps.

## Complexity
```text
Time: O(n)
Space: O(n) with array, O(1) with two variables
```

## 收穫

- 先講清楚 state meaning，再寫 recurrence。
- base case、迴圈方向、return value 要在 coding 前確認。
- 如果是 DP 壓縮、graph traversal、或 greedy frontier，要能說出 invariant 為什麼成立。

## 遇到的問題

Completed.
