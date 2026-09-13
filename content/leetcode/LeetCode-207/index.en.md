---
title: "LeetCode 207: Course Schedule"
summary: "LeetCode Problem Solving - Topological Sort (Kahn's BFS) Key insight: If a valid topological ordering exists → no cycle → return true Approach: Build adjacency list + indegree array. Add all nodes with indegree 0 to queue. Process queue —"
description: "LeetCode study note from 2026-04-08"
date: 2026-04-08
tags: ["leetcode", "medium", "graph", "topological-sort"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-04-08
Source Note: `notes/day1-topological-sort-osi-model.md`

## Intuition

Pattern: Topological Sort (Kahn's BFS) Key insight: If a valid topological ordering exists → no cycle → return true Approach: Build adjacency list + indegree array. Add all nodes with indegree 0 to queue. Process queue —

Pattern: Topological Sort (Kahn's BFS)

## Approach

- **Pattern:** Topological Sort (Kahn's BFS)
- **Key insight:** If a valid topological ordering exists → no cycle → return true
- **Approach:** Build adjacency list + in-degree array. Add all nodes with in-degree 0 to queue. Process queue — for each node, reduce neighbor's in-degree; if it hits 0, add to queue. If completed == numCourses → no cycle.
- **Complexity:** Time O(V+E), Space O(V+E)
- **Why deque over list:** `list.pop(0)` is O(n) — shifts all elements. `deque.popleft()` is O(1) — moves a pointer.

## Findings

- Keep the state meaning explicit before writing the transition.
- Check base cases and return value before trusting the recurrence.
- Explain why the iteration order or traversal order preserves the intended invariant.

## Encountered Problems

Captured from the learning note; no separate failure note was recorded.
