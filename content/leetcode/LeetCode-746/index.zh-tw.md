---
title: "LeetCode 746: Min Cost Climbing Stairs"
summary: "LeetCode 解題筆記：Min Cost Climbing Stairs"
description: "2026-04-25 的 LeetCode 學習紀錄"
date: 2026-04-25
tags: ["easy", "dynamic-programming"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2026-04-25
來源筆記：`notes/day10-week3-day2-dp-repair-tls-handshake.md`

## 解題思路

這篇整理 Min Cost Climbing Stairs 的解題筆記，重點放在 Fibonacci-style minimum-cost DP、狀態定義、轉移式與容易犯錯的地方。

## 解法

以下內容整理自當天的 learning note，保留英文關鍵句，方便之後直接拿來做面試口說複習。

- **Pattern:** Fibonacci-style minimum-cost DP.

## State
```text
dp[i] = minimum cost to reach step i
```

## Base Case
```text
dp[0] = cost[0]
dp[1] = cost[1]
```

## Transition
```text
dp[i] = cost[i] + min(dp[i - 1], dp[i - 2])
```

## Final Answer
The top is one step beyond the last index, so:
```text
answer = min(dp[n - 1], dp[n - 2])
```

## Complexity
```text
Time: O(n)
Space: O(n)
```

## Interview-Ready Explanation
I can start from step 0 or step 1. To reach step `i`, I must come from `i - 1` or `i - 2`, so the minimum cost to reach `i` is the current step cost plus the cheaper of those two previous states. Since the top is beyond the last step, the answer is the cheaper of reaching the last or second-last step.

## 收穫

- 先講清楚 state meaning，再寫 recurrence。
- base case、迴圈方向、return value 要在 coding 前確認。
- 如果是 DP 壓縮、graph traversal、或 greedy frontier，要能說出 invariant 為什麼成立。

## 遇到的問題

Good enough.
