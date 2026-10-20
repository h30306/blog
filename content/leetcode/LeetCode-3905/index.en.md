---
title: "LeetCode 3905: Multi Source Flood Fill"
summary: "LeetCode 3905 note: multi-source BFS one layer at a time, collecting the maximum color per cell before writing the layer back"
description: "LeetCode 3905 record from 2026-04-19"
date: 2026-04-19
tags: ["medium", "bfs", "matrix"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-04-19
- Submissions: Runtime Error → Accepted

## Approach

All sources spread **simultaneously**: each step colors the uncolored neighbors in four directions, and when several colors reach a cell in the same step, the largest wins.

This is multi-source BFS, with care for "simultaneously":

1. Process a whole layer at a time.
2. Collect every cell reached in this layer into a dict, keeping the largest color per cell.
3. Only after the layer is done, write the results to the grid and push them for the next layer.

Writing to the grid while processing would let a source handled earlier in the layer claim a cell before a larger color from later in the same layer gets a chance.

## My Attempt: swapped grid dimensions

```python
matrix = [[0] * n for _ in range(m)]       # should be [[0] * m for _ in range(n)]
```

The grid has `n` rows and `m` columns, but the first version built `m` rows of `n`, which goes out of range when `n != m`.

## Solution

```python
from collections import deque

class Solution:
    def colorGrid(self, n: int, m: int, sources: List[List[int]]) -> List[List[int]]:
        grid = [[0] * m for _ in range(n)]
        q = deque()
        for r, c, color in sources:
            grid[r][c] = color
            q.append((r, c, color))

        while q:
            arrivals = {}
            for _ in range(len(q)):
                r, c, color = q.popleft()
                for nr, nc in ((r + 1, c), (r - 1, c), (r, c + 1), (r, c - 1)):
                    if 0 <= nr < n and 0 <= nc < m and grid[nr][nc] == 0:
                        arrivals[(nr, nc)] = max(arrivals.get((nr, nc), 0), color)
            for (nr, nc), color in arrivals.items():
                grid[nr][nc] = color
                q.append((nr, nc, color))
        return grid
```

My original used two nested `while` loops, the inner one draining the queue and the outer one pushing the layer back, which is equivalent.

## Complexity

Time `O(nm)`: each cell is colored once. Space `O(nm)`.

## Mistakes to Avoid

- Swapping the grid dimensions.
- Writing to the grid mid-layer: comparisons in the same layer get affected by values written early.
- Taking the first color to arrive instead of the largest on a conflict.

## Interview Explanation

I run a multi-source BFS starting with every source in the queue. Because spreading is simultaneous, I process one full layer at a time: collect the empty cells reached in this layer, keeping the largest color per cell, and only at the end of the layer write them to the grid and push them. Each cell is colored once, so time is `O(nm)`.
