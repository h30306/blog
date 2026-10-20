---
title: "LeetCode 2608: Shortest Cycle in a Graph"
summary: "LeetCode 2608 note: BFS from every node; a visited neighbor that is not the parent closes a cycle of length dist[u] + dist[v] + 1"
description: "LeetCode 2608 record from 2026-09-16"
date: 2026-09-16
tags: ["hard", "bfs", "graph"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-09-16
- Submissions: Wrong Answer → Memory Limit Exceeded → Accepted

## Approach

Find the shortest cycle in an undirected graph. With `n, m <= 1000`, **one BFS from every node** is affordable.

During a BFS from `s`, record each node's distance `dist` and where it came from (its parent). If, from `u`, you see a neighbor `v` that is **already visited and is not `u`'s parent**, two paths from `s` meet across the edge `u-v` and form a cycle of length at most `dist[u] + dist[v] + 1`.

That length is not always exactly a cycle's length (the two paths may merge before reaching `s`), but it is an upper bound on some cycle, and a BFS started on the shortest cycle itself computes its exact length. So the minimum over all starts and all such edges is the answer.

## My Attempts

### Wrong Answer: traversed edges as state

The first BFS state was `(length, current node, bitmask of traversed edges)`, trying to find paths that return to a node without reusing an edge. Besides being far too heavy, the bit test was wrong:

```python
if not (visited_edge >> edge):            # should be (visited_edge >> edge) & 1
```

`visited_edge >> edge` is truthy whenever any bit higher than `edge` is set, not only bit `edge`.

### Memory Limit Exceeded: the state space exploded

With the bit test fixed, every path carried its own edge mask, so the same node was pushed with a huge number of different masks and memory ran out.

The final version used the standard approach: one BFS per node, tracking only distance and parent.

## Solution

```python
from collections import defaultdict, deque

class Solution:
    def findShortestCycle(self, n: int, edges: List[List[int]]) -> int:
        adj = defaultdict(list)
        for u, v in edges:
            adj[u].append(v)
            adj[v].append(u)

        best = float("inf")
        for s in range(n):
            dist = [-1] * n
            dist[s] = 0
            q = deque([(s, -1)])
            while q:
                u, parent = q.popleft()
                for v in adj[u]:
                    if dist[v] == -1:
                        dist[v] = dist[u] + 1
                        q.append((v, u))
                    elif v != parent:
                        best = min(best, dist[u] + dist[v] + 1)
        return -1 if best == float("inf") else best
```

## Complexity

Time `O(n · (n + m))`, space `O(n + m)`.

## Mistakes to Avoid

- Using the set of traversed edges as state: the number of states is exponential.
- Testing a bit without `& 1`.
- Counting the parent as a cycle: in an undirected graph every edge is seen from both ends, so exclude the edge just used.

## Interview Explanation

I run one BFS from every node, tracking distance and parent. A visited neighbor that is not the parent means two paths meet across that edge, forming a cycle of length `dist[u] + dist[v] + 1`. A BFS started on the shortest cycle gets its exact length, so the minimum over everything is the answer. That is `n` BFS runs, `O(n(n + m))` time.
