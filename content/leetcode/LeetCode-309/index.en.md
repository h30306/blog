---
title: "LeetCode 309: Best Time to Buy and Sell Stock with Cooldown"
summary: "LeetCode note for Best Time to Buy and Sell Stock with Cooldown, rebuilt from the original learning note"
description: "Cleaned LeetCode 309 article from 2026-05-17 with note repair points and final solution"
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

## Learning Note Extract

#### Problem 1 - LC 309 Best Time to Buy and Sell Stock with Cooldown
- **Pattern:** state-machine DP with one-day post-sell restriction.

#### Why This Fits
The problem is still:
```text
best profit under exact holding conditions after day i
```

But now selling changes what is legal on the next day:
```text
after a sell, you cannot buy immediately the next day
```

That means the simple `hold/cash` model is not enough unless the cooldown effect is represented explicitly.

#### Core State / Invariant
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

#### Transitions
```text
hold = max(previous_hold, previous_rest - price)
sold = previous_hold + price
rest = max(previous_rest, previous_sold)
```

#### Complexity
```text
Time: O(n)
Space: O(1)
```

#### Common Mistakes
- reusing `sold` immediately for a same-day buy transition
- collapsing all non-hold states into one state and losing cooldown meaning
- memorizing `3` variables without being able to explain what each means
- returning `hold` instead of realized-profit states at the end

#### Strong Spoken Explanation
I model the best profit under three end-of-day conditions: holding, sold-today, and resting. Cooldown matters because the day after a sell is not buy-eligible, so a new buy can only come from `rest`, not from `sold`. Each transition follows directly from that state meaning, which is why I do not need to memorize the formula.

#### Final Answer Meaning
```text
answer = max(sold, rest)
```

Reason:
- final realized profit must be a non-holding state
- ending in `hold` means the profit is not fully realized yet

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

```python
from typing import List

class Solution:
    def maxProfit(self, prices: List[int]) -> int:
        hold = float('-inf')
        sold = float('-inf')
        rest = 0

        for price in prices:
            hold, sold, rest = max(hold, rest - price), hold + price, max(rest, sold)

        return max(sold, rest)
```

## Complexity

Time O(n), Space O(1).

## Mistakes To Watch

- Buying immediately after a sell.
- Using one cash state without modeling cooldown.

## Final Interview Explanation

Start from the state definition, then explain why the transition preserves that state. If there is a loop direction, state compression, or a similar-looking problem with a different answer shape, call that out explicitly because that is where this problem family usually breaks down.
