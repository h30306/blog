---
title: "LeetCode 121: Best Time To Buy And Sell Stock"
summary: "LeetCode Problem Solving - 1-transaction state machine / running minimum"
description: "LeetCode study note from 2026-05-17"
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
Source Note: `notes/day22-week5-day1-stock-i-ii-btree-index-internals.md`

## Intuition

For Stock I, I only need to know the cheapest buy price seen so far and the best sell profit I can realize afterward. In statemachine terms, I can model hold and cash, but because only one transaction is allowed, this co

Pattern: 1-transaction state machine / running minimum

## Approach

- **Pattern:** 1-transaction state machine / running minimum.

## Why This Fits
There is only one buy and one sell.

The two clean mental models are:
- running minimum price so far, then compute best profit
- 2-state DP:
  - `hold = best profit while holding one stock`
  - `cash = best profit while not holding stock`

## Core Invariant
```text
At day i, each state means the best profit achievable under that exact holding condition.
```

## Interview-Ready Explanation
For Stock I, I only need to know the cheapest buy price seen so far and the best sell profit I can realize afterward. In state-machine terms, I can model `hold` and `cash`, but because only one transaction is allowed, this collapses into tracking the running minimum price and updating the best profit with `price - min_price`.

## Common Mistakes
- memorizing the formula without knowing the state meaning
- allowing more than one buy/sell cycle
- saying "greedy" without explaining the invariant

## Findings

- Keep the state meaning explicit before writing the transition.
- Check base cases and return value before trusting the recurrence.
- Explain why the iteration order or traversal order preserves the intended invariant.

## Encountered Problems

Captured from the learning note; no separate failure note was recorded.
