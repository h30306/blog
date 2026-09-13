---
title: "LeetCode 787: Cheapest Flights Within K Stops"
summary: "LeetCode note for Cheapest Flights Within K Stops, rebuilt from the original learning note"
description: "Cleaned LeetCode 787 article from 2026-04-25 with note repair points and final solution"
date: 2026-04-25
tags: ["medium", "graph", "bellman-ford", "shortest-path"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-04-25
Source: Day 11 learning note

## Study Context

This article is rebuilt from the exact LeetCode section in the learning note. I kept the note's repair points, comparison points, and common mistakes, while removing unrelated non-LeetCode material from the same day.

## Related Reminders From The Note

- 5. Explain why `LC 787` cannot use plain `visited = set(city)`.

## Learning Note Extract

#### Problem 3 - LC 787 Cheapest Flights Within K Stops Review
- **Status:** Partial repair only; full Bellman-Ford practice deferred.
- **Current understanding:** Plain Dijkstra with `visited = set(city)` is wrong.

#### Why Plain `visited = set(city)` Is Wrong
The state is not only the city.

Reaching the same city with:
```text
lower price but too many stops
```

can be worse than:
```text
higher price but fewer stops used
```

because the second route may leave enough stop budget for a cheaper final path.

So the state must include:
```text
(city, stops_used)
```

or:
```text
(city, edges_used)
```

#### Week 3 Decision
Do not force Bellman-Ford learning in a rushed way.

Move full Bellman-Ford intro and full `LC 787` practice to:
```text
Week 3 Weekend Day 2
```

## Organized Notes

The note correctly flags the trap: city-only `visited` is not a valid Dijkstra pruning key because remaining stop budget is part of the state. A robust interview answer is Bellman-Ford by edge count. With at most `k` stops, the path may use at most `k + 1` flights, so we relax all flights exactly `k + 1` rounds. Each round reads from the previous distance array and writes to a copied array, which prevents one round from using more than one extra flight.

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

```python
from typing import List

class Solution:
    def findCheapestPrice(self, n: int, flights: List[List[int]], src: int, dst: int, k: int) -> int:
        inf = float('inf')
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

## Complexity

Time O((K+1)*E), Space O(V).

## Mistakes To Watch

- Using city-only visited in Dijkstra and pruning cheaper paths with more stops incorrectly.
- Doing K rather than K+1 edge layers.

## Final Interview Explanation

I would frame this as shortest path with an edge-count limit. Since at most `k` stops means at most `k + 1` flights, I relax all flights for `k + 1` layers. Copying the previous distance array each layer guarantees each round uses only one additional flight.
