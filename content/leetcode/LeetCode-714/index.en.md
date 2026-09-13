---
title: "LeetCode 714: Best Time to Buy and Sell Stock with Transaction Fee"
summary: "LeetCode Problem Solving - 2-state stock DP with transaction cost"
description: "LeetCode study note from 2026-05-17"
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
Source Note: `notes/day23-week5-day2-stock-cooldown-fee-clustered-vs-secondary-index.md`

## Intuition

This is still a hold/cash state machine. The fee does not create a new legal state; it only changes the economics of selling. So I keep the same twostate model as Stock II and subtract the fee in the sell transition. Tha

Pattern: 2-state stock DP with transaction cost

## Approach

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

## Findings

- Keep the state meaning explicit before writing the transition.
- Check base cases and return value before trusting the recurrence.
- Explain why the iteration order or traversal order preserves the intended invariant.

## Encountered Problems

Captured from the learning note; no separate failure note was recorded.
