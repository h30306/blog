---
title: "LeetCode 2192: All Ancestors of a Node in a DAG"
summary: "LeetCode Problem Solving - Graph traversal — DFS from each source OR BFS (Kahn's) with set propagation Key insight: Ancestors are transitive — if 0→1→3, then 0 is an ancestor of 3 DFS approach: For each src node (0 to n1), run DFS and add"
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
Source Note: `notes/day2-topological-sort-dag-union-find-dns-http.md`

## Intuition

Pattern: Graph traversal — DFS from each source OR BFS (Kahn's) with set propagation Key insight: Ancestors are transitive — if 0→1→3, then 0 is an ancestor of 3 DFS approach: For each src node (0 to n1), run DFS and add

Pattern: Graph traversal — DFS from each source OR BFS (Kahn's) with set propagation

## Approach

- **Pattern:** Graph traversal — DFS from each source OR BFS (Kahn's) with set propagation
- **Key insight:** Ancestors are transitive — if 0→1→3, then 0 is an ancestor of 3
- **DFS approach:** For each `src` node (0 to n-1), run DFS and add `src` to every reachable node's ancestor list. Use a fresh `visited` set per DFS to prevent duplicates. Result is auto-sorted because src iterates in order.
- **Common bugs:**
  1. Shared `visited` set across DFS calls — resets nothing, later sources find all nodes already visited
  2. Appending current `node` instead of `src` — only adds direct parent, not transitive ancestors
  3. Appending before visited check — causes duplicate ancestors in diamond-shaped paths

- **BFS approach (optimal):** Use Kahn's topological sort. For each node, `ancestors[neighbor] |= ancestors[node]`. Topological ordering guarantees all ancestors are fully computed before propagating. Uses sets to handle duplicates automatically.
- **Why BFS is faster:** DFS runs V separate traversals = O(V×(V+E)). BFS processes each node once = O(V+E) traversal + set union cost. Single pass, no redundant traversals.
- **Time complexity (BFS):** O(V² log V) — set union O(V²) + final sort O(V² log V)

## Findings

- Keep the state meaning explicit before writing the transition.
- Check base cases and return value before trusting the recurrence.
- Explain why the iteration order or traversal order preserves the intended invariant.

## Encountered Problems

Captured from the learning note; no separate failure note was recorded.
