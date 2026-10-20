---
title: "LeetCode 2267: Check if There Is a Valid Parentheses String Path"
summary: "LeetCode 2267 note: the state is (r, c, open balance); the balance can be neither negative nor more than the remaining steps; search the states with BFS / DP and succeed at the end with balance 0"
description: "LeetCode 2267 record from 2026-10-13"
date: 2026-10-13
tags: ["hard", "dynamic-programming", "grid-dp", "matrix", "bracket-sequences"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-10-13
- Submissions: Wrong Answer ×2 → Accepted

## Approach

Whether a bracket string is valid depends only on **the current balance** (opens minus closes): never negative along the way, 0 at the end. So the state is `(r, c, bal)`.

Pruning:

- An odd path length `m + n - 1`, a `)` at the start, or a `(` at the end: impossible.
- `bal < 0`: already invalid.
- `bal > remaining steps`: even all `)` from here could not close it.

BFS right / down from `(0, 0, 1)` with a `seen` set for repeated states, returning `True` at the end with `bal == 0`.

## My Attempts

The first two versions simulated brackets with a stack, but every path **shared the same list**: `queue.append((nr, nc, stack))` enqueued the same object, so one path's pushes and pops affected the others.

| Version | Problem |
|---|---|
| Attempt 1 | The stack already held `grid[0][0]` at the start, and processing the start pushed it again, counting the first `(` twice. For `[["(", ")"]]` the answer is `True`; it returned `False` |
| Attempt 2 | Fixed the start, but the stack was still shared. For `[["(", ")"], ["(", ")"]]` the path length is 3, so nothing is valid and the answer is `False`; it returned `True` |
| AC | Used an integer `bal` as the state, with pruning and `seen` |

## Solution

```python
from collections import deque

class Solution:
    def hasValidPath(self, grid: List[List[str]]) -> bool:
        m, n = len(grid), len(grid[0])
        if (m + n - 1) % 2 or grid[0][0] == ")" or grid[-1][-1] == "(":
            return False

        start = (0, 0, 1)
        seen = {start}
        queue = deque([start])
        while queue:
            r, c, bal = queue.popleft()
            if r == m - 1 and c == n - 1 and bal == 0:
                return True
            for nr, nc in ((r + 1, c), (r, c + 1)):
                if nr < m and nc < n:
                    nb = bal + (1 if grid[nr][nc] == "(" else -1)
                    remaining = (m - 1 - nr) + (n - 1 - nc)
                    if 0 <= nb <= remaining and (nr, nc, nb) not in seen:
                        seen.add((nr, nc, nb))
                        queue.append((nr, nc, nb))
        return False
```

## Complexity

Time `O(mn(m + n))` (the balance is at most the path length), and the same for space.

## Mistakes to Avoid

- Putting a mutable list into the queue: every path shares one object.
- Do not count the starting bracket twice.
- Without the `bal > remaining` prune, many impossible states get searched.

## Interview Explanation

Validity depends only on the balance, so the state is the position plus the balance. I BFS right / down from the start, rejecting negative balances and balances above the remaining steps, using `seen` to drop repeats, and succeed when the end is reached with balance exactly 0. Odd path lengths, a starting `)` and an ending `(` are ruled out first. Time `O(mn(m + n))`.
