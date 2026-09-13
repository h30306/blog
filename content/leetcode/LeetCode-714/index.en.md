---
title: "LeetCode 714: Best Time to Buy and Sell Stock with Transaction Fee"
summary: "LeetCode note for Best Time to Buy and Sell Stock with Transaction Fee, rebuilt from the original learning note"
description: "Cleaned LeetCode 714 article from 2026-05-17 with note repair points and final solution"
date: 2026-05-17
tags: ["medium", "dynamic-programming", "state-machine"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-05-17
Source: Day 23 learning note

## Study Context

This article is rebuilt from the exact LeetCode section in the learning note. I kept the note's repair points, comparison points, and common mistakes, while removing unrelated non-LeetCode material from the same day.

## Related Reminders From The Note

- derive `LC 714` from `hold/cash` and explain where the fee is charged

## Learning Note Extract

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

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

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

## Complexity

Time O(n), Space O(1).

## Mistakes To Watch

- Subtracting the fee on both buy and sell.
- Using cooldown logic; there is no cooldown here.

## Final Interview Explanation

Start from the state definition, then explain why the transition preserves that state. If there is a loop direction, state compression, or a similar-looking problem with a different answer shape, call that out explicitly because that is where this problem family usually breaks down.
