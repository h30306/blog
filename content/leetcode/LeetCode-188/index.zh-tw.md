---
title: "LeetCode 188: Best Time to Buy and Sell Stock IV"
summary: "LeetCode 解題筆記：Best Time to Buy and Sell Stock IV"
description: "2026-05-17 的 LeetCode 學習紀錄"
date: 2026-05-17
tags: ["leetcode", "hard", "dynamic-programming", "state-machine"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-05-17
來源筆記：`notes/day24-week5-day3-stock-iii-iv-index-vs-full-scan.md`

## 解題思路

這篇整理 Best Time to Buy and Sell Stock IV 的解題筆記，重點放在 generalized multi-transaction state-machine DP、狀態定義、轉移式與容易犯錯的地方。

## 解法

以下內容整理自當天的 learning note，保留英文關鍵句，方便之後直接拿來做面試口說複習。

- **Pattern:** generalized multi-transaction state-machine DP.

## Why This Fits
`LC 188` is not a different family from `LC 123`.

It is:
```text
the same state-machine idea, repeated for every transaction stage up to k
```

## Core State / Invariant
One clean definition:
```text
hold[t] = best profit if I end today holding one stock after having completed t - 1 sells
cash[t] = best profit if I end today not holding stock after having completed t sells
```

So:
- `hold[1]` corresponds to the first-buy stage
- `cash[1]` corresponds to the first-sell stage
- `hold[2]` corresponds to the second-buy stage
- `cash[2]` corresponds to the second-sell stage

This is why:
```text
LC 123 is just LC 188 with k = 2 hardcoded into named variables
```

## Transition Pattern
In words:
- `hold[t]` either keeps holding from yesterday, or buys today using the best non-holding profit after `t - 1` completed transactions
- `cash[t]` either keeps the realized profit from yesterday, or sells today from the corresponding holding state and completes transaction `t`

Clean mental model:
```text
buy from previous cash stage
sell from matching hold stage
```

## Initialization Intuition
Use arrays sized `k + 1` so transaction stage `0` is a real baseline:
- `cash[0] = 0`
- higher `cash` states start at `0` or unreachable depending on formulation
- all `hold` states should start unreachable except when a legal buy transition is made

The main benefit of `k + 1` indexing is:
```text
hold[1] can cleanly buy from cash[0]
```

## Large-k Optimization
If:
```text
k >= n // 2
```

then the transaction cap is no longer binding.

Why:
- a full transaction needs at least 2 days
- so you cannot physically complete more than `n // 2` profitable transactions anyway

That means the problem collapses to:
```text
unlimited transactions
```

## Why Unlimited-Transactions Greedy Works
On any increasing run such as:
```text
1 -> 3 -> 5 -> 8
```

you can either:
- take one transaction with profit `8 - 1`
- or sum adjacent gains:
  - `(3 - 1) + (5 - 3) + (8 - 5)`

Those are equal.

So once the transaction cap stops mattering, summing all positive day-to-day gains captures the full profit of each upward trend.

## Complexity
```text
Time: O(nk)
Space: O(k)
```

## Common Mistakes
- saying the extra dimension means days instead of transaction stage
- getting the stage indexing wrong and accidentally reading `cash[-1]`
- mutating a previous stage too early and corrupting the transition meaning
- forgetting the `k >= n // 2` optimization

## Strong Spoken Explanation
I generalize Stock III by turning the hardcoded buy/sell stages into arrays over transaction count. For each stage `t`, I track the best profit if I end today holding a stock and the best profit if I end today not holding after completing `t` sells. The recurrence stays the same as Stock III; I just repeat it for every transaction stage up to `k`.

## 收穫

- 先講清楚 state meaning，再寫 recurrence。
- base case、迴圈方向、return value 要在 coding 前確認。
- 如果是 DP 壓縮、graph traversal、或 greedy frontier，要能說出 invariant 為什麼成立。

## 遇到的問題

原始筆記沒有另外紀錄失誤點。
