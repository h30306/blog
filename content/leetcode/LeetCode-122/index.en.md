---
title: "LeetCode 122: Best Time To Buy And Sell Stock II"
summary: "LeetCode note for Best Time To Buy And Sell Stock II, rebuilt from the original learning note"
description: "Cleaned LeetCode 122 article from 2026-05-17 with note repair points and final solution"
date: 2026-05-17
tags: ["medium", "dynamic-programming", "greedy", "state-machine"]
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
Source: Day 22 learning note

## Study Context

This article is rebuilt from the exact LeetCode section in the learning note. I kept the note's repair points, comparison points, and common mistakes, while removing unrelated non-LeetCode material from the same day.

## Learning Note Extract

#### Problem 2 - LC 122 Best Time To Buy And Sell Stock II
- **Pattern:** unlimited-transactions state machine.

#### Why This Fits
This is the simplest full stock-state problem:
- `hold = best profit while holding a stock after day i`
- `cash = best profit while not holding a stock after day i`

Because transactions are unlimited, the key difference from Stock I is:
```text
after selling, you are allowed to re-enter later
```

#### Core Transitions
```text
hold = max(previous_hold, previous_cash - price)
cash = max(previous_cash, previous_hold + price)
```

#### Interview-Ready Explanation
I define `hold` as the best profit if I end the day holding one stock, and `cash` as the best profit if I end the day not holding stock. On each day, I either keep the previous state or transition by buying or selling once. The value of the problem is not the formula itself, but that each transition comes directly from the meaning of the state.

#### Common Mistakes
- updating states in the wrong order without preserving previous values
- treating this as arbitrary greedy accumulation without understanding state meaning
- not being able to explain why buy/sell transitions are legal

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

```python
from typing import List

class Solution:
    def maxProfit(self, prices: List[int]) -> int:
        profit = 0
        for i in range(1, len(prices)):
            if prices[i] > prices[i - 1]:
                profit += prices[i] - prices[i - 1]
        return profit
```

## Complexity

Time O(n), Space O(1).

## Mistakes To Watch

- Overcomplicating with buy/sell dates.
- Forgetting unlimited transactions means adjacent rises can be combined.

## Final Interview Explanation

Start from the state definition, then explain why the transition preserves that state. If there is a loop direction, state compression, or a similar-looking problem with a different answer shape, call that out explicitly because that is where this problem family usually breaks down.
