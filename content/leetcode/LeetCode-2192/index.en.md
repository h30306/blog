---
title: "LeetCode 2192: All Ancestors of a Node in a DAG"
summary: "LeetCode note for All Ancestors of a Node in a DAG, rebuilt from the original learning note"
description: "Cleaned LeetCode 2192 article from 2026-04-08 with note repair points and final solution"
date: 2026-04-08
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
First Attempt: 2026-04-08
Source: Day 2 learning note

## Study Context

This article is rebuilt from the exact LeetCode section in the learning note. I kept the note's repair points, comparison points, and common mistakes, while removing unrelated non-LeetCode material from the same day.

## Learning Note Extract

#### LC 2192 - All Ancestors of a Node in a DAG
- **Pattern:** Graph traversal - DFS from each source OR BFS with Kahn's topological order and set propagation.
- **Key insight:** Ancestors are transitive. If `0 -> 1 -> 3`, then `0` is also an ancestor of `3`.
- **DFS approach:** For each `src` node, run DFS and add `src` to every reachable node's ancestor list. Use a fresh `visited` set per DFS to prevent duplicates. Result is naturally sorted because `src` iterates in order.
- **Common bugs:** Shared `visited` set across DFS calls, appending current `node` instead of original `src`, and appending before a visited check.
- **BFS approach:** Use Kahn's topological sort. For each edge `node -> neighbor`, propagate `ancestors[node]` plus `node` into `ancestors[neighbor]`. Topological order guarantees each node's ancestors are computed before it propagates.
- **Why BFS is faster:** DFS repeats traversal from many sources. Kahn propagation processes graph edges once, with set-union cost.
- **Time complexity (BFS):** O(V^2 + E) for propagation in the worst case, plus O(V^2 log V) if sorting large ancestor lists.


## Organized Notes

This article should stay on transitive ancestors in a DAG. The Kahn solution works because once a node is popped, every ancestor that can reach it through earlier nodes has already been accumulated. For each edge `u -> v`, add `u` and all of `u`'s ancestors into `v`'s set. Sorting happens only at the end, which keeps the propagation logic simple and avoids duplicate ancestor entries.

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

```python
from collections import deque
from typing import List

class Solution:
    def getAncestors(self, n: int, edges: List[List[int]]) -> List[List[int]]:
        graph = [[] for _ in range(n)]
        indeg = [0] * n
        ancestors = [set() for _ in range(n)]

        for u, v in edges:
            graph[u].append(v)
            indeg[v] += 1

        q = deque(i for i in range(n) if indeg[i] == 0)
        while q:
            u = q.popleft()
            for v in graph[u]:
                ancestors[v].add(u)
                ancestors[v].update(ancestors[u])
                indeg[v] -= 1
                if indeg[v] == 0:
                    q.append(v)

        return [sorted(a) for a in ancestors]
```

## Complexity

Time O(n^2 + e) in worst case, Space O(n^2).

## Mistakes To Watch

- Doing DFS from every node without controlling duplicate work.
- Forgetting sorted output.

## Final Interview Explanation

I would process the DAG in topological order and propagate ancestor sets forward. For every edge `u -> v`, `u` and all ancestors of `u` are ancestors of `v`. Topological order makes sure the set for `u` is complete before it is merged into `v`.
