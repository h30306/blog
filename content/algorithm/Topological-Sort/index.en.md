---
title: "Topological Sort"
summary: "Ordering, cycle detection, dependency unlocking, and graph propagation"
description: "Algorithm Learning"
date: 2026-09-13
tags: ["graph", "topological-sort", "kahn"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Introduction

Topological sort is used on directed dependency graphs. It answers questions like:

- Can all tasks be completed?
- What is one valid dependency order?
- Which nodes become available after their prerequisites are satisfied?
- How can information be propagated through a DAG?

The core interview skill is choosing the correct graph direction and explaining what the in-degree means.

## Core Idea

Kahn's algorithm keeps all nodes whose prerequisites are already satisfied:

```text
queue = all nodes with indegree 0
```

When a node is processed, it unlocks its outgoing neighbors:

```text
for nei in graph[node]:
    indegree[nei] -= 1
    if indegree[nei] == 0:
        queue.append(nei)
```

If all nodes are processed, the graph has no cycle. If some nodes remain blocked, a cycle or impossible dependency exists.

## Template

```python
from collections import deque
from typing import List

def topo_order(n: int, edges: List[List[int]]) -> List[int]:
    graph = [[] for _ in range(n)]
    indeg = [0] * n

    for pre, node in edges:
        graph[pre].append(node)
        indeg[node] += 1

    q = deque(i for i in range(n) if indeg[i] == 0)
    order = []

    while q:
        node = q.popleft()
        order.append(node)
        for nei in graph[node]:
            indeg[nei] -= 1
            if indeg[nei] == 0:
                q.append(nei)

    return order if len(order) == n else []
```

## Variants

### Cycle Detection

For `LC 207`, the return value is boolean:

```text
processed_count == numCourses
```

### Return An Ordering

For `LC 210`, the popped queue order is the topological order. Return an empty list if a cycle remains.

### Dependency Unlocking

For recipes and supplies, the queue starts from already available items, not just graph nodes with zero in-degree.

### Reverse Outdegree Trimming

For eventual safe states, safe nodes are proven backward from terminal nodes. Track remaining outdegree, not indegree.

### Two-Level Topological Sort

For grouped items, sort both item dependencies and group dependencies, then emit item buckets in group order.

## Common Mistakes

- Reversing edge direction and making the in-degree meaningless.
- Returning a partial order when a cycle remains.
- Treating an undirected graph as a topological sort problem.
- Calling an outdegree counter `in_degree` in reverse-trimming problems.
- Forgetting that propagation problems need state meaning, not just ordering.

## Related LeetCode

- `LC 207` Course Schedule
- `LC 210` Course Schedule II
- `LC 269` Alien Dictionary
- `LC 310` Minimum Height Trees
- `LC 802` Find Eventual Safe States
- `LC 851` Loud and Rich
- `LC 1203` Sort Items by Groups Respecting Dependencies
- `LC 2115` Find All Possible Recipes from Given Supplies
- `LC 2192` All Ancestors of a Node in a DAG
