---
title: "LeetCode 3613: Minimize Maximum Component Cost"
summary: "LeetCode 3613 note: add edges from light to heavy; the weight when exactly k components remain is the answer, and 0 when n <= k"
description: "LeetCode 3613 record from 2025-07-13"
date: 2025-07-13
tags: ["medium", "union-find", "graph", "sorting", "binary-search"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-07-13
- Submissions: Wrong Answer → Accepted

## Approach

An answer `W` means "keeping only edges with weight `<= W` leaves `<= k` components". More edges mean fewer components, so add edges from light to heavy (Kruskal, [Union-Find]({{< relref "/algorithm/Union-Find" >}}) edges sorted by weight); the weight when the count first reaches `k` is the smallest `W`.

- Only an edge that actually merges two components reduces the count; edges inside a component do not affect the answer.
- With `n <= k` the condition already holds; remove every edge and the answer is 0. The graph is guaranteed connected, so the count always reaches `k`.

## My Attempts

Attempt 1 missed `n == k`: the count starts at `k`, every merge goes below it, the loop never sees exactly `k`, and nothing is returned. For `n = 1`, `edges = []`, `k = 1` the answer is 0; it returned `None`. Adding the special case passed.

## Solution

```python
class Solution:
    def minCost(self, n: int, edges: List[List[int]], k: int) -> int:
        if n <= k:
            return 0
        parent = list(range(n))

        def find(x):
            while parent[x] != x:
                parent[x] = parent[parent[x]]
                x = parent[x]
            return x

        groups = n
        for u, v, w in sorted(edges, key=lambda e: e[2]):
            ru, rv = find(u), find(v)
            if ru != rv:
                parent[ru] = rv
                groups -= 1
                if groups == k:
                    return w
```

## Complexity

Time `O(E log E + E · α(n))`, space `O(n)`.

## Mistakes to Avoid

- Handle the case that already satisfies the condition first.
- When checking `groups == k`, make sure it drops by exactly 1 each time and must pass through `k`.

## Interview Explanation

I add edges to Union-Find from light to heavy, decrementing the count on each real merge. When exactly `k` components first remain, the heaviest edge used is the current one, so its weight is the answer. With `n <= k` no edge is needed, so return 0. Time `O(E log E)`.
