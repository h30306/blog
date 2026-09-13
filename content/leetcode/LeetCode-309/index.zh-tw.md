---
title: "LeetCode 309: Best Time to Buy and Sell Stock with Cooldown"
summary: "LeetCode 解題筆記：Best Time to Buy and Sell Stock with Cooldown"
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

這篇整理 Best Time to Buy and Sell Stock with Cooldown 的解題筆記，重點放在 state-machine DP with one-day post-sell restriction、狀態定義、轉移式與容易犯錯的地方。

## 解法

以下內容整理自當天的 learning note，保留英文關鍵句，方便之後直接拿來做面試口說複習。

- **Pattern:** state-machine DP with one-day post-sell restriction.

## Why This Fits
The problem is still:
```text
best profit under exact holding conditions after day i
```

But now selling changes what is legal on the next day:
```text
after a sell, you cannot buy immediately the next day
```

That means the simple `hold/cash` model is not enough unless the cooldown effect is represented explicitly.

## Core State / Invariant
One clean 3-state version:
```text
hold = best profit after day i while holding one stock
sold = best profit after day i if we sold today
rest = best profit after day i while not holding and not selling today
```

Meaning matters more than the formula:
- `hold` means we own a stock at end of day
- `sold` means we just sold today, so tomorrow is cooldown
- `rest` means we are free to buy tomorrow

## Transitions
```text
hold = max(previous_hold, previous_rest - price)
sold = previous_hold + price
rest = max(previous_rest, previous_sold)
```

## Complexity
```text
Time: O(n)
Space: O(1)
```

## Common Mistakes
- reusing `sold` immediately for a same-day buy transition
- collapsing all non-hold states into one state and losing cooldown meaning
- memorizing `3` variables without being able to explain what each means
- returning `hold` instead of realized-profit states at the end

## Strong Spoken Explanation
I model the best profit under three end-of-day conditions: holding, sold-today, and resting. Cooldown matters because the day after a sell is not buy-eligible, so a new buy can only come from `rest`, not from `sold`. Each transition follows directly from that state meaning, which is why I do not need to memorize the formula.

## Final Answer Meaning
```text
answer = max(sold, rest)
```

Reason:
- final realized profit must be a non-holding state
- ending in `hold` means the profit is not fully realized yet

## 收穫

- 先講清楚 state meaning，再寫 recurrence。
- base case、迴圈方向、return value 要在 coding 前確認。
- 如果是 DP 壓縮、graph traversal、或 greedy frontier，要能說出 invariant 為什麼成立。

## 遇到的問題

原始筆記沒有另外紀錄失誤點。
