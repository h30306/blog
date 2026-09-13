---
title: "LeetCode 778: Swim in Rising Water"
summary: "LeetCode Problem Solving - Dijkstra variant on grid"
description: "LeetCode study note from 2026-04-18"
date: 2026-04-18
tags: ["leetcode", "hard", "graph", "dijkstra", "binary-search"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-04-18
Source Note: `notes/day7-week2-dijkstra-http.md`

## Intuition

This is a shortestpath problem on a grid graph. The cost of a path is the maximum elevation value of any cell on that path, because at time t, I can only enter cells with elevation <= t. Dijkstra works because when I ext

Pattern: Dijkstra variant on grid

## Approach

- **Pattern:** Dijkstra variant on grid.
- **Graph type:** Grid graph; each cell is a node.
- **Path cost:** Maximum elevation value along the path.
- **State in heap:** `(time_required, row, col)`.
- **Return condition:** Return when bottom-right cell is popped from heap.

## Interview-Ready Explanation
This is a shortest-path problem on a grid graph. The cost of a path is the maximum elevation value of any cell on that path, because at time `t`, I can only enter cells with elevation `<= t`. Dijkstra works because when I extend a path to a neighbor, the new cost is `max(current_time, grid[nr][nc])`, so the path cost never decreases. I store `(time_required, row, col)` in a min-heap. When a cell is popped for the first time, its minimum required time is finalized. When the destination is popped, I return that time.

## Preferred Implementation Detail
Prefer pushing the full path cost:
```python
new_time = max(time, grid[nr][nc])
heappush(heap, (new_time, nr, nc))
```

This matches the Dijkstra explanation directly.

## Findings

- Keep the state meaning explicit before writing the transition.
- Check base cases and return value before trusting the recurrence.
- Explain why the iteration order or traversal order preserves the intended invariant.

## Encountered Problems

Completed; prefer direct Dijkstra wording in interviews.
