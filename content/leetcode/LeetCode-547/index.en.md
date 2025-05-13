---
title: "LeetCode 547: Number of Provinces"
summary: "LeetCode Problem Solving"
description: "LeetCode"
date: 2025-05-04
tags: ["LeetCode", "Union Find", "DFS", "medium"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-05-04
- Total time: 10:00.00

## Intuition

Classic Union-Find problem. At first, I didn't realize that I could use the length of `isConnected` to initialize the `parent` and `rank` arrays. I mistakenly thought I wouldn't know the size of the nodes until I iterated through the `isConnected` array. Therefore, I created dictionaries for these two to record node information. After that, it became a standard Union-Find problem: just iterate through `isConnected`, perform union operations, and we’ll eventually obtain the connected groups.


## Approach

### Union Find
```python
class Solution:
    def findCircleNum(self, isConnected: List[List[int]]) -> int:
        parents = {}
        rank = {}

        def find(x: int):
            root = parents.get(x, x)

            if root != x:
                parent = find(root)
                parents[x] = parent
                return parent  
            else:
                parents[x] = x
                return x

        def union(x, y):
            x_root = find(x)
            y_root = find(y)

            if x_root == y_root:
                return

            x_rank = rank.get(x_root, 1)
            y_rank = rank.get(y_root, 1)

            if x_rank > y_rank:
                rank[x_root] += y_rank
                parents[y_root] = x_root
            
            else:
                
                rank[y_root] = rank.get(y_root, 1) + x_rank
                parents[x_root] = y_root

        for i in range(len(isConnected)):
            for j in range(len(isConnected[0])):
                if isConnected[i][j]:
                    union(i, j)

        return len(set(find(i) for i in range(len(isConnected))))
```
### Union Find w/ known the size
```python
class Solution:
    def findCircleNum(self, isConnected: List[List[int]]) -> int:
        n = len(isConnected)
        parents = [i for i in range(n)]
        rank = [1 for _ in range(n)]

        def find(x: int):
            root = parents[x]

            if root != x:
                parent = find(root)
                parents[x] = parent
                return parent
            else:
                parents[x] = x
                return x

        def union(x, y):
            x_root = find(x)
            y_root = find(y)

            if x_root == y_root:
                return

            x_rank = rank[x_root]
            y_rank = rank[y_root]

            if x_rank > y_rank:
                rank[x_root] += y_rank
                parents[y_root] = x_root
            
            else:
                
                rank[y_root] = rank[y_root] + x_rank
                parents[x_root] = y_root

        for i in range(len(isConnected)):
            for j in range(len(isConnected[0])):
                if isConnected[i][j]:
                    union(i, j)

        return len(set(find(i) for i in range(n)))
```

### DFS
```python
class Solution:
    def findCircleNum(self, isConnected: List[List[int]]) -> int:
        n = len(isConnected)
        seen = set()
        ans = 0

        def dfs(x):
            for idx in range(n):
                if not isConnected[x][idx] or idx in seen:
                    continue
                seen.add(idx)
                dfs(idx)

        for idx in range(n):
            if idx not in seen:
                ans += 1
                dfs(idx)

        return ans
```


## Findings

## Encountered Problems 

Initially, I used the following function to get the size of the result set:
```python
return len(set(parents.values()))
```
However, the blind spot here is that after iterating through all the connections, this approach doesn’t ensure that every node in `parents` is pointing to its final root node. For example:

If the connections are:
- a ↔ b  
- c ↔ d  
- d ↔ e  
- e ↔ b  

When we process the first connection, we might assign the root of `a` to `b`. But after processing the last connection, the root of `b` changes to `e`. Using `parents.values()` directly at this stage would lead to incorrect results. Therefore, we must call `find()` on each node to retrieve its true representative root.

---