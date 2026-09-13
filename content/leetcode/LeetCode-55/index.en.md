---
title: "LeetCode 55: Jump Game"
summary: "LeetCode Problem Solving - Greedy reachable frontier"
description: "LeetCode study note from 2026-05-01"
date: 2026-05-01
tags: ["medium", "greedy"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-05-01
Source Note: `notes/day16-week4-day2-jump-game-idempotency-grpc.md`

## Intuition

I scan left to right and keep the farthest index reachable so far. If I ever reach an index beyond that frontier, the answer is false. Otherwise I extend the frontier with i + nums[i]. If the frontier reaches the last in

Pattern: Greedy reachable frontier

## Approach

- **Pattern:** Greedy reachable frontier.

## Why Greedy Fits
At each index, the only future-relevant information is:
```text
how far to the right we can reach so far
```

We do not need to try every jump path. If an index is reachable, then the exact path that reached it no longer matters; only the farthest frontier matters.

## Core Invariant
```text
farthest = farthest index reachable after scanning positions up to i
```

## Failure Condition
```text
if i > farthest:
    current index is unreachable -> return False
```

## Update Rule
```text
farthest = max(farthest, i + nums[i])
```

## Complexity
```text
Time: O(n)
Space: O(1)
```

## Common Mistakes
- calling the best solution DP just because it scans left to right
- thinking greedy means "always physically take the biggest jump now"
- storing per-index state when only one frontier variable is needed

## Interview-Ready Explanation
I scan left to right and keep the farthest index reachable so far. If I ever reach an index beyond that frontier, the answer is false. Otherwise I extend the frontier with `i + nums[i]`. If the frontier reaches the last index, the array is solvable.

## Findings

- Keep the state meaning explicit before writing the transition.
- Check base cases and return value before trusting the recurrence.
- Explain why the iteration order or traversal order preserves the intended invariant.

## Encountered Problems

Good enough after greedy correction.
