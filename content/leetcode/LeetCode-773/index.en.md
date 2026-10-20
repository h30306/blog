---
title: "LeetCode 773: Sliding Puzzle"
summary: "LeetCode 773 note: there are only 6! = 720 boards, so flatten each board into a string as a BFS state, with swaps of 0 and a neighbor as the moves"
description: "LeetCode 773 record from 2026-09-07"
date: 2026-09-07
tags: ["hard", "breadth-first-search", "dynamic-programming", "memoization", "matrix"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-09-07
- Submissions: Accepted (first try)

## Approach

A 2 × 3 board has only `6! = 720` arrangements, so the whole board can be a state for **BFS**, where the first time the target is reached gives the fewest moves (see state-space BFS in [BFS]({{< relref "/algorithm/BFS" >}})).

- State: the board flattened into a 6-character string, e.g. `"412503"`.
- Move: find `0` and swap it with an adjacent cell. After flattening, each position's neighbors are fixed, so write them as a table:

```text
0 1 2
3 4 5
```

`0: [1, 3]`, `1: [0, 2, 4]`, `2: [1, 5]`, `3: [0, 4]`, `4: [1, 3, 5]`, `5: [2, 4]`.

If BFS ends without reaching `"123450"`, return -1.

## My Solution

```python
from collections import deque

class Solution:
    def slidingPuzzle(self, board: List[List[int]]) -> int:
        start = "".join(str(x) for row in board for x in row)
        target = "123450"
        neighbors = {0: [1, 3], 1: [0, 2, 4], 2: [1, 5], 3: [0, 4], 4: [1, 3, 5], 5: [2, 4]}

        queue = deque([(start, 0)])
        seen = {start}
        while queue:
            state, moves = queue.popleft()
            if state == target:
                return moves
            z = state.index("0")
            for nb in neighbors[z]:
                s = list(state)
                s[z], s[nb] = s[nb], s[z]
                nxt = "".join(s)
                if nxt not in seen:
                    seen.add(nxt)
                    queue.append((nxt, moves + 1))
        return -1
```

## Complexity

At most 720 states with at most 3 neighbors each: constant time.

## Mistakes to Avoid

- Using a list as the state: lists cannot go in a `set`; use a string or tuple.
- Mind the row break when flattening: positions 2 and 3 are not adjacent.

## Interview Explanation

There are only 720 boards, so I flatten each board into a string as a BFS state, swap 0 with an adjacent cell each move, dedupe with `seen`, and the first arrival at the target is the fewest moves; otherwise return -1. A neighbor table avoids treating the two cells across the row break as adjacent.
