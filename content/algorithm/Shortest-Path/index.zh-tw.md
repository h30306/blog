---
title: "Shortest Path"
summary: "Dijkstra、minimax path 與有邊數限制的 Bellman-Ford"
description: "演算法學習"
date: 2026-09-13
tags: ["graph", "shortest-path", "dijkstra", "bellman-ford"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 介紹

Shortest path 題目是在 graph 裡找最低成本路徑。第一步要先判斷是哪一種路徑模型：

- unweighted graph：BFS
- non-negative weighted graph：Dijkstra
- 有 edge-count limit 或需要處理負邊：Bellman-Ford 類 DP
- grid 上的非加總成本：如果 path cost 單調，Dijkstra 仍然可用

## Dijkstra

Dijkstra 適用在 path 延伸後成本不會變小的情況。一般 weighted graph 裡，path cost 是非負 edge weights 的總和。

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

有些 graph 題的路徑成本不是總和。例如 path effort 是目前路徑上最大 edge effort：

```text
new_effort = max(current_effort, edge_effort)
```

Dijkstra 仍然成立，因為這個成本是 monotonic：路徑延伸後不會降低已經付出的 effort。

## Bellman-Ford With K Stops

當題目限制 edge 數量時，state 需要包含已使用的 flights/layers。`k` stops 代表最多可以用 `k + 1` flights。

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

copy array 很重要：每一輪只能代表多使用一條 edge。

## 常見錯誤

- weighted graph 還用普通 BFS。
- 把答案說成 longest path，而不是 maximum shortest arrival time。
- stops budget 是 state 的一部分，卻只用 city-only `visited`。
- 題目要的是 path 上最大值，卻把 edge weight 加總。
- Dijkstra 忘記處理 stale heap entries。

## 相關 LeetCode

- `LC 743` Network Delay Time
- `LC 778` Swim in Rising Water
- `LC 787` Cheapest Flights Within K Stops
- `LC 1631` Path With Minimum Effort
