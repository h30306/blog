---
title: "LeetCode 123: Best Time to Buy and Sell Stock III"
summary: "LeetCode 123 解題筆記，依照原始 learning note 重新整理"
description: "2026-05-17 的 LeetCode 123 學習紀錄，包含筆記修正點與正確解法"
date: 2026-05-17
tags: ["hard", "dynamic-programming", "state-machine"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-05-17
來源：Day 24 learning note

## 學習脈絡

這篇是從 learning note 裡該 LeetCode 題目的段落重新整理出來的版本。我保留當天筆記中的修正點、比較點、容易犯錯的地方，並移除同一天其他非 LeetCode 主題，避免文章內容混題。

## 筆記中提到的相關提醒

- `LC 188` is not a different family from `LC 123`.
- explain `LC 123` using `buy1/sell1/buy2/sell2` as profit states
- explain why `LC 188` is the generalized transaction-stage version of `LC 123`

## 當天筆記摘錄

#### Problem 1 - LC 123 Best Time to Buy and Sell Stock III
- **Pattern:** state-machine DP with 2 completed transactions maximum.

#### Why This Fits
The problem is still:
```text
best profit under exact end-of-day conditions
```

The only new ingredient is:
```text
which transaction stage am I currently in?
```

So instead of only tracking `hold` and `cash`, we hardcode the first 2 transaction stages.

#### Core State / Invariant
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

#### Transitions
```text
buy1  = max(prev_buy1, -price)
sell1 = max(prev_sell1, prev_buy1 + price)
buy2  = max(prev_buy2, prev_sell1 - price)
sell2 = max(prev_sell2, prev_buy2 + price)
```

#### Why These Transitions Make Sense
- `buy1`: either keep the earlier first-buy state, or start the first buy today from zero cash
- `sell1`: either keep the earlier one-transaction realized profit, or sell today from `buy1`
- `buy2`: either keep the earlier second-buy state, or use the realized profit from `sell1` to buy again
- `sell2`: either keep the earlier two-transaction realized profit, or sell today from `buy2`

#### Initialization
```text
buy1  = -inf
sell1 = 0
buy2  = -inf
sell2 = 0
```

Why:
- realized-profit states can validly start at `0` because doing nothing is legal
- `buy` states are unreachable before any buy happens, so `-inf` is the clean conceptual initialization

#### Final Answer Meaning
```text
answer = sell2
```

Reason:
- final realized profit must be a non-holding state
- in the standard formulation, `sell2` absorbs the best result with up to two transactions

#### Complexity
```text
Time: O(n)
Space: O(1)
```

#### Common Mistakes
- defining `buy` states as prices instead of profit states
- using already-updated same-day values instead of previous-day values
- initializing `buy2 = 0` and accidentally making an unreachable state look legal
- returning a holding state as the final answer

#### Strong Spoken Explanation
I model four exact transaction-stage states: after first buy, first sell, second buy, and second sell. Each state is the best profit if I end today in that exact condition. The recurrence is still a state machine, because each transition is just keep-the-state or do-one-legal-action-today from the adjacent prior stage.

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
from typing import List

class Solution:
    def maxProfit(self, prices: List[int]) -> int:
        hold1 = hold2 = float('-inf')
        cash1 = cash2 = 0

        for price in prices:
            hold1 = max(hold1, -price)
            cash1 = max(cash1, hold1 + price)
            hold2 = max(hold2, cash1 - price)
            cash2 = max(cash2, hold2 + price)

        return cash2
```

## 複雜度

Time O(n), Space O(1).

## 要特別避免的錯誤

- Allowing more than two transactions.
- Updating states in a way that loses the action order.

## 面試口說整理

先講清楚 state definition，再說 transition 為什麼維持這個 state。只要這題有 loop direction、狀態壓縮、或題型相似但 answer shape 不同的地方，就要主動講出來，因為那通常就是這類題最容易出錯的點。
