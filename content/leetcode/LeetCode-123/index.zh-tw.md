---
title: "LeetCode 123: Best Time to Buy and Sell Stock III"
summary: "LeetCode 解題筆記：Best Time to Buy and Sell Stock III"
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

這篇整理 Best Time to Buy and Sell Stock III 的解題筆記，重點放在 state-machine DP with 2 completed transactions maximum、狀態定義、轉移式與容易犯錯的地方。

## 解法

以下內容整理自當天的 learning note，保留英文關鍵句，方便之後直接拿來做面試口說複習。

- **Pattern:** state-machine DP with 2 completed transactions maximum.

## Why This Fits
The problem is still:
```text
best profit under exact end-of-day conditions
```

The only new ingredient is:
```text
which transaction stage am I currently in?
```

So instead of only tracking `hold` and `cash`, we hardcode the first 2 transaction stages.

## Core State / Invariant
```text
buy1  = best profit after first buy
sell1 = best profit after first sell
buy2  = best profit after second buy
sell2 = best profit after second sell
```

Each state means:
- `buy1`: I end today holding one stock after entering the first transaction
- `sell1`: I end today not holding stock after completing one transaction
- `buy2`: I end today holding one stock after already finishing the first transaction and buying again
- `sell2`: I end today not holding stock after completing two transactions

Important:
```text
all 4 are profit states
```

`buy1` and `buy2` are often negative, but that is correct because they represent net profit while still holding a stock.

## Transitions
```text
buy1  = max(prev_buy1, -price)
sell1 = max(prev_sell1, prev_buy1 + price)
buy2  = max(prev_buy2, prev_sell1 - price)
sell2 = max(prev_sell2, prev_buy2 + price)
```

## Why These Transitions Make Sense
- `buy1`: either keep the earlier first-buy state, or start the first buy today from zero cash
- `sell1`: either keep the earlier one-transaction realized profit, or sell today from `buy1`
- `buy2`: either keep the earlier second-buy state, or use the realized profit from `sell1` to buy again
- `sell2`: either keep the earlier two-transaction realized profit, or sell today from `buy2`

## Initialization
```text
buy1  = -inf
sell1 = 0
buy2  = -inf
sell2 = 0
```

Why:
- realized-profit states can validly start at `0` because doing nothing is legal
- `buy` states are unreachable before any buy happens, so `-inf` is the clean conceptual initialization

## Final Answer Meaning
```text
answer = sell2
```

Reason:
- final realized profit must be a non-holding state
- in the standard formulation, `sell2` absorbs the best result with up to two transactions

## Complexity
```text
Time: O(n)
Space: O(1)
```

## Common Mistakes
- defining `buy` states as prices instead of profit states
- using already-updated same-day values instead of previous-day values
- initializing `buy2 = 0` and accidentally making an unreachable state look legal
- returning a holding state as the final answer

## Strong Spoken Explanation
I model four exact transaction-stage states: after first buy, first sell, second buy, and second sell. Each state is the best profit if I end today in that exact condition. The recurrence is still a state machine, because each transition is just keep-the-state or do-one-legal-action-today from the adjacent prior stage.

## 收穫

- 先講清楚 state meaning，再寫 recurrence。
- base case、迴圈方向、return value 要在 coding 前確認。
- 如果是 DP 壓縮、graph traversal、或 greedy frontier，要能說出 invariant 為什麼成立。

## 遇到的問題

原始筆記沒有另外紀錄失誤點。
