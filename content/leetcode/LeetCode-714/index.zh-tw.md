---
title: "LeetCode 714: Best Time to Buy and Sell Stock with Transaction Fee"
summary: "LeetCode 714 解題筆記，依照原始 learning note 重新整理"
description: "2026-05-17 的 LeetCode 714 學習紀錄，包含筆記修正點與正確解法"
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
來源：Day 23 learning note

## 學習脈絡

這篇是從 learning note 裡該 LeetCode 題目的段落重新整理出來的版本。我保留當天筆記中的修正點、比較點、容易犯錯的地方，並移除同一天其他非 LeetCode 主題，避免文章內容混題。

## 筆記中提到的相關提醒

- derive `LC 714` from `hold/cash` and explain where the fee is charged

## 當天筆記摘錄

#### Problem 2 - LC 714 Best Time to Buy and Sell Stock with Transaction Fee
- **Pattern:** 2-state stock DP with transaction cost.

#### Why This Fits
The legal actions are the same as unlimited transactions:
- keep holding or buy
- keep cash or sell

The only change is:
```text
every completed transaction pays a fee
```

So the state model stays simple, but one transition absorbs the fee.

#### Core State / Invariant
```text
hold = best profit after day i while holding one stock
cash = best profit after day i while not holding stock
```

#### Transitions
Charge the fee on sell:
```text
hold = max(previous_hold, previous_cash - price)
cash = max(previous_cash, previous_hold + price - fee)
```

Equivalent formulations can charge on buy instead. The important thing is consistency.

#### Complexity
```text
Time: O(n)
Space: O(1)
```

#### Common Mistakes
- subtracting the fee on both buy and sell
- mixing two equivalent formulations and double-charging
- calling it greedy without explaining the state meaning
- updating `cash` from an already-updated `hold` instead of `previous_hold`

#### Strong Spoken Explanation
This is still a `hold/cash` state machine. The fee does not create a new legal state; it only changes the economics of selling. So I keep the same two-state model as Stock II and subtract the fee in the sell transition. That keeps the recurrence clean and the interpretation stable.

#### Implementation Warning
When writing the rolling version, preserve previous-day values explicitly:
```text
prev_hold = hold
prev_cash = cash
```

Then update from those previous states, not from already-mutated same-day values.

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
from typing import List

class Solution:
    def maxProfit(self, prices: List[int], fee: int) -> int:
        hold = -prices[0]
        cash = 0

        for price in prices[1:]:
            hold = max(hold, cash - price)
            cash = max(cash, hold + price - fee)

        return cash
```

## 複雜度

Time O(n), Space O(1).

## 要特別避免的錯誤

- Subtracting the fee on both buy and sell.
- Using cooldown logic; there is no cooldown here.

## 面試口說整理

先講清楚 state definition，再說 transition 為什麼維持這個 state。只要這題有 loop direction、狀態壓縮、或題型相似但 answer shape 不同的地方，就要主動講出來，因為那通常就是這類題最容易出錯的點。
