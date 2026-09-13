---
title: "LeetCode 790: Domino and Tromino Tiling"
summary: "LeetCode note for Domino and Tromino Tiling, rebuilt from the original learning note"
description: "Cleaned LeetCode 790 article from 2026-05-24 with note repair points and final solution"
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
Source: Day 27 learning note

## Study Context

This article is rebuilt from the exact LeetCode section in the learning note. I kept the note's repair points, comparison points, and common mistakes, while removing unrelated non-LeetCode material from the same day.

## Learning Note Extract

#### Problem 2 - LC 790 Domino and Tromino Tiling
- **Pattern:** profile DP / full-state plus gap-state compression.

#### Why This Fits
The hard part of this problem is not counting tiles.

It is recognizing that when tiling a `2 x n` board, the frontier can end in only a small number of meaningful shapes:
- fully filled
- one corner missing

That is exactly profile-DP reasoning.

#### Core State / Invariant
```text
full[i] = number of ways to fully tile a 2 x i board
gap[i]  = number of ways to tile a 2 x i board with exactly one corner missing
```

The `gap` state uses symmetry:
- top-missing and bottom-missing have the same count
- so one variable is enough, and the factor `2` appears in `full`

#### Base Cases
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

#### Transition
```text
full[i] = full[i - 1] + full[i - 2] + 2 * gap[i - 1]
gap[i] = gap[i - 1] + full[i - 2]
```

#### Why These Transitions Make Sense
For `full[i]`:
- place one vertical domino after a full `2 x (i - 1)` board
- place two horizontal dominoes after a full `2 x (i - 2)` board
- place one tromino to close a previous gap; there are 2 mirrored gap orientations

For `gap[i]`:
- extend an earlier gap with one horizontal domino
- create a new gap by attaching one tromino to a full `2 x (i - 2)` board

#### Complexity
```text
Time: O(n)
Space: O(1)
```

#### Common Mistakes
- treating the problem like plain Fibonacci without explaining the gap state
- forgetting why the `2 * gap[i - 1]` term exists
- using a gap state but not defining what shape it means
- shaky base cases around `full[0]`

#### Strong Spoken Explanation
I model the board frontier, not individual tile placements. The board can end either fully covered or with exactly one corner missing, so I use `full[i]` and `gap[i]`. A full board of width `i` can come from a full board of width `i - 1` plus one vertical domino, from a full board of width `i - 2` plus two horizontal dominoes, or from closing one of the 2 mirrored gap states at width `i - 1` with a tromino. A gap board of width `i` can either extend a previous gap or be created from a full board of width `i - 2` with one tromino.

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

```python
class Solution:
    def numTilings(self, n: int) -> int:
        mod = 10 ** 9 + 7
        if n <= 2:
            return n
        a, b, c = 1, 1, 2  # dp[0], dp[1], dp[2]
        for _ in range(3, n + 1):
            a, b, c = b, c, (2 * c + a) % mod
        return c
```

## Complexity

Time O(n), Space O(1).

## Mistakes To Watch

- Forgetting modulo.
- Using only domino recurrence like Fibonacci and missing tromino shapes.

## Final Interview Explanation

Start from the state definition, then explain why the transition preserves that state. If there is a loop direction, state compression, or a similar-looking problem with a different answer shape, call that out explicitly because that is where this problem family usually breaks down.
