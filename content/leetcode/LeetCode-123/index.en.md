---
title: "LeetCode 123: Best Time to Buy and Sell Stock III"
summary: "LeetCode note for Best Time to Buy and Sell Stock III, rebuilt from the original learning note"
description: "Cleaned LeetCode 123 article from 2026-05-17 with note repair points and final solution"
date: 2026-05-17
tags: ["hard", "dynamic-programming", "state-machine"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-05-17
Source: Day 24 learning note

## Study Context

This article is rebuilt from the exact LeetCode section in the learning note. I kept the note's repair points, comparison points, and common mistakes, while removing unrelated non-LeetCode material from the same day.

## Related Reminders From The Note

- `LC 188` is not a different family from `LC 123`.
- explain `LC 123` using `buy1/sell1/buy2/sell2` as profit states
- explain why `LC 188` is the generalized transaction-stage version of `LC 123`

## Learning Note Extract

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

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

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

## Complexity

Time O(n), Space O(1).

## Mistakes To Watch

- Allowing more than two transactions.
- Updating states in a way that loses the action order.

## Final Interview Explanation

Start from the state definition, then explain why the transition preserves that state. If there is a loop direction, state compression, or a similar-looking problem with a different answer shape, call that out explicitly because that is where this problem family usually breaks down.
