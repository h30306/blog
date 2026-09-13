---
title: "LeetCode 121: Best Time To Buy And Sell Stock"
summary: "LeetCode note for Best Time To Buy And Sell Stock, rebuilt from the original learning note"
description: "Cleaned LeetCode 121 article from 2026-05-17 with note repair points and final solution"
date: 2026-05-17
tags: ["easy", "dynamic-programming", "state-machine"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2026-05-17
Source: Day 22 learning note

## Study Context

This article is rebuilt from the exact LeetCode section in the learning note. I kept the note's repair points, comparison points, and common mistakes, while removing unrelated non-LeetCode material from the same day.

## Learning Note Extract

#### Problem 1 - LC 121 Best Time To Buy And Sell Stock
- **Pattern:** 1-transaction state machine / running minimum.

#### Why This Fits
There is only one buy and one sell.

The two clean mental models are:
- running minimum price so far, then compute best profit
- 2-state DP:
  - `hold = best profit while holding one stock`
  - `cash = best profit while not holding stock`

#### Core Invariant
```text
At day i, each state means the best profit achievable under that exact holding condition.
```

#### Interview-Ready Explanation
For Stock I, I only need to know the cheapest buy price seen so far and the best sell profit I can realize afterward. In state-machine terms, I can model `hold` and `cash`, but because only one transaction is allowed, this collapses into tracking the running minimum price and updating the best profit with `price - min_price`.

#### Common Mistakes
- memorizing the formula without knowing the state meaning
- allowing more than one buy/sell cycle
- saying "greedy" without explaining the invariant

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

```python
from typing import List

class Solution:
    def maxProfit(self, prices: List[int]) -> int:
        min_price = float('inf')
        best = 0

        for price in prices:
            min_price = min(min_price, price)
            best = max(best, price - min_price)

        return best
```

## Complexity

Time O(n), Space O(1).

## Mistakes To Watch

- Selling before buying.
- Using multiple transactions; this version allows one transaction only.

## Final Interview Explanation

Start from the state definition, then explain why the transition preserves that state. If there is a loop direction, state compression, or a similar-looking problem with a different answer shape, call that out explicitly because that is where this problem family usually breaks down.
