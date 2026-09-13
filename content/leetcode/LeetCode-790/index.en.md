---
title: "LeetCode 790: Domino and Tromino Tiling"
summary: "LeetCode Problem Solving - profile DP / full-state plus gap-state compression"
description: "LeetCode study note from 2026-05-24"
date: 2026-05-24
tags: ["medium", "dynamic-programming"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-05-24
Source Note: `notes/day27-week5-weekend-day1-paint-fence-domino-tromino-btree-deep-dive.md`

## Intuition

I model the board frontier, not individual tile placements. The board can end either fully covered or with exactly one corner missing, so I use full[i] and gap[i]. A full board of width i can come from a full board of wi

Pattern: profile DP / full-state plus gap-state compression

## Approach

- **Pattern:** profile DP / full-state plus gap-state compression.

## Why This Fits
The hard part of this problem is not counting tiles.

It is recognizing that when tiling a `2 x n` board, the frontier can end in only a small number of meaningful shapes:
- fully filled
- one corner missing

That is exactly profile-DP reasoning.

## Core State / Invariant
```text
full[i] = number of ways to fully tile a 2 x i board
gap[i]  = number of ways to tile a 2 x i board with exactly one corner missing
```

The `gap` state uses symmetry:
- top-missing and bottom-missing have the same count
- so one variable is enough, and the factor `2` appears in `full`

## Base Cases
```text
full[0] = 1
full[1] = 1
gap[0] = 0
gap[1] = 0
```

Why:
- empty board has one valid tiling: do nothing
- `2 x 1` board has one vertical domino tiling
- you cannot create a one-corner-missing board of width `0` or `1` under the recurrence start

## Transition
```text
full[i] = full[i - 1] + full[i - 2] + 2 * gap[i - 1]
gap[i] = gap[i - 1] + full[i - 2]
```

## Why These Transitions Make Sense
For `full[i]`:
- place one vertical domino after a full `2 x (i - 1)` board
- place two horizontal dominoes after a full `2 x (i - 2)` board
- place one tromino to close a previous gap; there are 2 mirrored gap orientations

For `gap[i]`:
- extend an earlier gap with one horizontal domino
- create a new gap by attaching one tromino to a full `2 x (i - 2)` board

## Complexity
```text
Time: O(n)
Space: O(1)
```

## Common Mistakes
- treating the problem like plain Fibonacci without explaining the gap state
- forgetting why the `2 * gap[i - 1]` term exists
- using a gap state but not defining what shape it means
- shaky base cases around `full[0]`

## Strong Spoken Explanation
I model the board frontier, not individual tile placements. The board can end either fully covered or with exactly one corner missing, so I use `full[i]` and `gap[i]`. A full board of width `i` can come from a full board of width `i - 1` plus one vertical domino, from a full board of width `i - 2` plus two horizontal dominoes, or from closing one of the 2 mirrored gap states at width `i - 1` with a tromino. A gap board of width `i` can either extend a previous gap or be created from a full board of width `i - 2` with one tromino.

## Problem 3 - Timed Stock State Drill: LC 122 And LC 309
- **Pattern:** state-machine recall under pressure.

## Purpose
By Weekend Day 1, the stock thread should no longer depend on memorized formulas.

The drill is checking whether you can immediately say:
```text
state =
base case =
transition =
answer =
```

## Findings

- Keep the state meaning explicit before writing the transition.
- Check base cases and return value before trusting the recurrence.
- Explain why the iteration order or traversal order preserves the intended invariant.

## Encountered Problems

Captured from the learning note; no separate failure note was recorded.
