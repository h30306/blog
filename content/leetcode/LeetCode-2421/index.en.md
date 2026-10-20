---
title: "LeetCode 2421: Number of Good Paths"
summary: "LeetCode 2421 note: add nodes in increasing value order and count same-value nodes per Union-Find group"
description: "LeetCode 2421 record from 2026-07-26"
date: 2026-07-26
tags: ["hard", "tree", "union-find", "graph", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-07-26
- Submissions: Accepted (first try)

## Approach

A good path has equal values at both ends and no value along the path larger than the ends.

Another way to see it: **using only nodes with value `<= v`, which nodes of value `v` are connected?** If a connected component holds `k` nodes of value `v`, every pair of them has a good path: `k * (k - 1) / 2` paths.

So process values in increasing order:

1. For value `v`, union each node of value `v` with neighbors of value `<= v`.
2. Count the nodes of value `v` in each component and add `k * (k - 1) / 2`.
3. Each single node is also a path, so the answer starts at `n`.

Because nodes are added in increasing order, unions only involve values `<= v`, so the path maximum never exceeds `v`.

## My Solution

```python
from collections import defaultdict

class UF:
    def __init__(self, n: int):
        self.parent = list(range(n))
        self.rank = [0] * n

    def find(self, x):
        if self.parent[x] != x:
            self.parent[x] = self.find(self.parent[x])
        return self.parent[x]

    def union(self, x, y):
        rx, ry = self.find(x), self.find(y)
        if rx == ry:
            return
        if self.rank[rx] < self.rank[ry]:
            rx, ry = ry, rx
        self.parent[ry] = rx
        if self.rank[rx] == self.rank[ry]:
            self.rank[rx] += 1

class Solution:
    def numberOfGoodPaths(self, vals: List[int], edges: List[List[int]]) -> int:
        n = len(vals)
        adj = [[] for _ in range(n)]
        for u, v in edges:
            adj[u].append(v)
            adj[v].append(u)

        val_to_nodes = defaultdict(list)
        for i, val in enumerate(vals):
            val_to_nodes[val].append(i)

        uf = UF(n)
        res = n
        for val, nodes in sorted(val_to_nodes.items()):
            for node in nodes:                         # 1. union with neighbors <= val
                for nei in adj[node]:
                    if vals[nei] <= val:
                        uf.union(node, nei)

            group_count = defaultdict(int)             # 2. count value-val nodes per group
            for node in nodes:
                group_count[uf.find(node)] += 1

            for k in group_count.values():             # 3. pair them up
                res += k * (k - 1) // 2
        return res
```

The `union` I originally wrote had a small issue: equal ranks and a larger `rank[rx]` both went to `else`, and both incremented `rank[rx]`. The result was still correct; ranks just grew higher than needed. The version above increments only when the ranks are equal.

## Complexity

Time `O(n log n)`, dominated by sorting; Union-Find operations are nearly constant. Space `O(n)`.

## Mistakes to Avoid

- Using `vals[nei] < val` when unioning: equal-value neighbors must be joined too, or two adjacent equal nodes are missed.
- Counting once at the very end: count each value before moving to the next one, or larger values merge the groups too much.
- Forgetting the `n` single-node paths.

## Interview Explanation

A good path's values never exceed its endpoints, so I process nodes in increasing value order. For value `v`, I union nodes of value `v` with neighbors of value at most `v`, so any path inside a component has maximum at most `v`. Then for each component with `k` nodes of value `v` I add `k(k-1)/2`, plus `n` single-node paths at the end. Sorting dominates, so time is `O(n log n)`.
