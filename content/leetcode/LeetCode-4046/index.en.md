---
title: "LeetCode 4046: Minimum Cost Path With At Most K Turns"
summary: "LeetCode 4046 note: Dijkstra with the last direction and the turns used in the state; for the same cell and direction, an earlier pop is cheaper, and if it also used fewer turns it dominates later states"
description: "LeetCode 4046 record from 2026-09-11"
date: 2026-09-11
tags: ["hard", "graph", "shortest-path", "heap", "matrix"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-09-11
- Submissions: Wrong Answer ×2 → Accepted

## Approach

Cell costs are `>= 0`, cells may be revisited, and we want the minimum total, so it is Dijkstra. But "at most `k` turns" is not the distance itself and has to go into the state ([Shortest Path]({{< relref "/algorithm/Shortest-Path" >}}), put the constraint in the state): `(row, col, last direction, turns used)`.

- Changing direction adds a turn; the first move has no previous direction and is not a turn.
- Drop states with more than `k` turns.
- For the same `(row, col, direction)`, whatever leaves the heap first is cheaper; if it also used no more turns, later states are dominated and skipped.

## My Attempts

The first two versions computed turns as `turns + 1 if turned else 0`. Python's conditional expression has the lowest precedence, so this picks between `turns + 1` and `0`, **resetting the count to 0 when going straight**. For `grid = [[6, 6, 3], [4, 1, 1], [3, 2, 2]]`, `k = 1` the answer is 17; it returned 14 using a two-turn route. Adding parentheses, `turns + (1 if ... else 0)`, passed.

## Solution

```python
class Solution:
    def minCost(self, grid: List[List[int]], k: int) -> int:
        m, n = len(grid), len(grid[0])
        dirs = ((0, 1), (1, 0), (0, -1), (-1, 0))
        best_turns = {}                            # (r, c, d) -> fewest turns processed
        pq = [(grid[0][0], 0, 0, 0, -1)]           # cost, turns, r, c, last direction
        while pq:
            cost, t, r, c, d = heapq.heappop(pq)
            if (r, c) == (m - 1, n - 1):
                return cost
            if best_turns.get((r, c, d), k + 1) <= t:
                continue
            best_turns[(r, c, d)] = t
            for nd, (dr, dc) in enumerate(dirs):
                nr, nc = r + dr, c + dc
                nt = t + (d != -1 and nd != d)
                if 0 <= nr < m and 0 <= nc < n and nt <= k:
                    heapq.heappush(pq, (cost + grid[nr][nc], nt, nr, nc, nd))
        return -1
```

## Complexity

At most `m · n · 4 · (k + 1)` states; time `O(S log S)` for `S` states, space `O(S)`.

## Mistakes to Avoid

- `a + 1 if cond else 0` means `(a + 1) if cond else 0`; add parentheses.
- `(row, col)` alone is not enough for visited; direction and turns both affect what comes next.

## Interview Explanation

Costs are non-negative and we want the minimum sum, so Dijkstra, with the last direction and turns used in the state: a direction change adds a turn, and over `k` is not allowed. For the same cell and direction, the first pop is cheaper, so if it also used fewer turns later states are pointless and skipped. The first time the target is popped gives the answer.
