---
title: "LeetCode 188: Best Time to Buy and Sell Stock IV"
summary: "LeetCode Problem Solving - generalized multi-transaction state-machine DP"
description: "LeetCode study note from 2026-05-17"
date: 2026-05-17
tags: ["leetcode", "hard", "dynamic-programming", "state-machine"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-05-17
Source Note: `notes/day24-week5-day3-stock-iii-iv-index-vs-full-scan.md`

## Intuition

I generalize Stock III by turning the hardcoded buy/sell stages into arrays over transaction count. For each stage t, I track the best profit if I end today holding a stock and the best profit if I end today not holding

Pattern: generalized multi-transaction state-machine DP

## Approach

- **Pattern:** generalized multi-transaction state-machine DP.

## Why This Fits
`LC 188` is not a different family from `LC 123`.

It is:
```text
the same state-machine idea, repeated for every transaction stage up to k
```

## Core State / Invariant
One clean definition:
```text
hold[t] = best profit if I end today holding one stock after having completed t - 1 sells
cash[t] = best profit if I end today not holding stock after having completed t sells
```

So:
- `hold[1]` corresponds to the first-buy stage
- `cash[1]` corresponds to the first-sell stage
- `hold[2]` corresponds to the second-buy stage
- `cash[2]` corresponds to the second-sell stage

This is why:
```text
LC 123 is just LC 188 with k = 2 hardcoded into named variables
```

## Transition Pattern
In words:
- `hold[t]` either keeps holding from yesterday, or buys today using the best non-holding profit after `t - 1` completed transactions
- `cash[t]` either keeps the realized profit from yesterday, or sells today from the corresponding holding state and completes transaction `t`

Clean mental model:
```text
buy from previous cash stage
sell from matching hold stage
```

## Initialization Intuition
Use arrays sized `k + 1` so transaction stage `0` is a real baseline:
- `cash[0] = 0`
- higher `cash` states start at `0` or unreachable depending on formulation
- all `hold` states should start unreachable except when a legal buy transition is made

The main benefit of `k + 1` indexing is:
```text
hold[1] can cleanly buy from cash[0]
```

## Large-k Optimization
If:
```text
k >= n // 2
```

then the transaction cap is no longer binding.

Why:
- a full transaction needs at least 2 days
- so you cannot physically complete more than `n // 2` profitable transactions anyway

That means the problem collapses to:
```text
unlimited transactions
```

## Why Unlimited-Transactions Greedy Works
On any increasing run such as:
```text
1 -> 3 -> 5 -> 8
```

you can either:
- take one transaction with profit `8 - 1`
- or sum adjacent gains:
  - `(3 - 1) + (5 - 3) + (8 - 5)`

Those are equal.

So once the transaction cap stops mattering, summing all positive day-to-day gains captures the full profit of each upward trend.

## Complexity
```text
Time: O(nk)
Space: O(k)
```

## Common Mistakes
- saying the extra dimension means days instead of transaction stage
- getting the stage indexing wrong and accidentally reading `cash[-1]`
- mutating a previous stage too early and corrupting the transition meaning
- forgetting the `k >= n // 2` optimization

## Strong Spoken Explanation
I generalize Stock III by turning the hardcoded buy/sell stages into arrays over transaction count. For each stage `t`, I track the best profit if I end today holding a stock and the best profit if I end today not holding after completing `t` sells. The recurrence stays the same as Stock III; I just repeat it for every transaction stage up to `k`.

## Findings

- Keep the state meaning explicit before writing the transition.
- Check base cases and return value before trusting the recurrence.
- Explain why the iteration order or traversal order preserves the intended invariant.

## Encountered Problems

Captured from the learning note; no separate failure note was recorded.
