---
title: "LeetCode 322: Coin Change"
summary: "LeetCode 解題筆記：Coin Change"
description: "2026-04-25 的 LeetCode 學習紀錄"
date: 2026-04-25
tags: ["medium", "dynamic-programming", "unbounded-knapsack"]
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
來源筆記：`notes/day10-week3-day2-dp-repair-tls-handshake.md`

## 解題思路

這篇整理 Coin Change 的解題筆記，重點放在 Unbounded minimum-count DP、狀態定義、轉移式與容易犯錯的地方。

## 解法

以下內容整理自當天的 learning note，保留英文關鍵句，方便之後直接拿來做面試口說複習。

- **Pattern:** Unbounded minimum-count DP.
- **Main lesson:** Correct DP setup was mostly fine; the bug was control flow and greedy intuition.

## State
```text
dp[i] = minimum number of coins needed to make amount i
```

## Base Case
```text
dp[0] = 0
```

## Transition
```text
dp[i] = min(dp[i], dp[i - coin] + 1)
```

for each reachable `i - coin`.

## Initialization
```text
dp[i] = infinity for unreachable amounts
```

## Important Repairs
- Do not early return just because `dp[amount]` becomes finite once.
- Do not assume reverse-sorting coins makes the first reachable answer optimal.
- Do not size the DP array with `len(coins) + 1`; it must be `amount + 1`.

## Interview-Ready Explanation
This is a minimum-count DP problem. I define `dp[i]` as the minimum number of coins needed to make amount `i`. The base case is `dp[0] = 0`. For each coin, I update `dp[i]` from `dp[i - coin] + 1` if the smaller amount is reachable. After filling the table, if `dp[amount]` is still infinity, the answer is `-1`.

## Complexity
```text
Time: O(amount * len(coins))
Space: O(amount)
```

## Must-Know Distinction
```text
Coin Change minimum count -> dp[0] = 0
Coin Change 2 counting ways -> dp[0] = 1
```

## 收穫

- 先講清楚 state meaning，再寫 recurrence。
- base case、迴圈方向、return value 要在 coding 前確認。
- 如果是 DP 壓縮、graph traversal、或 greedy frontier，要能說出 invariant 為什麼成立。

## 遇到的問題

Repaired.
