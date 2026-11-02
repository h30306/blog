---
title: "LeetCode 863: All Nodes Distance K in Binary Tree"
summary: "LeetCode 863 note: turn the tree into an undirected graph (adding edges to parents), then BFS k steps from target"
description: "LeetCode 863 record from 2026-10-28"
date: 2026-10-28
tags: ["medium", "hash-table", "tree", "depth-first-search", "breadth-first-search", "binary-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-10-28
- Submissions: Accepted (first try)

## Approach

A node at distance `k` may be inside target's subtree, or reached by first going up to an ancestor and then down. A tree only has downward pointers, so first turn it into an **undirected graph** ([Tree]({{< relref "/algorithm/Tree" >}}) Template 5): one DFS records every parent-child edge in both directions. Values are unique, so they can serve as graph nodes.

Then BFS from target; the nodes at level `k` are the answer.

## My Attempts

Accepted on the first try.

## Solution

```python
class Solution:
    def distanceK(self, root: TreeNode, target: TreeNode, k: int) -> List[int]:
        adj = defaultdict(list)

        def dfs(node):
            for child in (node.left, node.right):
                if child:
                    adj[node.val].append(child.val)
                    adj[child.val].append(node.val)
                    dfs(child)

        dfs(root)
        seen = {target.val}
        level = [target.val]
        for _ in range(k):
            nxt = []
            for node in level:
                for nei in adj[node]:
                    if nei not in seen:
                        seen.add(nei)
                        nxt.append(nei)
            level = nxt
        return level
```

My submission checked `seen` when popping and stopped once `dist > k`, which gives the same result; this version marks nodes when they are queued, so no node enters the queue twice.

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Searching only downward misses nodes reached through the parent.
- Keep a `seen` set; an undirected graph lets BFS walk back.
- Storing just `parent` pointers also works, without a full adjacency list.

## Interview Explanation

Nodes at distance `k` may require going up first, so I DFS once to turn the tree into an undirected graph with both directions of every parent-child edge. Then I BFS from target with a `seen` set, and after `k` levels the nodes in the frontier are the answer. Time and space `O(n)`.
