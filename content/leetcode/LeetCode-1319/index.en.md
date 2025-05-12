---
title: "LeetCode 1319: Number of Operations to Make Network Connected"
summary: "LeetCode Problem Solving"
description: "LeetCode Daily"
date: 2025-05-06
tags: ["LeetCode", "blog", "Union Find", "medium"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-05-06
- Total time: 20:00.00

## Intuition

The minimum number of cables required to ensure all computers are connected is `n - 1`, where `n` is the number of computers.  
If the number of available cables `m` is less than `n - 1`, it's impossible to connect all computers.  
So, the idea is to use Union Find to group all computers that are already connected.  
After grouping, we can count how many independent components exist, which tells us how many additional cables are needed.  
During the grouping process, if we try to union two computers that are already connected, we can record that cable as an extra cable.  

At the end, if the number of extra cables is greater than or equal to the number of needed operations (independent groups minus one), we can return that number. Otherwise, return `-1`.


## Approach

```python
class Solution:
    def makeConnected(self, n: int, connections: List[List[int]]) -> int:
        parent = [i for i in range(n)]
        ranking = [0 for _ in range(n)]
        extra = 0
        needed = 0

        def find(n):
            if parent[n] != n:
                parent[n] = find(parent[n])

            return parent[n]

        def union(x, y):
            nonlocal extra
            root_x = find(x)
            root_y = find(y)

            if root_x == root_y:
                extra += 1
                return

            if ranking[root_x] > ranking[root_y]:
                parent[root_y] = parent[root_x]
                ranking[root_x] += ranking[root_y]

            else:
                parent[root_x] = parent[root_y]
                ranking[root_y] += ranking[root_x]

        for x, y in connections:
            union(x, y)

        for i in range(n):
            if parent[i] == i:
                needed += 1
        
        return needed - 1 if (needed-1)<=extra else -1
```

## Findings

## Encountered Problems 