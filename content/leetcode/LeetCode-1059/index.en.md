---
title: "LeetCode 1059: All Paths from Source Lead to Destination"
summary: "LeetCode 1059 note: trim outdegrees backward from the destination; a node is safe only when every outgoing edge leads to a safe node, and the destination itself must have no outgoing edges"
description: "LeetCode 1059 record from 2026-04-29"
date: 2026-04-29
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
First Attempt: 2026-04-29
- Submissions: Accepted → Wrong Answer → Accepted

## Approach

"Every path from source ends at destination" means three things: the only reachable dead end is the destination, no cycle is reachable, and the destination has no outgoing edges (otherwise paths could continue, even loop).

Use reverse outdegree trimming from [Topological Sort]({{< relref "/algorithm/Topological-Sort" >}}):

- Build reversed edges and record each node's outdegree.
- If the destination has outgoing edges, return `False`.
- BFS from the destination: when a node's outdegree drops to 0, all its outgoing edges lead to safe nodes, so it is safe too.
- Nodes on a cycle never reach 0, and other dead ends are never added. The answer is whether the source is safe.

## My Attempts

Reverse trimming passed on the first try. Later I practiced a DFS version (three states: on the path / known safe / known unsafe) but **did not check whether the destination has outgoing edges**. For `n = 1`, `edges = [[0, 0]]`, `source = destination = 0`, node 0 has a self-loop and can loop forever, so the answer is `False`; the DFS returned `True` immediately because `node == destination`. Adding the check passed.

## Solution

```python
class Solution:
    def leadsToDestination(self, n: int, edges: List[List[int]], source: int, destination: int) -> bool:
        rev = [[] for _ in range(n)]
        out_degree = [0] * n
        for u, v in edges:
            rev[v].append(u)
            out_degree[u] += 1
        if out_degree[destination]:
            return False
        safe = {destination}
        q = deque([destination])
        while q:
            node = q.popleft()
            for prev in rev[node]:
                out_degree[prev] -= 1
                if out_degree[prev] == 0:          # every outgoing edge leads somewhere safe
                    safe.add(prev)
                    q.append(prev)
        return source in safe
```

## Complexity

Time `O(n + E)`, space `O(n + E)`.

## Mistakes to Avoid

- A destination with outgoing edges (including a self-loop) always means `False`.
- Parallel edges count twice in the outdegree and are stored twice as reversed edges, which matches, so no deduplication is needed.

## Interview Explanation

I trim backward from the destination: with edges reversed, a node whose outgoing edges all lead to safe nodes has its outdegree decremented to 0 and becomes safe. Nodes on cycles and other dead ends never get added. If the destination itself has outgoing edges, the answer is `False`. Finally I return whether the source is safe. Time `O(n + E)`.
