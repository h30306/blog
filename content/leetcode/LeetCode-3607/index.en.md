---
title: "LeetCode 3607: Power Grid Maintenance"
summary: "LeetCode 3607 note: Union-Find groups, one min-heap per group, and lazy deletion for offline stations"
description: "LeetCode 3607 record from 2025-07-06"
date: 2025-07-06
tags: ["medium", "heap", "union-find", "graph", "lazy-deletion"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-07-06
- Submissions: Wrong Answer ×4 → Time Limit Exceeded ×10 → Accepted (15 total)

## Approach

1. **The grid structure never changes**: an offline station still belongs to its grid. So group stations once with Union-Find and never touch the groups again.
2. **A query asks for the smallest-id online station in the same group**: keep one min-heap per group.
3. **Do not delete offline stations from the heap**: on a query, pop the top while it is offline, until the top is online (lazy deletion).

Each station is popped at most once, so all queries together cost `O((c + q) log c)`.

## My Attempts

### Wrong Answer ×4: a broken Union-Find

```python
def union(self, x, y):
    root_x = self.find(x)
    root_y = self.find(y)
    if root_x == root_y:
        return
    if self.weight[x] >= self.weight[y]:
        self.parent[y] = self.parent[x]      # links x and y themselves, not their roots
    else:
        self.parent[x] = self.parent[y]
```

```python
for ps in range(c):
    groups[uf.parent[ps] + 1].add(ps + 1)    # parent instead of find
```

Two problems:

- After finding the roots, `union` links `y` under `x`'s parent. **It links the nodes, not the roots**, so the rest of `y`'s group stays under the old root.
- Grouping used `uf.parent[ps]`, but a parent is not necessarily a root. **Use `find`.**

The first attempt also had an off-by-one: groups were keyed by `parent + 1`, but queries looked up `find(ps - 1)` without the `+ 1`.

### Time Limit Exceeded ×10: taking the minimum of a whole group per query

After fixing Union-Find, the query looked like this:

```python
remain = groups[uf.find(ps)] - off_line    # set difference over the whole group
res.append(min(remain))                    # then min over the whole group
```

Each query costs `O(group size)`. Later attempts removed stations from the set when they went offline, switched to union by size, used an `is_online` array… but the query still called `min(set)`, so it stayed `O(c)` and timed out when `c` and `q` were both large.

**The problem was not Union-Find; it was the "query the minimum" step.** It needs a structure that gives the minimum quickly and handles deletions: a heap with lazy deletion.

## Solution

```python
import heapq
from collections import defaultdict

class UF:
    def __init__(self, n: int):
        self.parent = list(range(n))

    def find(self, x: int) -> int:
        while self.parent[x] != x:
            self.parent[x] = self.parent[self.parent[x]]
            x = self.parent[x]
        return x

    def union(self, x: int, y: int) -> None:
        rx, ry = self.find(x), self.find(y)
        if rx != ry:
            self.parent[ry] = rx

class Solution:
    def processQueries(self, c: int, connections: List[List[int]], queries: List[List[int]]) -> List[int]:
        uf = UF(c + 1)
        for u, v in connections:
            uf.union(u, v)

        heaps = defaultdict(list)
        for station in range(1, c + 1):
            heaps[uf.find(station)].append(station)   # added in id order: already a valid heap

        online = [True] * (c + 1)
        res = []
        for op, x in queries:
            if op == 2:
                online[x] = False
            elif online[x]:
                res.append(x)
            else:
                heap = heaps[uf.find(x)]
                while heap and not online[heap[0]]:
                    heapq.heappop(heap)                # lazy deletion
                res.append(heap[0] if heap else -1)
        return res
```

Stations are added in increasing id order, so each list is already a valid min-heap and needs no `heapify`.

## Complexity

Time `O((c + n + q) log c)`, space `O(c)`.

## Mistakes to Avoid

- A `union` that links the nodes instead of their roots.
- Grouping with `parent[x]` instead of `find(x)`.
- Mixing 1-indexed and 0-indexed ids.
- Tweaking data structure details while stuck on TLE, instead of asking what the query complexity is.

## Interview Explanation

Going offline does not change the grid, so I group stations once with Union-Find and keep a min-heap of ids per group. Going offline only flips a flag in an `online` array; on a query, I pop the heap top while it is offline, until it is online or the heap is empty. Each station is popped at most once, so the total time is `O((c + q) log c)`.
