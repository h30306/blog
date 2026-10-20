---
title: "LeetCode 3313: Find the Last Marked Nodes in Tree"
summary: "LeetCode 3313 note: the last marked node is the farthest one, and a farthest node can always be a diameter endpoint"
description: "LeetCode 3313 record from 2026-09-17"
date: 2026-09-17
tags: ["hard", "tree", "bfs", "graph", "tree-diameter"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-09-17
- Submissions: Accepted (first try)

## Approach

Starting from node `i`, marking every adjacent node each second is a BFS wave. **The last node marked is the node farthest from `i`.**

One BFS per node is `O(n^2)`, which times out at `n = 10^5`.

Key fact: **for any node, at least one of the diameter endpoints `u`, `v` is a farthest node from it.** So:

1. BFS from any node to find the farthest node `u`.
2. BFS from `u` to find the farthest node `v`; `u` and `v` are the diameter endpoints.
3. BFS once more from `v`.
4. For each node `i`, compare `dist_u[i]` and `dist_v[i]`; the farther endpoint is the answer.

## My Solution

```python
from collections import defaultdict, deque

class Solution:
    def lastMarkedNodes(self, edges: List[List[int]]) -> List[int]:
        n = len(edges) + 1
        adj = defaultdict(list)
        for u, v in edges:
            adj[u].append(v)
            adj[v].append(u)

        def bfs(start):
            dist = [-1] * n
            dist[start] = 0
            q = deque([start])
            while q:
                node = q.popleft()
                for nei in adj[node]:
                    if dist[nei] == -1:
                        dist[nei] = dist[node] + 1
                        q.append(nei)
            return node, dist                  # the last popped node is the farthest

        u, _ = bfs(0)
        v, dist_u = bfs(u)
        _, dist_v = bfs(v)
        return [u if dist_u[i] > dist_v[i] else v for i in range(n)]
```

My original version named the function `dfs` even though it ran BFS, and tracked a separate `farthest` tuple. The last node a BFS pops is already the farthest, so it can be returned directly.

## Complexity

Three BFS runs: `O(n)` time, `O(n)` space.

## Mistakes to Avoid

- Running BFS from every node, which is `O(n^2)` and times out.
- Measuring distance from only one diameter endpoint: some nodes are farther from the other one.

## Interview Explanation

Marking spreads like a BFS from `i`, so the last marked node is the farthest from `i`. For any node in a tree, a farthest node can be taken from the diameter endpoints, so two BFS runs find the endpoints `u` and `v`, and one more gives distances from both. Each node picks the farther endpoint. Three BFS runs, so time is `O(n)`.
