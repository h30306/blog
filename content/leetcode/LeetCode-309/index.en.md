---
title: "LeetCode 309: Best Time to Buy and Sell Stock with Cooldown"
summary: "LeetCode Problem Solving - state-machine DP with one-day post-sell restriction"
description: "LeetCode study note from 2026-05-17"
date: 2026-05-17
tags: ["leetcode", "medium", "dynamic-programming", "state-machine"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-05-17
Source Note: `notes/day23-week5-day2-stock-cooldown-fee-clustered-vs-secondary-index.md`

## Intuition

I model the best profit under three endofday conditions: holding, soldtoday, and resting. Cooldown matters because the day after a sell is not buyeligible, so a new buy can only come from rest, not from sold. Each transi

Pattern: state-machine DP with one-day post-sell restriction

## Approach

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

## Findings

- Keep the state meaning explicit before writing the transition.
- Check base cases and return value before trusting the recurrence.
- Explain why the iteration order or traversal order preserves the intended invariant.

## Encountered Problems

Captured from the learning note; no separate failure note was recorded.
