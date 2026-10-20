---
title: "LeetCode 323: Number of Connected Components in an Undirected Graph"
summary: "LeetCode 323 note: count components with DFS or Union-Find; Union-Find without path compression is much slower"
description: "LeetCode 323 record from 2026-08-31"
date: 2026-08-31
tags: ["medium", "graph", "dfs", "bfs", "union-find"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-08-31
- Submissions: Accepted (Union-Find, 417ms) → Accepted (DFS, 11ms)

## Approach

The classic connected-components problem, with two approaches:

- **DFS / BFS**: from every unvisited node, walk its whole component and count one.
- **Union-Find**: each edge unions its endpoints; count the distinct roots at the end.

## My Attempt: Union-Find without path compression

```python
def find(x):
    rootX = parent[x]
    if x != rootX:
        return find(rootX)          # walks up but never compresses the path
    return rootX
```

`find` just climbs to the root and **never links visited nodes directly to the root**. The tree can degrade into a chain, making each `find` `O(n)`. This version took 417ms; DFS took 11ms.

Path compression is one line: `parent[x] = find(parent[x])`.

## Solution

### DFS (iterative with a stack)

```python
from collections import defaultdict

class Solution:
    def countComponents(self, n: int, edges: List[List[int]]) -> int:
        adj = defaultdict(list)
        for u, v in edges:
            adj[u].append(v)
            adj[v].append(u)

        seen = set()
        count = 0
        for start in range(n):
            if start in seen:
                continue
            count += 1
            seen.add(start)
            stack = [start]
            while stack:
                u = stack.pop()
                for v in adj[u]:
                    if v not in seen:
                        seen.add(v)
                        stack.append(v)
        return count
```

My original DFS was recursive; with `n <= 2000`, a chain reaches 2000 levels, past Python's default recursion limit, so an explicit stack is safer.

### Union-Find (with path compression)

```python
class Solution:
    def countComponents(self, n: int, edges: List[List[int]]) -> int:
        parent = list(range(n))

        def find(x: int) -> int:
            if parent[x] != x:
                parent[x] = find(parent[x])
            return parent[x]

        components = n
        for u, v in edges:
            ru, rv = find(u), find(v)
            if ru != rv:
                parent[ru] = rv
                components -= 1          # each real merge removes one component
        return components
```

Every merge of two different components reduces the count by one, so there is no final pass to count roots.

## Complexity

DFS: `O(n + m)`. Union-Find with path compression: nearly `O(n + m)`.

## Mistakes to Avoid

- Union-Find without path compression.
- Recursive DFS exceeding the recursion limit on a long chain.
- Adding edges in only one direction.

## Interview Explanation

I build an undirected adjacency list and, from every unvisited node, run a stack-based DFS over its whole component; each new start is a new component, in `O(n + m)` time. Union-Find also works: start at `n` components and subtract one whenever two different roots merge, with path compression so `find` does not degrade to `O(n)`.
