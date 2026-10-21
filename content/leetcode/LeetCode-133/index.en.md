---
title: "LeetCode 133: Clone Graph"
summary: "LeetCode 133 note: during DFS map each old node to its copy and return the existing copy when revisited, avoiding infinite recursion; an empty graph returns None"
description: "LeetCode 133 record from 2022-10-30"
date: 2022-10-30
tags: ["medium", "hash-table", "depth-first-search", "breadth-first-search", "graph"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-10-30
- Submissions: Runtime Error ×7 → Accepted ×2

## Approach

Deep-copy a possibly cyclic graph: `dfs(node)` returns the stored copy if one exists; otherwise it creates a node, **stores it first**, then recursively copies the neighbors ([Hash Table]({{< relref "/algorithm/Hash-Table" >}}); [BFS]({{< relref "/algorithm/BFS" >}}) works too). Storing before recursing is what handles cycles. An empty input returns `None`.

## My Attempts

The early versions had syntax errors and **no empty-graph check**: with a `None` input they read `node.val` (AttributeError). One version was otherwise correct but missed `if not node` as well; adding it passed.

## Solution

```python
class Solution:
    def cloneGraph(self, node: Optional['Node']) -> Optional['Node']:
        if not node:
            return None
        copies = {}
        def dfs(cur):
            if cur in copies:
                return copies[cur]
            copy = Node(cur.val)
            copies[cur] = copy
            copy.neighbors = [dfs(nb) for nb in cur.neighbors]
            return copy
        return dfs(node)
```

## Complexity

Time `O(V + E)`, space `O(V)`.

## Mistakes to Avoid

- Store the new node before recursing, or cycles recurse forever.
- Return `None` for an empty graph.

## Interview Explanation

DFS with a hash map from old nodes to copies: I store each new node before copying its neighbors, so cycles find the existing copy, and an empty graph returns None. Time `O(V + E)`.
