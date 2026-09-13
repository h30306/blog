---
title: "LeetCode 122: Best Time To Buy And Sell Stock II"
summary: "LeetCode Problem Solving - unlimited-transactions state machine"
description: "LeetCode study note from 2026-05-17"
date: 2026-05-17
tags: ["leetcode", "medium", "dynamic-programming", "greedy", "state-machine"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-05-17
Source Note: `notes/day22-week5-day1-stock-i-ii-btree-index-internals.md`

## Intuition

I define hold as the best profit if I end the day holding one stock, and cash as the best profit if I end the day not holding stock. On each day, I either keep the previous state or transition by buying or selling once.

Pattern: unlimited-transactions state machine

## Approach

- **Pattern:** unlimited-transactions state machine.

## Why This Fits
This is the simplest full stock-state problem:
- `hold = best profit while holding a stock after day i`
- `cash = best profit while not holding a stock after day i`

Because transactions are unlimited, the key difference from Stock I is:
```text
after selling, you are allowed to re-enter later
```

## Core Transitions
```text
hold = max(previous_hold, previous_cash - price)
cash = max(previous_cash, previous_hold + price)
```

## Interview-Ready Explanation
I define `hold` as the best profit if I end the day holding one stock, and `cash` as the best profit if I end the day not holding stock. On each day, I either keep the previous state or transition by buying or selling once. The value of the problem is not the formula itself, but that each transition comes directly from the meaning of the state.

## Common Mistakes
- updating states in the wrong order without preserving previous values
- treating this as arbitrary greedy accumulation without understanding state meaning
- not being able to explain why buy/sell transitions are legal

## Findings

- Keep the state meaning explicit before writing the transition.
- Check base cases and return value before trusting the recurrence.
- Explain why the iteration order or traversal order preserves the intended invariant.

## Encountered Problems

Captured from the learning note; no separate failure note was recorded.
