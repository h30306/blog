---
title: "LeetCode 947: Most Stones Removed with Same Row or Column"
summary: "LeetCode Problem Solving"
description: "LeetCode Daily"
date: 2025-05-10
tags: ["LeetCode", "Union Find", "medium"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-05-10
- Total time: 20:00.00

## Intuition

The rule for removing a stone is that there must be another stone in the same row or column.  
Thus, we can use Union Find to group stones that share the same `x` or `y` coordinate.  
After grouping, the total number of stones we can remove is the sum of `(group size - 1)` for each connected component.

At first, I tried to initialize the parent array using the maximum coordinate value, but this led to MLE (Memory Limit Exceeded) because a single outlier coordinate `k` would cause unnecessary memory allocation from 1 to `k`.  
To fix this, I switched to using a dictionary for the parent structure, where each coordinate string (e.g., `"x,y"`) is used as a key.

There's another approach from forum, I'll explain in Approach section

## Approach

## Basic Union Find
```python
class Solution:
    def removeStones(self, stones: List[List[int]]) -> int:

        parents = {}

        def find(x):

            if parents.get(x, x) != x:
                parents[x] = find(parents[x])
            else:
                parents[x] = x

            return parents[x]

        def union(x, y):
            root_x = find(x)
            root_y = find(y)

            if root_x == root_y:
                return 
            
            parents[root_x] = parents[root_y]


        for x in stones:
            for y in stones:
                if x == y:
                    continue
                if x[0] == y[0] or x[1] == y[1]:
                    coordinate_x = ",".join(map(str, x))
                    coordinate_y = ",".join(map(str, y))
                    union(coordinate_x, coordinate_y)
        

        seen = set()
        res = 0
        for stone in stones:
            coordinate = ",".join(map(str, stone))
            group = find(coordinate)
            if group in seen:
                res +=1
            else:
                seen.add(group)

        return res
```

# Optimize Union Find

The main idea of this approach is to flatten the 2D coordinate array into a 1D structure, using a Union Find data structure.  
Initially, I attempted to represent each coordinate as a string (e.g., `"x,y"`), but this resulted in a nested loop (O(n²)) and high memory usage, especially with sparse or large coordinates.  

The smarter approach I found leverages the idea that the **row and column indices can be unified into a 1D key space**.  
By storing `x` as-is and transforming `y` to `~y` (bitwise NOT), we ensure row and column indices occupy different value ranges and thus avoid collision.

This method treats each stone as connecting two "nodes": a row index and a column index.  
If two stones share the same row or column, their corresponding indices are connected via Union Find.  
After processing all connections, the number of connected components (or "islands") represents the number of remaining stones — because in each island, we must leave at least one stone.  
Therefore, the final result is:  
`number_of_stones - number_of_islands`

```python
class Solution:
    def removeStones(self, stones: List[List[int]]) -> int:

        parent = {}

        def find(x):

            if parent[x] != x:
                parent[x] = find(parent[x])

            return parent[x]


        def union(x, y):
            parent.setdefault(x, x)
            parent.setdefault(y, y)

            parent[find(x)] = find(y)

        
        for i,j in stones:
            union(i, ~j)
        
        return len(stones) - len({find(x) for x in parent})
```

## Findings

## Encountered Problems 

Initially, I used `f"{x}{y}"` to construct coordinate keys, but this caused key collisions.
For example, `[12, 3]` and `[1, 23]` both result in "123".
To fix this, I updated the key logic to join the coordinates with a comma (e.g., `"12,3"`), ensuring uniqueness.