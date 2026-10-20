---
title: "LeetCode 1514: Path with Maximum Probability"
summary: "LeetCode 1514 note: multiplying probabilities only shrinks them, so Dijkstra applies; prune with <="
description: "LeetCode 1514 record from 2026-04-17"
date: 2026-04-17
tags: ["medium", "graph", "dijkstra", "shortest-path", "heap"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-04-17
- Submissions: Wrong Answer ×2 → Memory Limit Exceeded ×2 → Accepted → Accepted (rewritten on 2026-04-27)

## Approach

Find the path from `start` to `end` with the highest success probability; a path's probability is the product of its edge probabilities.

Why Dijkstra works: it needs paths to only get worse as they grow, i.e. non-negative edge weights. Here every edge probability is in `[0, 1]`, so **multiplying can only keep or shrink the value**, which is the same property. Push negated probabilities into a min-heap and always expand the node with the highest probability; **the first time `end` is popped, that is the answer**.

## My Attempts

1. **Starting from node 0**: `pq = [(-1, 0)]` hard-coded 0 instead of `start_node`.
2. **Returning the wrong variable at `end`**: `return res`, which still held its initial value.
3. **Memory Limit Exceeded**: the pruning used `<`:

    ```python
    if nn in visited and visited[nn] < prob * np:
        continue
    ```

    The stored probabilities are negated, so `visited[nn] < prob * np` means "something better is already known". But **equally good** states were not pruned, so the same node kept being pushed and memory blew up. Switching to `<=` passed.

4. Ten days later I rewrote it as standard Dijkstra: with a `visited` set, a node's answer is final the first time it is popped, and later copies are skipped.

## Solution

```python
import heapq
from collections import defaultdict

class Solution:
    def maxProbability(self, n: int, edges: List[List[int]], succProb: List[float],
                       start_node: int, end_node: int) -> float:
        adj = defaultdict(list)
        for (u, v), p in zip(edges, succProb):
            adj[u].append((v, p))
            adj[v].append((u, p))

        best = [0.0] * n
        best[start_node] = 1.0
        heap = [(-1.0, start_node)]
        while heap:
            neg_p, u = heapq.heappop(heap)
            p = -neg_p
            if u == end_node:
                return p
            if p < best[u]:
                continue                         # stale entry
            for v, w in adj[u]:
                if p * w > best[v]:              # push only on strict improvement
                    best[v] = p * w
                    heapq.heappush(heap, (-best[v], v))
        return 0.0
```

With a `best` array and **pushing only on strict improvement**, equally good states are never pushed twice.

## Complexity

Time `O(E log V)`, space `O(V + E)`.

## Mistakes to Avoid

- Hard-coding the start as node 0.
- Pruning with `<`: equally good states are pushed over and over.
- Treating it as a shortest path and adding probabilities: they must be multiplied.
- Converting to `-log(p)` turns it into an additive shortest path, but the floating-point error is larger than multiplying directly, so there is no need.

## Interview Explanation

A path's probability is the product of its edges, and each edge is at most 1, so longer paths can only get less likely, which is the property Dijkstra needs. I use a max-heap (negated probabilities) to always expand the most likely node, updating and pushing a neighbor only when its probability strictly improves. The first time the end node is popped is the answer; if it is never reached, return 0. Time `O(E log V)`.
