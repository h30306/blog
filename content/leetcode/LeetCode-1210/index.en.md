---
title: "LeetCode 1210: Minimum Moves to Reach Target with Rotations"
summary: "LeetCode 1210 note: the BFS state is (tail position, orientation), each move checks its own empty cells, and equal step costs need no heap"
description: "LeetCode 1210 record from 2026-09-12"
date: 2026-09-12
tags: ["hard", "bfs", "matrix"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-09-12
- Submissions: Accepted (heap) → Accepted (deque) → Accepted (3D state)

## Approach

The snake covers two cells, starting at `(0,0)-(0,1)` and aiming for `(n-1,n-2)-(n-1,n-1)`. Each step moves right, moves down, or rotates.

Every step costs 1, so use BFS. Represent the state by **the tail (top-left cell) and the orientation**: `(r, c, d)`, with `d = 0` horizontal and `d = 1` vertical.

Each move needs certain cells to be empty:

| Orientation | Move | Cells that must be empty | New state |
|---|---|---|---|
| horizontal | right | `(r, c+2)` | `(r, c+1, 0)` |
| horizontal | down | `(r+1, c)`, `(r+1, c+1)` | `(r+1, c, 0)` |
| horizontal | rotate clockwise | `(r+1, c)`, `(r+1, c+1)` | `(r, c, 1)` |
| vertical | right | `(r, c+1)`, `(r+1, c+1)` | `(r, c+1, 1)` |
| vertical | down | `(r+2, c)` | `(r+1, c, 1)` |
| vertical | rotate counterclockwise | `(r, c+1)`, `(r+1, c+1)` | `(r, c, 0)` |

When horizontal, "down" and "rotate clockwise" need the same cells; when vertical, so do "right" and "rotate counterclockwise".

## My Attempts

The first version used a heap of `(steps, tail, head, orientation)`. With equal step costs, a plain BFS queue already processes states in step order, so the heap only added a `log` factor. The second version switched to a deque.

The third version reduced the state from "four coordinates of tail and head" to "tail plus orientation", used a 3D `visited` array, and organized the six moves like the table above.

## Solution

```python
from collections import deque

class Solution:
    def minimumMoves(self, grid: List[List[int]]) -> int:
        n = len(grid)
        seen = {(0, 0, 0)}
        q = deque([(0, 0, 0, 0)])                     # r, c, d, moves
        while q:
            r, c, d, moves = q.popleft()
            if (r, c, d) == (n - 1, n - 2, 0):
                return moves
            nxt = []
            if d == 0:
                if c + 2 < n and grid[r][c + 2] == 0:
                    nxt.append((r, c + 1, 0))
                if r + 1 < n and grid[r + 1][c] == 0 and grid[r + 1][c + 1] == 0:
                    nxt.append((r + 1, c, 0))
                    nxt.append((r, c, 1))
            else:
                if r + 2 < n and grid[r + 2][c] == 0:
                    nxt.append((r + 1, c, 1))
                if c + 1 < n and grid[r][c + 1] == 0 and grid[r + 1][c + 1] == 0:
                    nxt.append((r, c + 1, 1))
                    nxt.append((r, c, 0))
            for state in nxt:
                if state not in seen:
                    seen.add(state)
                    q.append((*state, moves + 1))
        return -1
```

## Complexity

Time `O(n^2)`: at most `2n^2` states with at most 3 moves each. Space `O(n^2)`.

## Mistakes to Avoid

- Checking only the cell the head moves into when rotating: the diagonal cell swept by the rotation must be empty too.
- Using a heap when every step costs the same.
- Using four coordinates as the state: it works, but tail plus orientation is simpler and harder to get wrong.

## Interview Explanation

Every step costs 1, so I use BFS. The state is the tail position plus horizontal or vertical; horizontal allows right, down, and clockwise rotation, vertical allows down, right, and counterclockwise rotation, and each checks the cells it needs empty, with a rotation needing the same cells as shifting to that side. The step count at the first arrival at the target state is the answer, with `O(n^2)` states.
