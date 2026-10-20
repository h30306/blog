---
title: "LeetCode 3910: Count Connected Subgraphs with Even Node Sum"
summary: "LeetCode 3910 note: n is tiny, so enumerate subsets with a bitmask, check the even sum first, then check that the induced subgraph is connected"
description: "LeetCode 3910 record from 2026-04-26"
date: 2026-04-26
tags: ["hard", "bit-manipulation", "enumeration", "graph", "union-find"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-04-26
- Submissions: Accepted → Accepted (cleaned up)

## Approach

Count the non-empty node subsets such that:

1. Keeping only those nodes and the edges between them (the induced subgraph), the subgraph is connected.
2. The sum of the subset's node values is even.

The node count is small, so **enumerate all `2^n - 1` subsets with a bitmask**. For each subset:

1. Check the even sum first; it is cheap, so skip immediately on failure.
2. Then check connectivity of the induced subgraph: BFS from any node in the subset, using only edges inside it, and see whether every node is reached.

## My Solution

My original checked connectivity with Union-Find, merging only edges whose endpoints are both in the subset and then checking that all subset nodes share one root. This version uses BFS, with the same logic but no `parent` array rebuilt per subset:

```python
class Solution:
    def evenSumSubgraphs(self, nums: List[int], edges: List[List[int]]) -> int:
        n = len(nums)
        adj = [0] * n                              # neighbors as bitmasks too
        for u, v in edges:
            adj[u] |= 1 << v
            adj[v] |= 1 << u

        count = 0
        for mask in range(1, 1 << n):
            if sum(nums[i] for i in range(n) if mask >> i & 1) % 2:
                continue
            start = (mask & -mask).bit_length() - 1     # the lowest node
            seen = 1 << start
            frontier = seen
            while frontier:
                nxt = 0
                for i in range(n):
                    if frontier >> i & 1:
                        nxt |= adj[i]
                nxt &= mask & ~seen                # only unvisited nodes inside the subset
                seen |= nxt
                frontier = nxt
            if seen == mask:
                count += 1
        return count
```

With neighbors stored as bitmasks, "stay inside the subset" is a single `& mask`.

The LeetCode statement asks for a variable with a specific name to store the input midway through the function, and my submission did so; it does not affect the algorithm and is omitted here.

## Complexity

Time `O(2^n · n^2)`: each subset's BFS has at most `n` layers, each scanning `n` nodes. Space `O(n)`.

## Mistakes to Avoid

- Using edges or nodes outside the subset during the connectivity check: only edges with both endpoints inside count.
- Counting the empty subset: start the mask at 1.
- Checking connectivity before the sum: the sum check is cheaper, so doing it first skips failing subsets early.

## Interview Explanation

The node count is small, so I enumerate every non-empty subset with a bitmask. Each subset first checks that its value sum is even; if so, a BFS from any node in the subset, restricted to subset nodes, must reach the whole subset for it to be connected. Storing neighbors as bitmasks makes the restriction a single `& mask`. Time `O(2^n · n^2)`.
