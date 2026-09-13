---
title: "LeetCode 802: Find Eventual Safe States"
summary: "LeetCode Problem Solving - Reverse graph + remaining outdegree topo. Key correction: This is not a DAG problem. The input may contain cycles; the goal is to find nodes that are not in a cycle and cannot reach a cycle. Correct model: Build"
description: "LeetCode study note from 2026-04-13"
date: 2026-04-13
tags: ["medium", "graph", "topological-sort"]
categories: ["leetcode"]
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

Pattern: Reverse graph + remaining outdegree topo. Key correction: This is not a DAG problem. The input may contain cycles; the goal is to find nodes that are not in a cycle and cannot reach a cycle. Correct model: Build

Pattern: Reverse graph + remaining outdegree topo

## Approach

- **Pattern:** Reverse graph + remaining outdegree topo.
- **Key correction:** This is not a DAG problem. The input may contain cycles; the goal is to find nodes that are not in a cycle and cannot reach a cycle.
- **Correct model:** Build `reverse_graph[v] = predecessors that point to v`. Track `outdegree[u] = len(graph[u])`.
- **Queue initialization:** Start with terminal nodes where `outdegree == 0`.
- **Propagation:** When a safe node is processed, decrement the remaining outdegree of its predecessors. If a predecessor reaches 0, all of its outgoing paths lead to safe nodes, so it is safe.
- **Naming issue fixed:** The counter is `outdegree`, not `in_degree`. Calling it `in_degree` is misleading even if the code passes.
- **Complexity:** O(V + E) if returning by final scan; O(V + E + V log V) if sorting result.

## Findings

- Keep the state meaning explicit before writing the transition.
- Check base cases and return value before trusting the recurrence.
- Explain why the iteration order or traversal order preserves the intended invariant.

## Encountered Problems

Completed.
