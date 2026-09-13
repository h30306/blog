---
title: "LeetCode 851: Loud and Rich"
summary: "LeetCode Problem Solving - Topological BFS propagation"
description: "LeetCode study note from 2026-04-13"
date: 2026-04-13
tags: ["leetcode", "medium", "graph", "topological-sort"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-04-13
Source Note: `notes/day4-tcp-production-behavior.md`

## Intuition

Reason for replacement: LC 1203 Sort Items by Groups Respecting Dependencies is too difficult for the current point in the topo sequence and should be treated as a capstone problem. Target: Practice topo propagation on a

Pattern: Topological BFS propagation

## Approach

- **Reason for replacement:** `LC 1203 Sort Items by Groups Respecting Dependencies` is too difficult for the current point in the topo sequence and should be treated as a capstone problem.
- **Target:** Practice topo propagation on a medium-level dependency graph before attempting LC 1203.
- **Interview focus:** Choose correct graph direction and propagate the quietest richer person from richer nodes to poorer nodes.
- **Pattern:** Topological BFS propagation.
- **Graph direction:** `richer -> poorer`.
- **Why this direction:** The quietest person known for a richer node can affect every poorer node reachable from it.
- **State meaning:** `answer[i]` stores the person index of the quietest known person among people at least as rich as `i`, not the quiet value itself.
- **Update rule:** When processing `rich -> poor`, if `quiet[answer[rich]] < quiet[answer[poor]]`, set `answer[poor] = answer[rich]`.
- **Queue initialization:** Start from people with indegree 0, meaning nobody is richer than them.
- **Complexity:** O(n + richer.length), Space O(n + richer.length).

## Findings

- Keep the state meaning explicit before writing the transition.
- Check base cases and return value before trusting the recurrence.
- Explain why the iteration order or traversal order preserves the intended invariant.

## Encountered Problems

Completed.
