---
title: "LeetCode 802: Find Eventual Safe States"
summary: "LeetCode note for Find Eventual Safe States, rebuilt from the original learning note"
description: "Cleaned LeetCode 802 article from 2026-04-13 with note repair points and final solution"
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
Source: Day 4 learning note

## Study Context

This article is rebuilt from the exact LeetCode section in the learning note. I kept the note's repair points, comparison points, and common mistakes, while removing unrelated non-LeetCode material from the same day.

## Learning Note Extract

#### LC 802 - Find Eventual Safe States
- **Status:** Completed.
- **Pattern:** Reverse graph + remaining outdegree topo.
- **Key correction:** This is not a DAG problem. The input may contain cycles; the goal is to find nodes that are not in a cycle and cannot reach a cycle.
- **Correct model:** Build `reverse_graph[v] = predecessors that point to v`. Track `outdegree[u] = len(graph[u])`.
- **Queue initialization:** Start with terminal nodes where `outdegree == 0`.
- **Propagation:** When a safe node is processed, decrement the remaining outdegree of its predecessors. If a predecessor reaches 0, all of its outgoing paths lead to safe nodes, so it is safe.
- **Naming issue fixed:** The counter is `outdegree`, not `in_degree`. Calling it `in_degree` is misleading even if the code passes.
- **Complexity:** O(V + E) if returning by final scan; O(V + E + V log V) if sorting result.


## Organized Notes

The note's intended solution is reverse-graph topological trimming. Terminal nodes are safe immediately. When a node is proven safe, each predecessor has one fewer outgoing edge that could lead to danger; when all of a predecessor's outgoing edges have been proven safe, that predecessor becomes safe too. This is different from ordinary DAG detection because the input may contain cycles, and the output is the sorted list of nodes that cannot reach any cycle.

## Clean Solution

The note above captures the reverse-graph model from the original repair. The implementation below follows that model directly.

```python
from collections import deque
from typing import List

class Solution:
    def eventualSafeNodes(self, graph: List[List[int]]) -> List[int]:
        n = len(graph)
        reverse_graph = [[] for _ in range(n)]
        outdegree = [0] * n

        for node, neighbors in enumerate(graph):
            outdegree[node] = len(neighbors)
            for nei in neighbors:
                reverse_graph[nei].append(node)

        q = deque(i for i in range(n) if outdegree[i] == 0)
        safe = [False] * n

        while q:
            node = q.popleft()
            safe[node] = True
            for prev in reverse_graph[node]:
                outdegree[prev] -= 1
                if outdegree[prev] == 0:
                    q.append(prev)

        return [i for i, ok in enumerate(safe) if ok]
```


## Complexity

Time O(V+E), Space O(V).

## Mistakes To Watch

- Only checking immediate outgoing edges.
- Forgetting a node with no outgoing edges is safe.

## Final Interview Explanation

I would solve this by proving safety backward from terminal nodes. A node is safe once every outgoing edge leads to an already-safe node. Reverse edges let each newly safe node reduce its predecessors' remaining outdegree; when that count hits zero, the predecessor is safe too.
