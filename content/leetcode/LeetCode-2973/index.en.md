---
title: "LeetCode 2973: Find Number of Coins to Place in Tree Nodes"
summary: "LeetCode 2973 note: the max product of three is either the three largest or the two smallest times the largest, so each subtree returns only its 2 smallest and 3 largest values, merged in post-order"
description: "LeetCode 2973 record from 2026-09-12"
date: 2026-09-12
tags: ["hard", "dynamic-programming", "tree-dp", "depth-first-search", "sorting", "heap", "tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-09-12
- Submissions: Wrong Answer ×3 → Accepted ×2

## Approach

The largest product of three distinct nodes in a subtree is one of:

- **The three largest values**.
- **The two smallest (possibly two negatives) × the largest**.

So each subtree only needs **its 2 smallest and 3 largest values**, at most 5 numbers. In post-order, combine your own value with every child's returned values, sort, compute the answer, and truncate to 5 before returning.

- Subtree size `< 3`: place 1 coin.
- A negative product: place 0.

Edges are undirected, so build a two-way adjacency list and track the parent in the DFS.

## My Attempts

| Version | Problem |
|---|---|
| Attempt 1 | Collected subtree values in a heap, but leaves returned positive `cost` while internal nodes returned a negated heap, **mixing signs**. For edges `[[0, 1], [1, 2], [0, 3]]`, `cost = [1, 2, 3, 1]`, the root's answer is `3 × 2 × 1 = 6`; it returned 0 |
| Attempt 2 | Fixed the signs, but multiplied only the three largest, missing two negatives. For edges `[[0, 1], [0, 2], [1, 3]]`, `cost = [6, -5, 0, -4]`, `6 × (-5) × (-4) = 120`; it returned 0 |
| Attempt 3 | Fixed the product, but the adjacency list only stored `u → v`, assuming every edge is "parent → child". Edges are undirected; with an edge written `[[1, 0]]`, node 0 finds no children |
| AC | Built a two-way adjacency list with the parent passed through the DFS |

## Solution

```python
class Solution:
    def placedCoins(self, edges: List[List[int]], cost: List[int]) -> List[int]:
        adj = defaultdict(list)
        for u, v in edges:
            adj[u].append(v)
            adj[v].append(u)                       # edges are undirected
        res = [0] * len(cost)

        def dfs(node: int, parent: int) -> List[int]:
            vals = [cost[node]]
            for child in adj[node]:
                if child != parent:
                    vals.extend(dfs(child, node))
            vals.sort()
            if len(vals) < 3:
                res[node] = 1
            else:
                res[node] = max(0, vals[-1] * vals[-2] * vals[-3], vals[0] * vals[1] * vals[-1])
            return vals if len(vals) <= 5 else vals[:2] + vals[-3:]   # keep 2 smallest, 3 largest

        dfs(0, -1)
        return res
```

## Complexity

Each node merges at most `5 × children + 1` values, a constant-factor sort, roughly `O(n log n)` overall. The DFS can be `n` deep (a chain), so with `n = 2 × 10^4` you may need a higher recursion limit or an iterative version.

## Mistakes to Avoid

- Looking only at the three largest: two negatives multiply to a positive.
- Mixing signs inside a heap.
- Treating edges as directed.

## Interview Explanation

The best product of three is either the three largest or the two smallest times the largest, so each subtree returns just its 2 smallest and 3 largest values. In post-order I merge my value with the children's, sort, compute the answer, and pass up only 5 values. Edges are undirected, so the adjacency list goes both ways. Roughly `O(n log n)`.
