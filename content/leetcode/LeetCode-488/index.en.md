---
title: "LeetCode 488: Zuma Game"
summary: "LeetCode 488 note: with at most 16 balls on the board and 5 in hand, memoize DFS on the whole (board, hand) state, inserting only before a same-colored ball or between two equal balls"
description: "LeetCode 488 record from 2026-07-08"
date: 2026-07-08
tags: ["hard", "dynamic-programming", "memoization", "breadth-first-search", "string", "stack"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-07-08
- Submissions: Wrong Answer ×2 → Accepted

## Approach

An insertion triggers chain removals, so the board cannot be split into independent ranges. But the board has at most 16 balls and the hand at most 5, so the whole `(board, hand)` can be the state for a memoized DFS:

- Empty `board`: 0 steps.
- For each kind of ball in hand (sorted, skipping repeats) and each insertion point, insert, clear, recurse, and take the minimum + 1.

**Pruning**: only two kinds of positions are worth trying:

1. **Before a ball of the same color**: building a group.
2. **Between two equal balls of a different color from the one inserted**: e.g. `W` into `RR` gives `RWR`, letting each `R` later join other `R`s.

Clearing is a loop: find a run of length `>= 3`, delete it, and rescan from the start until nothing can be removed.

## My Attempts

| Version | Problem |
|---|---|
| Attempt 1 | Inserted only next to same-colored balls, missing the "split two equal balls" move |
| Attempt 2 | Added the split condition, but inserted with `b[:j + 1] + h[i] + b[j + 1:]`, placing the ball **after** `b[j]`; a split needs it between `b[j - 1]` and `b[j]`, so nothing was actually split |
| AC | Changed it to `b[:j] + h[i] + b[j:]` |

Both fail on `board = "RRWWRRBBRR"`, `hand = "WB"`: the answer is 2 (first split an `RR` with a `W` to trigger a chain), and both returned -1.

## Solution

```python
from functools import cache

class Solution:
    def findMinStep(self, board: str, hand: str) -> int:
        def clean(s: str) -> str:
            i = 0
            while i < len(s):
                j = i
                while j < len(s) and s[j] == s[i]:
                    j += 1
                if j - i >= 3:
                    s = s[:i] + s[j:]              # delete, then rescan (chain removals)
                    i = 0
                else:
                    i = j
            return s

        @cache
        def dfs(b: str, h: str) -> float:
            if not b:
                return 0
            best = float("inf")
            for i in range(len(h)):
                if i > 0 and h[i] == h[i - 1]:
                    continue                       # try each kind of ball once
                for j in range(len(b) + 1):
                    same = j < len(b) and b[j] == h[i]
                    split = 0 < j < len(b) and b[j - 1] == b[j] != h[i]
                    if same or split:
                        nb = clean(b[:j] + h[i] + b[j:])
                        best = min(best, 1 + dfs(nb, h[:i] + h[i + 1:]))
            return best

        res = dfs(board, "".join(sorted(hand)))
        return -1 if res == float("inf") else res
```

## Complexity

The states are the boards reachable by insertions and removals times the subsets of the hand, exponential in the worst case, but with a short board and hand, memoization plus pruning passes.

## Mistakes to Avoid

- Inserting only next to same-colored balls: splitting two equal balls is sometimes the only solution.
- An insertion index off by one.
- Sort the hand first so repeated balls can be skipped.

## Interview Explanation

Insertions cause chain removals, so the problem does not split into subproblems, but the board and hand are short, so I memoize a DFS on the whole `(board, hand)`. Each step tries every kind of ball in hand at every insertion point, but only before a same-colored ball or between two equal balls, simulates the removals, recurses, and keeps the fewest steps.
