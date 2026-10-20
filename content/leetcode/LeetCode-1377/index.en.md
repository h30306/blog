---
title: "LeetCode 1377: Frog Position After T Seconds"
summary: "LeetCode 1377 note: undirected edges, seen must hold nodes, and an early arrival depends on whether the frog can still move"
description: "LeetCode 1377 record from 2026-08-30"
date: 2026-08-30
tags: ["hard", "tree", "dfs", "bfs", "graph", "probability"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-08-30
- Submissions: Wrong Answer ×5 → Accepted

## Approach

The frog starts at node 1 and each second jumps with equal probability to an unvisited neighbor; with nowhere to go, it stays put. Find the probability that it is on `target` after `t` seconds.

A tree has one path from 1 to `target`, so multiply probabilities along that path: at each node, multiply by `1 / (number of unvisited neighbors)`.

Reaching `target` has three cases:

| Arrival time | Does `target` still have unvisited neighbors? | Result |
|---|---|---|
| exactly `t` | does not matter | return the probability |
| before `t` | no, so the frog stays there | return the probability |
| before `t` | yes, so the frog jumps away | return 0 |

## My Attempts

All five WAs came from the same few bugs:

1. **One-directional edges**: `edgeMap[u].append(v)` without the reverse. If an edge is given as `[2, 1]`, node 2 is unreachable.
2. **Adding the wrong thing to `seen`**: `seen.add(second)` stores the time instead of the node, so `if vertex in seen` does nothing.
3. **Checking only `second == t`**: if the frog arrives early and has nowhere to go, it stays forever and should count.
4. **Switching to `second <= t` is too loose**: if it arrives early but can still jump, it leaves, so the probability is 0.
5. A debugging `print(pq)` was also left in.

## Solution

The accepted version used a heap, which this problem does not need: each node is reached only once, so DFS or BFS works. The DFS below carries the probability down the path:

```python
class Solution:
    def frogPosition(self, n: int, edges: List[List[int]], t: int, target: int) -> float:
        adj = [[] for _ in range(n + 1)]
        for u, v in edges:
            adj[u].append(v)
            adj[v].append(u)

        def dfs(u: int, parent: int, time: int, prob: float) -> float:
            children = [v for v in adj[u] if v != parent]
            if u == target:
                if time == t or (time < t and not children):
                    return prob
                return 0.0
            if time == t or not children:
                return 0.0
            for v in children:
                p = dfs(v, u, time + 1, prob / len(children))
                if p:
                    return p
            return 0.0

        return dfs(1, 0, 0, 1.0)
```

A tree has no cycles, so tracking `parent` replaces `seen` for avoiding backtracking.

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Adding tree edges in one direction only.
- Putting something other than the node into `seen`.
- Not separating "arrived exactly at `t`" from "arrived early and stopped".
- Reaching for a heap or other heavy tools, which complicates the logic.

## Interview Explanation

A tree has one path from 1 to the target, so I DFS along it and divide the probability by the number of unvisited children at each step. At the target, if the time is exactly `t`, or earlier with no children left to jump to, I return the current probability; otherwise the frog jumps away and the probability is 0. Edges are added in both directions, and the parent check prevents backtracking. Time `O(n)`.
