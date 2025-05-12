---
title: "LeetCode 684: Redundant Connection"
summary: "LeetCode Problem Solving"
description: "LeetCode Daily"
date: 2025-05-04
tags: ["LeetCode", "blog", "Union Find", "medium"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-05-04
- Total time: 05:00.00

## Intuition

This problem requires finding the last connection that forms a cycle among the nodes.  
Based on the Union Find algorithm, when we apply a union operation on two nodes that already share the same parent, it means this union will create a cycle.  
Therefore, we just need to record this edge and return it.

## Approach

```python
class Solution:
    def findRedundantConnection(self, edges: List[List[int]]) -> List[int]:
        n = len(edges)
        ranking = [0 for _ in range(n)]
        parent = [i for i in range(n)]
        res = []

        def find(x):
            if parent[x] != x:
                parent[x] = find(parent[x])
            
            return parent[x]

        def union(x, y):
            nonlocal res
            x_root = find(x)
            y_root = find(y)

            if x_root == y_root:
                res = [x+1, y+1]
                return

            if ranking[x_root]>ranking[y_root]:
                parent[y_root] = parent[x_root]
                ranking[x_root] += ranking[y_root]
            else:
                parent[x_root] = parent[y_root]
                ranking[y_root] += ranking[x_root]

        for x,y in edges:
            union(x-1,y-1)

        return res
```

## Findings

## Encountered Problems 