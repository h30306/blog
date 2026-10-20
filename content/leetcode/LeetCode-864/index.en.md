---
title: "LeetCode 864: Shortest Path to Get All Keys"
summary: "LeetCode 864 note: the BFS state is (position, bitmask of keys), so the same cell with different keys is a different node"
description: "LeetCode 864 record from 2026-09-05"
date: 2026-09-05
tags: ["hard", "bfs", "bit-manipulation", "matrix"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-09-05
- Submissions: Accepted → Accepted (cleaned up)

## Approach

Walk a grid where a lock can be passed only after picking up its key; find the fewest steps to collect every key.

Position alone is not enough: standing on the same cell with different keys allows different moves. So **the BFS state is `(r, c, keys)`**, with `keys` as a bitmask (at most 6 keys, `2^6 = 64` combinations).

- Stepping on a key: add it to the mask.
- Stepping on a lock: allowed only if the mask holds its key.
- When the mask equals "all keys", the current step count is the answer.

## My Solution

```python
from collections import deque

class Solution:
    def shortestPathAllKeys(self, grid: List[str]) -> int:
        m, n = len(grid), len(grid[0])
        total = 0
        for r in range(m):
            for c in range(n):
                if grid[r][c] == "@":
                    start = (r, c)
                elif grid[r][c].islower():
                    total += 1
        full = (1 << total) - 1

        q = deque([(start[0], start[1], 0, 0)])            # r, c, keys, steps
        seen = {(start[0], start[1], 0)}
        while q:
            r, c, keys, steps = q.popleft()
            if keys == full:
                return steps
            for nr, nc in ((r + 1, c), (r - 1, c), (r, c + 1), (r, c - 1)):
                if not (0 <= nr < m and 0 <= nc < n) or grid[nr][nc] == "#":
                    continue
                ch = grid[nr][nc]
                if ch.isupper() and not keys >> (ord(ch) - ord("A")) & 1:
                    continue                               # no key, cannot pass
                nkeys = keys | (1 << (ord(ch) - ord("a"))) if ch.islower() else keys
                if (nr, nc, nkeys) not in seen:
                    seen.add((nr, nc, nkeys))
                    q.append((nr, nc, nkeys, steps + 1))
        return -1
```

## Complexity

Time `O(mn · 2^k)`, where `k` is the number of keys. Space `O(mn · 2^k)`.

## Mistakes to Avoid

- `visited` storing only the position: paths that double back after picking up a key get blocked.
- Hard-coding 6 keys: build the "all keys" mask from the keys actually in the grid.
- Marking visited cells in place on the grid: with different keys you may need to pass the same cell again, so the mark belongs in a `seen` set that includes the key mask.

## Interview Explanation

Holding different keys on the same cell changes where you can go next, so the BFS state is the position plus a bitmask of keys. Stepping on a key sets its bit, and a lock requires its bit to be set. `visited` stores the whole state, and the first time the mask is full, the step count is the answer. There are `mn · 2^k` states, with `k` at most 6.
