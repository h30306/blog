---
title: "BFS and Graph Traversal"
summary: "Connected components, grid flood fill, multi-source BFS, state-space BFS, shortest cycles, and recursion depth in DFS"
description: "Algorithm Learning"
date: 2026-10-20
tags: ["bfs", "dfs", "graph", "matrix", "union-find"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Introduction

BFS (breadth-first search) spreads out from the start one layer at a time, so **the first time it reaches a state, it has used the fewest steps** (when every step costs the same). DFS goes as deep as possible before backtracking, which suits problems like "find the whole connected component" that do not need shortest distances.

Signals:

- **Fewest steps** on an unweighted graph or grid: BFS.
- The number or size of **connected components**: BFS, DFS, or Union-Find.
- Spreading, infection, or coloring that happens **simultaneously**: multi-source BFS, one whole layer at a time.
- State beyond position (keys collected, the snake's orientation): put it into the BFS node.

## Template 1: BFS for Fewest Steps

```python
from collections import deque

q = deque([start])
dist = {start: 0}
while q:
    u = q.popleft()
    if u == target:
        return dist[u]
    for v in neighbors(u):
        if v not in dist:              # mark when pushing to avoid duplicate pushes
            dist[v] = dist[u] + 1
            q.append(v)
return -1
```

### Key Parameters:

- **Mark a node visited when pushing**, not when popping, or the same node gets pushed many times.
- BFS needs equal step costs. With different costs use Dijkstra; with costs of only 0 and 1, use 0-1 BFS.
- **A heap is unnecessary**: with equal step costs, a plain queue already pops in order of distance (LC 1210 started with a heap).

## Template 2: Connected Components

```python
seen = set()
components = 0
for node in range(n):
    if node not in seen:
        components += 1
        seen.add(node)
        stack = [node]
        while stack:                    # iterate with a stack to avoid deep recursion
            u = stack.pop()
            for v in adj[u]:
                if v not in seen:
                    seen.add(v)
                    stack.append(v)
```

On a grid, each cell is a node and the four neighbors are its edges. Overwriting visited cells in place can replace `seen`.

### Key Parameters:

- **Recursive DFS depth**: Python's default limit is about 1000; with `10^5` cells, one long island exceeds it. An explicit stack is safer (LC 827 switched to iteration).
- **Label components**: rewrite each component's cells as `2, 3, 4, ...` and record each label's size in a dict; then a neighbor's label tells you which component it belongs to (LC 827).

## Template 3: Multi-source BFS, One Layer at a Time

All sources spread at once, and a rule decides the result when several reach the same cell in the same layer:

```python
q = deque(sources)
while q:
    arrivals = {}                       # cells reached in this layer -> result
    for _ in range(len(q)):
        r, c, color = q.popleft()
        for nr, nc in neighbors(r, c):
            if grid[nr][nc] == 0:
                arrivals[(nr, nc)] = max(arrivals.get((nr, nc), 0), color)
    for (nr, nc), color in arrivals.items():
        grid[nr][nc] = color
        q.append((nr, nc, color))
```

**Collect the whole layer first and write it back afterwards**, so results written early in a layer do not affect decisions later in the same layer (LC 3905).

## Template 4: State-space BFS

When position alone does not describe the state, put the extra information into the node:

| Problem | State |
|---|---|
| LC 864 collect all keys | `(r, c, bitmask of keys held)` |
| LC 1210 snake moves | `(tail r, c, horizontal or vertical)` |

`visited` must store the whole state: the same cell with different keys is a different node.

## Template 5: Shortest Cycle in an Undirected Graph

BFS from every node, recording distance and parent. A neighbor that is **already visited and is not the parent** closes a cycle of length `dist[u] + dist[v] + 1`:

```python
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
```

`n` BFS runs, `O(n · (n + m))` in total (LC 2608).

## When to Use Union-Find

When you only need "who is connected to whom" and edges arrive one at a time, Union-Find is more convenient than BFS. Remember **path compression**: without it `find` is `O(n)` in the worst case. My Union-Find version of LC 323 took 417ms; DFS took 11ms.

## Complexity

- BFS and DFS: `O(V + E)`; on a grid, `O(mn)`.
- State-space BFS: `O(states × transitions per state)`, e.g. `O(mn · 2^k · 4)` for LC 864.

## Common Mistakes

These are all mistakes I actually made while practicing:

- **Swapping grid dimensions**: mixing up `[[0] * n for _ in range(m)]` and `[[0] * m for _ in range(n)]` (LC 3905).
- **Using a bitmask of traversed edges as the state to find cycles**: the state space explodes, Memory Limit Exceeded (LC 2608).
- **Testing a bit without `& 1`**: `visited >> edge` is truthy whenever any higher bit is set (LC 2608).
- **Union-Find without path compression** (LC 323).
- **Recursive DFS too deep on large grids** (LC 3619, 827).
- **Using a heap when every step costs the same**: it passes, but adds a `log` factor (LC 1210).

## Related LeetCode

- `LC 323` Number of Connected Components in an Undirected Graph
- `LC 3493` Properties Graph
- `LC 3619` Count Islands With Total Value Divisible by K
- `LC 827` Making A Large Island
- `LC 1306` Jump Game III
- `LC 3905` Multi Source Flood Fill
- `LC 864` Shortest Path to Get All Keys
- `LC 1210` Minimum Moves to Reach Target with Rotations
- `LC 2608` Shortest Cycle in a Graph
- `LC 3910` Count Connected Subgraphs with Even Node Sum
- `LC 773` Sliding Puzzle
