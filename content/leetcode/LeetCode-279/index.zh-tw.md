---
title: "LeetCode 279: Perfect Squares"
summary: "LeetCode 解題筆記：Perfect Squares"
description: "2026-05-03 的 LeetCode 學習紀錄"
date: 2026-05-03
tags: ["leetcode", "medium", "dynamic-programming"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-05-03
來源筆記：`notes/day18-week4-day4-request-path.md`

## 解題思路

這篇整理 Perfect Squares 的解題筆記，重點放在 Unbounded min-count DP、狀態定義、轉移式與容易犯錯的地方。

## 解法

以下內容整理自當天的 learning note，保留英文關鍵句，方便之後直接拿來做面試口說複習。

- **Pattern:** Unbounded min-count DP.

## Why DP Fits
For each target sum `i`, we can choose any perfect square `sq <= i` as the last piece.

That means:
```text
answer for i depends on best answer for i - sq
```

It is unbounded because the same perfect square can be reused multiple times, such as:
```text
12 = 4 + 4 + 4
```

## State
```text
dp[i] = minimum number of perfect squares needed to sum to i
```

## Base Case
```text
dp[0] = 0
```

Reason:
```text
zero needs zero numbers
```

Initialize all other states as:
```text
dp[i] = +infinity
```

## Transition
For each total `i` from `1` to `n`, try every perfect square `sq <= i`:
```text
dp[i] = min(dp[i], dp[i - sq] + 1)
```

## Complexity
```text
Time: O(n * sqrt(n))
Space: O(n)
```

## Common Mistakes
- treating it like a counting problem instead of a min-count problem
- writing `dp[0] = 1` instead of `0`
- saying the inner loop is over all integers instead of only perfect squares
- assuming greedy always works

## Greedy Counterexample
For:
```text
n = 12
```

greedy picks:
```text
9 + 1 + 1 + 1
```

which uses `4` numbers, but optimal is:
```text
4 + 4 + 4
```

which uses `3`.

## Interview-Ready Explanation
This is a min-count unbounded DP problem. For each target sum `i`, I try every perfect square `sq <= i` as the last piece and combine it with the best answer for `i - sq`. I define `dp[i]` as the minimum number of perfect squares needed to sum to `i`, with base case `dp[0] = 0`. Then for each `i` from `1` to `n`, I iterate through all perfect squares up to `i` and do `dp[i] = min(dp[i], dp[i - sq] + 1)`. It is unbounded because the same square can be reused multiple times. The time complexity is `O(n * sqrt(n))` and the space complexity is `O(n)`.

## 收穫

- 先講清楚 state meaning，再寫 recurrence。
- base case、迴圈方向、return value 要在 coding 前確認。
- 如果是 DP 壓縮、graph traversal、或 greedy frontier，要能說出 invariant 為什麼成立。

## 遇到的問題

Good enough.
