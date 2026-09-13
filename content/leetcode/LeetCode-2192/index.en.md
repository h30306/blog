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

#### LC 2192 — All Ancestors of a Node in a DAG
- **Pattern:** Graph traversal — DFS from each source OR BFS (Kahn's) with set propagation
- **Key insight:** Ancestors are transitive — if 0→1→3, then 0 is an ancestor of 3
- **DFS approach:** For each `src` node (0 to n-1), run DFS and add `src` to every reachable node's ancestor list. Use a fresh `visited` set per DFS to prevent duplicates. Result is auto-sorted because src iterates in order.
- **Common bugs:**
  1. Shared `visited` set across DFS calls — resets nothing, later sources find all nodes already visited
  2. Appending current `node` instead of `src` — only adds direct parent, not transitive ancestors
  3. Appending before visited check — causes duplicate ancestors in diamond-shaped paths

- **BFS approach (optimal):** Use Kahn's topological sort. For each node, `ancestors[neighbor] |= ancestors[node]`. Topological ordering guarantees all ancestors are fully computed before propagating. Uses sets to handle duplicates automatically.
- **Why BFS is faster:** DFS runs V separate traversals = O(V×(V+E)). BFS processes each node once = O(V+E) traversal + set union cost. Single pass, no redundant traversals.
- **Time complexity (BFS):** O(V² log V) — set union O(V²) + final sort O(V² log V)

#### LC 1971 — Find if Path Exists in Graph
- **Pattern:** BFS/DFS OR Union-Find
- **Critical:** This is an **undirected** graph — add both directions when building adjacency list
- **BFS approach:** Standard BFS from source. Return true if destination is reached.
- **Union-Find approach:** Group all connected nodes. Return `find(source) == find(destination)`
- **Common bugs:**
  1. Building directed adjacency list for undirected graph
  2. Applying Kahn's in-degree logic to undirected graph — in-degree is meaningless here
  3. Never calling `union` on edges — nodes stay in separate components
  4. Calling `union(x, y)` with raw nodes instead of roots `union(find(x), find(y))`
  5. Wrong rank increment — only increment when two trees of equal rank merge

- **Union-Find template:**
```python
parent = [i for i in range(n)]
rank = [0] * n

def find(x):
    if parent[x] != x:
        parent[x] = find(parent[x])  # path compression
    return parent[x]

def union(x, y):
    rx, ry = find(x), find(y)
    if rx == ry:
        return
    if rank[rx] > rank[ry]:
        parent[ry] = rx
    elif rank[rx] < rank[ry]:
        parent[rx] = ry
    else:
        parent[rx] = ry
        rank[ry] += 1
```

- **Trade-off:** BFS = simpler, good for single query. Union-Find = better for multiple path queries on same graph (near O(1) per query after O(V+E) build).

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

Start from the state definition, then explain why the transition preserves that state. If there is a loop direction, state compression, or a similar-looking problem with a different answer shape, call that out explicitly because that is where this problem family usually breaks down.
