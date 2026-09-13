---
title: "LeetCode 714: Best Time to Buy and Sell Stock with Transaction Fee"
summary: "LeetCode 解題筆記：Best Time to Buy and Sell Stock with Transaction Fee"
description: "2026-05-17 的 LeetCode 學習紀錄"
date: 2026-05-17
tags: ["medium", "dynamic-programming", "state-machine"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-05-17
來源筆記：`notes/day23-week5-day2-stock-cooldown-fee-clustered-vs-secondary-index.md`

## 解題思路

這篇整理 Best Time to Buy and Sell Stock with Transaction Fee 的解題筆記，重點放在 2-state stock DP with transaction cost、狀態定義、轉移式與容易犯錯的地方。

## 解法

以下內容整理自當天的 learning note，保留英文關鍵句，方便之後直接拿來做面試口說複習。

- **Pattern:** 2-state stock DP with transaction cost.

## Why This Fits
The legal actions are the same as unlimited transactions:
- keep holding or buy
- keep cash or sell

The only change is:
```text
every completed transaction pays a fee
```

So the state model stays simple, but one transition absorbs the fee.

## Core State / Invariant
```text
hold = best profit after day i while holding one stock
cash = best profit after day i while not holding stock
```

## Transitions
Charge the fee on sell:
```text
hold = max(previous_hold, previous_cash - price)
cash = max(previous_cash, previous_hold + price - fee)
```

Equivalent formulations can charge on buy instead. The important thing is consistency.

## Complexity
```text
Time: O(n)
Space: O(1)
```

## Common Mistakes
- subtracting the fee on both buy and sell
- mixing two equivalent formulations and double-charging
- calling it greedy without explaining the state meaning
- updating `cash` from an already-updated `hold` instead of `previous_hold`

## Strong Spoken Explanation
This is still a `hold/cash` state machine. The fee does not create a new legal state; it only changes the economics of selling. So I keep the same two-state model as Stock II and subtract the fee in the sell transition. That keeps the recurrence clean and the interpretation stable.

## Implementation Warning
When writing the rolling version, preserve previous-day values explicitly:
```text
prev_hold = hold
prev_cash = cash
```

Then update from those previous states, not from already-mutated same-day values.

## 收穫

- 先講清楚 state meaning，再寫 recurrence。
- base case、迴圈方向、return value 要在 coding 前確認。
- 如果是 DP 壓縮、graph traversal、或 greedy frontier，要能說出 invariant 為什麼成立。

## 遇到的問題

原始筆記沒有另外紀錄失誤點。
