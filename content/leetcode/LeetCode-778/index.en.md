---
title: "LeetCode 778: Swim in Rising Water"
summary: "LeetCode note for Swim in Rising Water, rebuilt from the original learning note"
description: "Cleaned LeetCode 778 article from 2026-04-18 with note repair points and final solution"
date: 2026-04-18
tags: ["hard", "graph", "dijkstra", "binary-search"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-04-18
Source: Day 7 learning note

## Study Context

This article is rebuilt from the exact LeetCode section in the learning note. I kept the note's repair points, comparison points, and common mistakes, while removing unrelated non-LeetCode material from the same day.

## Related Reminders From The Note

- 1. Explain why LC 778 is a Dijkstra variant.

## Learning Note Extract

#### Problem 1 - LC 778 Swim in Rising Water
- **Status:** Completed; prefer direct Dijkstra wording in interviews.
- **Pattern:** Dijkstra variant on grid.
- **Graph type:** Grid graph; each cell is a node.
- **Path cost:** Maximum elevation value along the path.
- **State in heap:** `(time_required, row, col)`.
- **Return condition:** Return when bottom-right cell is popped from heap.

#### Interview-Ready Explanation
This is a shortest-path problem on a grid graph. The cost of a path is the maximum elevation value of any cell on that path, because at time `t`, I can only enter cells with elevation `<= t`. Dijkstra works because when I extend a path to a neighbor, the new cost is `max(current_time, grid[nr][nc])`, so the path cost never decreases. I store `(time_required, row, col)` in a min-heap. When a cell is popped for the first time, its minimum required time is finalized. When the destination is popped, I return that time.

#### Preferred Implementation Detail
Prefer pushing the full path cost:
```python
new_time = max(time, grid[nr][nc])
heappush(heap, (new_time, nr, nc))
```

This matches the Dijkstra explanation directly.

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

```python
from heapq import heappop, heappush
from typing import List

class Solution:
    def swimInWater(self, grid: List[List[int]]) -> int:
        n = len(grid)
        seen = [[False] * n for _ in range(n)]
        heap = [(grid[0][0], 0, 0)]
        dirs = [(1,0), (-1,0), (0,1), (0,-1)]

        while heap:
            time, r, c = heappop(heap)
            if seen[r][c]:
                continue
            seen[r][c] = True
            if (r, c) == (n - 1, n - 1):
                return time
            for dr, dc in dirs:
                nr, nc = r + dr, c + dc
                if 0 <= nr < n and 0 <= nc < n and not seen[nr][nc]:
                    heappush(heap, (max(time, grid[nr][nc]), nr, nc))
        return -1
```

## Complexity

Time O(n^2 log n), Space O(n^2).

## Mistakes To Watch

- Summing elevations.
- Using plain BFS despite different required times.

## Final Interview Explanation

Start from the state definition, then explain why the transition preserves that state. If there is a loop direction, state compression, or a similar-looking problem with a different answer shape, call that out explicitly because that is where this problem family usually breaks down.
