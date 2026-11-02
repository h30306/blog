---
title: "LeetCode 2858: Minimum Edge Reversals So Every Node Is Reachable"
summary: "LeetCode 2858 note: rerooting DP: count the reversals needed with root 0, then moving the root to a child adds 1 if that edge pointed down and subtracts 1 if it pointed up"
description: "LeetCode 2858 record from 2026-10-31"
date: 2026-10-31
tags: ["hard", "dynamic-programming", "depth-first-search", "breadth-first-search", "graph"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-10-31
- Submissions: Accepted ×2

## Approach

The edges are directed, but without directions they form a tree. Reaching every node from `i` means every edge must point **away from `i`**. So `ans[i]` is the number of edges pointing toward the root when `i` is the root.

Computing that per node is `O(n^2)`. Use rerooting DP (as in LC 834):

1. BFS with root 0 and count the edges that point from a child to its parent. That is `ans[0]`.
2. Moving the root from `p` to its child `v` only changes the `p`–`v` edge:
   - Originally `p → v` (pointing down): with `v` as the root it points up, one more reversal, `ans[v] = ans[p] + 1`.
   - Originally `v → p` (pointing up): it needed reversing for root `p` but not for root `v`, `ans[v] = ans[p] - 1`.

A `set` of the original directed edges tells whether an edge points down.

## My Attempts

Both submissions passed on the first try (once on 10-31, and a rewrite that afternoon).

## Solution

```python
class Solution:
    def minEdgeReversals(self, n: int, edges: List[List[int]]) -> List[int]:
        graph = defaultdict(list)
        for u, v in edges:
            graph[u].append(v)
            graph[v].append(u)
        forward = {(u, v) for u, v in edges}

        parent = [-1] * n
        seen = [False] * n
        seen[0] = True
        order = []
        queue = deque([0])
        while queue:
            node = queue.popleft()
            order.append(node)
            for nei in graph[node]:
                if not seen[nei]:
                    seen[nei] = True
                    parent[nei] = node
                    queue.append(nei)

        ans = [0] * n
        ans[0] = sum(1 for v in order[1:] if (parent[v], v) not in forward)
        for v in order[1:]:
            p = parent[v]
            ans[v] = ans[p] + (1 if (p, v) in forward else -1)
        return ans
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Reroot top-down in BFS order so `ans[p]` is ready before its children.
- Build the graph in both directions, or nodes reachable only against an edge's direction are never visited.

## Interview Explanation

Without directions it is a tree, and reaching all nodes from `i` means every edge must point away from `i`, so the answer is the number of edges pointing up when `i` is the root. I count that for root 0, then reroot: moving the root from `p` to `v` only changes that edge, adding one if it was `p → v` and subtracting one if it was `v → p`. Time `O(n)`.
