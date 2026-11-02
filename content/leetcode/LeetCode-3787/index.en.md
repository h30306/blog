---
title: "LeetCode 3787: Find Diameter Endpoints of a Tree"
summary: "LeetCode 3787 note: two BFS passes find one diameter's ends A and B; every node's farthest node is A or B, so a node is a diameter endpoint exactly when max(dist(A,i), dist(B,i)) equals the diameter"
description: "LeetCode 3787 record from 2026-10-22"
date: 2026-10-22
tags: ["medium", "tree", "breadth-first-search", "graph"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-10-22
- Submissions: Accepted (first try)

## Approach

Mark every node that is an endpoint of **some** diameter. A tree can have many diameters, so finding one is not enough.

First find one diameter with two BFS passes ([Tree]({{< relref "/algorithm/Tree" >}}) Template 5):

1. BFS from any node (0); the farthest node `A` is an endpoint of some diameter.
2. BFS from `A`; the farthest node `B` is the other end, and `dist(A, B)` is the diameter `D`.

Key fact: **for every node in a tree, a farthest node can be taken to be `A` or `B`**. So node `i`'s eccentricity is `max(dist(A, i), dist(B, i))`.

Node `i` is an endpoint of some diameter exactly when its eccentricity equals `D`. So BFS from `A` and from `B` and check `max(dA[i], dB[i]) == D`.

## My Attempts

Accepted on the first try.

## Solution

```python
class Solution:
    def findSpecialNodes(self, n: int, edges: List[List[int]]) -> str:
        graph = [[] for _ in range(n)]
        for u, v in edges:
            graph[u].append(v)
            graph[v].append(u)

        def bfs(s):
            dist = [-1] * n
            dist[s] = 0
            queue = deque([s])
            while queue:
                node = queue.popleft()
                for nei in graph[node]:
                    if dist[nei] < 0:
                        dist[nei] = dist[node] + 1
                        queue.append(nei)
            return dist

        d0 = bfs(0)
        a = d0.index(max(d0))
        dA = bfs(a)
        b = dA.index(max(dA))
        dB = bfs(b)
        diameter = dA[b]
        return "".join("1" if max(dA[i], dB[i]) == diameter else "0" for i in range(n))
```

## Complexity

Three BFS passes: time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- The diameter is not unique; marking only `A` and `B` misses endpoints of other diameters.
- With a single node the diameter is 0 and that node is an endpoint; the formula still holds.

## Interview Explanation

Two BFS passes give one diameter's ends `A` and `B` and its length `D`. In a tree, a farthest node from any node can be chosen as `A` or `B`, so each node's eccentricity is the larger of its distances to `A` and `B`; the nodes where that equals `D` are exactly the diameter endpoints. Three BFS passes, `O(n)` time.
