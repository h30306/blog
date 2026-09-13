---
title: "LeetCode 743: Network Delay Time"
summary: "LeetCode note for Network Delay Time, rebuilt from the original learning note"
description: "Cleaned LeetCode 743 article from 2026-05-01 with note repair points and final solution"
date: 2026-05-01
tags: ["medium", "graph", "dijkstra", "shortest-path"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-05-01
Source: Day 16 learning note

## Study Context

This article is rebuilt from the exact LeetCode section in the learning note. I kept the note's repair points, comparison points, and common mistakes, while removing unrelated non-LeetCode material from the same day.

## Related Reminders From The Note

- 3. Explain why `LC 743` needs Dijkstra instead of BFS.

## Learning Note Extract

#### Problem 3 - LC 743 Network Delay Time Review
- **Status:** Good enough no-hints recall.
- **Pattern:** Dijkstra / single-source shortest path.

#### Why Dijkstra Fits
We need:
```text
minimum travel time from one source node k to every other node
```

The graph is:
- directed
- weighted
- non-negative edge costs

That is the standard Dijkstra fit.

#### Core Data Structures
- adjacency list
- min-heap of `(time, node)`
- either:
  - shortest-distance table, or
  - finalized / visited set

#### Final Answer Meaning
This is not:
```text
the longest arbitrary path from source
```

It is:
```text
the maximum shortest-path arrival time from source to any reachable node
```

So:
- if some node is unreachable -> return `-1`
- else -> return the maximum shortest arrival time

#### Complexity
```text
Time: O((E + V) log V)
Space: O(E + V)
```

#### Common Mistakes
- using BFS even though edge weights differ
- saying the answer is the "longest path"
- forgetting to skip stale heap entries or revisits

#### Interview-Ready Explanation
I run Dijkstra from node `k` to compute the shortest signal arrival time to every node. If I cannot reach all nodes, I return `-1`. Otherwise I return the largest shortest arrival time, because that is when the last node receives the signal.

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

```python
from collections import defaultdict
from heapq import heappop, heappush
from typing import List

class Solution:
    def networkDelayTime(self, times: List[List[int]], n: int, k: int) -> int:
        graph = defaultdict(list)
        for u, v, w in times:
            graph[u].append((v, w))

        dist = {}
        heap = [(0, k)]
        while heap:
            d, node = heappop(heap)
            if node in dist:
                continue
            dist[node] = d
            for nei, w in graph[node]:
                if nei not in dist:
                    heappush(heap, (d + w, nei))

        return max(dist.values()) if len(dist) == n else -1
```

## Complexity

Time O((V+E) log V), Space O(V+E).

## Mistakes To Watch

- Returning distance to one target instead of all nodes.
- Forgetting nodes are 1-indexed.

## Final Interview Explanation

Start from the state definition, then explain why the transition preserves that state. If there is a loop direction, state compression, or a similar-looking problem with a different answer shape, call that out explicitly because that is where this problem family usually breaks down.
