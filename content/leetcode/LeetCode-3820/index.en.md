---
title: "LeetCode 3820: Pythagorean Distance Nodes in a Tree"
summary: "LeetCode 3820 note: three BFS runs give every node's distance to the three targets"
description: "LeetCode 3820 record from 2026-01-25"
date: 2026-01-25
tags: ["medium", "tree", "bfs", "graph"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-25
- Submissions: Accepted (first try)

## Approach

Every node needs its distances to `x`, `y`, and `z`. Instead of one BFS per node, **run one BFS from each of the three targets**; each run gives every node's distance to that target.

A tree has exactly one path between two nodes, so the BFS step count is the distance.

Finally, for each node, sort the three distances and check `a² + b² == c²`.

## My Solution

```python
from collections import deque

class Solution:
    def specialNodes(self, n: int, edges: List[List[int]], x: int, y: int, z: int) -> int:
        graph = [[] for _ in range(n)]
        for u, v in edges:
            graph[u].append(v)
            graph[v].append(u)

        def bfs(start):
            dist = [-1] * n
            dist[start] = 0
            q = deque([start])
            while q:
                u = q.popleft()
                for v in graph[u]:
                    if dist[v] == -1:
                        dist[v] = dist[u] + 1
                        q.append(v)
            return dist

        dx, dy, dz = bfs(x), bfs(y), bfs(z)

        count = 0
        for i in range(n):
            a, b, c = sorted((dx[i], dy[i], dz[i]))
            if a * a + b * b == c * c:
                count += 1
        return count
```

## Complexity

Time `O(n)`: three BFS runs plus one scan. Space `O(n)`.

## Mistakes to Avoid

- Running BFS from every node, which is `O(n^2)`.
- Adding edges in one direction only: tree edges are undirected.
- Forgetting to sort: `c` in the Pythagorean check must be the largest.

## Interview Explanation

I need each node's distance to three targets, so I flip it around and run one BFS from each target, getting three distance arrays. Paths in a tree are unique, so BFS steps equal distances. For each node I sort its three distances and check whether the squares of the two smaller ones add up to the square of the largest. Three BFS runs, so time is `O(n)`.
