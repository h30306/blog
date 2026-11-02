---
title: "LeetCode 834: Sum of Distances in Tree"
summary: "LeetCode 834 note: rerooting DP: compute subtree sizes and ans[0] with root 0, then push ans[child] = ans[parent] - size + (n - size) to every node"
description: "LeetCode 834 record from 2026-10-31"
date: 2026-10-31
tags: ["hard", "dynamic-programming", "tree", "depth-first-search", "graph", "dp-on-trees"]
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
- Submissions: Wrong Answer → Accepted ×3

## Approach

Running a BFS from every node is `O(n^2)`, too slow for `n` up to `3 * 10^4`. Rerooting DP needs only two passes:

1. **With 0 as the root**, bottom-up:
   - `count[v]`: number of nodes in `v`'s subtree.
   - `ans[v]`: sum of distances from `v` to the nodes in its subtree. `ans[p] += ans[v] + count[v]`, because every node in `v`'s subtree is one step farther from `p` than from `v`.
   - After this pass `ans[0]` is final.
2. **Top-down rerooting**: moving the root from `p` to its child `v`, the `count[v]` nodes in `v`'s subtree get 1 closer and the other `n - count[v]` nodes get 1 farther:

   `ans[v] = ans[p] - count[v] + (n - count[v])`

With the BFS order `order`, iterating in reverse is bottom-up and forward is top-down, with no recursion (the tree can be a long chain).

## My Attempts

1. In both loops I wrote `u` where `node` was meant. `u` was left over from the graph-building loop, so Python raised nothing and kept using the last edge's endpoint, and every answer was wrong: `n = 2, edges = [[0,1]]` returned `[0,0]` instead of `[1,1]`. The same version also had a `p != 1` typo (should be `-1`) and left the root out of `order`.
2. Fixing those passed. I rewrote it from scratch twice more the same day and both passed on the first try.

## Solution

```python
class Solution:
    def sumOfDistancesInTree(self, n: int, edges: List[List[int]]) -> List[int]:
        graph = defaultdict(list)
        for u, v in edges:
            graph[u].append(v)
            graph[v].append(u)

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

        count = [1] * n
        ans = [0] * n
        for node in reversed(order):          # bottom-up
            p = parent[node]
            if p != -1:
                count[p] += count[node]
                ans[p] += ans[node] + count[node]

        for node in order:                    # top-down rerooting
            p = parent[node]
            if p != -1:
                ans[node] = ans[p] - count[node] + (n - count[node])
        return ans
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Rerooting needs the **final** `ans[p]`, so the second pass must go top-down (BFS order), not in reverse.
- After the first pass only `ans[0]` is a full answer; the other `ans[v]` only cover their subtrees.
- Watch loop variable names: in Python a loop variable still exists after its loop ends, so a typo silently uses a stale value.

## Interview Explanation

I use rerooting DP. With 0 as the root I compute, bottom-up, each subtree's size and the sum of distances from a node into its subtree, which makes `ans[0]` correct. Moving the root from a parent to a child brings the child's subtree one step closer and everything else one step farther, so `ans[v] = ans[p] - count[v] + n - count[v]`, applied top-down. Two passes, `O(n)` time.
