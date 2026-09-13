---
title: "Shortest Path"
summary: "Dijkstra, minimax paths, and Bellman-Ford with edge limits"
description: "Algorithm Learning"
date: 2026-09-13
tags: ["graph", "shortest-path", "dijkstra", "bellman-ford"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Introduction

Shortest path problems ask for the cheapest way to reach nodes in a graph. The main decision is which path model fits the constraints:

- unweighted graph: BFS
- non-negative weighted graph: Dijkstra
- edge-count limit or negative-edge support: Bellman-Ford style DP
- grid with non-sum path cost: Dijkstra can still work if path cost is monotonic

## Dijkstra

Dijkstra works when extending a path never makes the path cost smaller. In normal weighted graphs, the path cost is a sum of non-negative edges.

```python
from collections import defaultdict
from heapq import heappop, heappush
from typing import List

def dijkstra(n: int, edges: List[List[int]], src: int) -> List[float]:
    graph = defaultdict(list)
    for u, v, w in edges:
        graph[u].append((v, w))

    dist = [float("inf")] * n
    dist[src] = 0
    heap = [(0, src)]

    while heap:
        cost, node = heappop(heap)
        if cost != dist[node]:
            continue
        for nei, weight in graph[node]:
            new_cost = cost + weight
            if new_cost < dist[nei]:
                dist[nei] = new_cost
                heappush(heap, (new_cost, nei))

    return dist
```

## Minimax Dijkstra

Some graph problems do not sum edge weights. For example, a path's effort might be the maximum edge effort used so far:

```text
new_effort = max(current_effort, edge_effort)
```

Dijkstra still works because the path cost is monotonic: extending a path cannot reduce the effort already paid.

## Bellman-Ford With K Stops

When a problem limits the number of edges, state must include the number of flights or layers used. For `k` stops, at most `k + 1` flights are allowed.

```python
from typing import List

def cheapest_with_k_stops(n: int, flights: List[List[int]], src: int, dst: int, k: int) -> int:
    inf = float("inf")
    dist = [inf] * n
    dist[src] = 0

    for _ in range(k + 1):
        ndist = dist[:]
        for u, v, price in flights:
            if dist[u] != inf and dist[u] + price < ndist[v]:
                ndist[v] = dist[u] + price
        dist = ndist

    return -1 if dist[dst] == inf else dist[dst]
```

The copied array is important: one round should represent exactly one additional edge.

## Common Mistakes

- Using BFS on weighted graphs.
- Saying the answer is the longest path instead of the maximum shortest arrival time.
- Using city-only `visited` when remaining stops are part of the state.
- Summing path costs when the real cost is a maximum along the path.
- Forgetting stale heap entries in Dijkstra.

## Related LeetCode

- `LC 743` Network Delay Time
- `LC 778` Swim in Rising Water
- `LC 787` Cheapest Flights Within K Stops
- `LC 1631` Path With Minimum Effort
