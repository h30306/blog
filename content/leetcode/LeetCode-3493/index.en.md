---
title: "LeetCode 3493: Properties Graph"
summary: "LeetCode 3493 note: convert each row to a set, compare intersection sizes pairwise to add edges, then count components"
description: "LeetCode 3493 record from 2025-03-23"
date: 2025-03-23
tags: ["medium", "graph", "dfs", "union-find", "hash-map"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-03-23
- Submissions: Accepted (first try)

## Approach

Rows `i` and `j` share an edge when their **distinct** numbers intersect in at least `k` values. Build the graph, then count connected components.

With `n, m <= 100`, comparing all `O(n^2)` pairs at `O(m)` each is about `10^6` operations, fast enough.

## My Solution

```python
class Solution:
    def numberOfComponents(self, properties: List[List[int]], k: int) -> int:
        n = len(properties)
        sets = [set(p) for p in properties]       # convert once, not on every comparison

        parent = list(range(n))

        def find(x: int) -> int:
            while parent[x] != x:
                parent[x] = parent[parent[x]]
                x = parent[x]
            return x

        components = n
        for i in range(n):
            for j in range(i + 1, n):
                if len(sets[i] & sets[j]) >= k:
                    ri, rj = find(i), find(j)
                    if ri != rj:
                        parent[ri] = rj
                        components -= 1
        return components
```

My original version built an adjacency list and counted components with a recursive DFS, with the same result. Two things could improve:

- `intersect(a, b)` rebuilt `set(a)` and `set(b)` on every comparison, converting each row `n` times. Convert once and keep the sets.
- `graph[i] = graph.get(i, []) + [j]` built a new list each time, slowing down as lists grew; `append` is enough.

This version uses Union-Find, merging while comparing, without an adjacency list.

## Complexity

Time `O(n^2 · m)`, space `O(n · m)`.

## Mistakes to Avoid

- Intersecting the raw lists: deduplicate first, since the problem counts **distinct** numbers.
- Rebuilding sets on every comparison.
- Growing adjacency lists with `list + [x]`.

## Interview Explanation

I convert each row to a set, compare intersection sizes for every pair, and union the two rows with Union-Find when the size is at least `k`, decrementing the component count on each real merge. With `n` and `m` at most 100, the `O(n^2 m)` pairwise comparison is fast enough.
