---
title: "LeetCode 3203: Find Minimum Diameter After Merging Two Trees"
summary: "LeetCode 3203 note: connect the two centers; the answer is max(d1, d2, ceil(d1/2) + ceil(d2/2) + 1)"
description: "LeetCode 3203 record from 2026-10-15"
date: 2026-10-15
tags: ["hard", "tree", "bfs", "dfs", "graph", "tree-diameter"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-10-15
- Submissions: Runtime Error ×2 → Accepted → Runtime Error → Accepted → Accepted (rewritten with iterative BFS)

## Approach

After joining the two trees with one edge, the new diameter is one of three things:

1. The first tree's original diameter `d1`.
2. The second tree's original diameter `d2`.
3. A path through the new edge: from some node in the first tree to the joining node, across the new edge, to some node in the second tree.

To make option 3 as short as possible, join **the centers of both trees**. The distance from a center to the farthest node (the radius) is `ceil(d / 2)`, so:

```text
answer = max(d1, d2, ceil(d1 / 2) + ceil(d2 / 2) + 1)
```

Two BFS runs give each diameter: find the farthest node `a` from any node, then the largest distance from `a`.

## My Attempts

### Runtime Errors 1 and 2: copy-paste kept the old size

```python
m = len(edges2) + 1
seen = [0] * m
...
seen = [0] * n                 # the second tree still uses n
```

The second tree's code was copied from the first, so one `seen` array still had size `n`. When `m > n`, the index goes out of range. The first submission had `n` in both places; the second fixed only one.

### Runtime Error 3: renamed the function but not the recursive call

I renamed `bfs` to `dfs` (it really was a recursive DFS), but the body still called `bfs(...)`.

### Final version: iterative BFS

A recursive DFS risks hitting the recursion limit on a chain of `10^5` nodes, and the code for both trees was duplicated. The final version is one `diameter(edges)` function using iterative BFS.

## Solution

```python
from collections import defaultdict, deque

class Solution:
    def minimumDiameterAfterMerge(self, edges1: List[List[int]], edges2: List[List[int]]) -> int:
        def diameter(edges: List[List[int]]) -> int:
            n = len(edges) + 1
            adj = defaultdict(list)
            for u, v in edges:
                adj[u].append(v)
                adj[v].append(u)

            def bfs(start: int):
                dist = [-1] * n
                dist[start] = 0
                q = deque([start])
                while q:
                    node = q.popleft()
                    for nei in adj[node]:
                        if dist[nei] == -1:
                            dist[nei] = dist[node] + 1
                            q.append(nei)
                return node, dist[node]          # farthest node and its distance

            far, _ = bfs(0)
            _, d = bfs(far)
            return d

        d1 = diameter(edges1)
        d2 = diameter(edges2)
        return max(d1, d2, (d1 + 1) // 2 + (d2 + 1) // 2 + 1)
```

`(d + 1) // 2` is `ceil(d / 2)` without floating point.

## Complexity

Time `O(n + m)`, space `O(n + m)`.

## Mistakes to Avoid

- Copy-pasting the code for both trees: a shared function only ever sees its own `n`.
- Renaming a function without checking every call site.
- Considering only the path through the new edge and forgetting that an original diameter may be longer.

## Interview Explanation

The merged diameter is either one of the original diameters or a path through the new edge. To minimize the latter, join the two centers; the farthest distance from a center is `ceil(d/2)`, so the answer is `max(d1, d2, ceil(d1/2) + ceil(d2/2) + 1)`. Each diameter comes from two BFS runs, so time is `O(n + m)`.
