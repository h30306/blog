---
title: "LeetCode 1202: Smallest String With Swaps"
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
- Total time: 10:00.00

## Intuition

The problem requires returning the lexicographically smallest string after a series of allowed swaps.  
The swap condition is that two characters can be swapped only if their indices are in the same pair.  
This implies that we can use Union Find to group indices into connected components.  
Then, for each group, we sort the characters and fill the result from smallest to largest.


## Approach
```python
class Solution:
    def smallestStringWithSwaps(self, s: str, pairs: List[List[int]]) -> str:
        uf = UF(s)

        for x, y in pairs:
            uf.union(x, y)

        group_map = defaultdict(list)
        for idx in range(len(s)):
            group_map[uf.find(idx)].append(s[idx])
        
        for i in group_map:
            group_map[i] = sorted(group_map[i], reverse=True)

        s = []
        for parent in uf.parent:
            group = uf.find(parent)
            s.append(group_map[group].pop())

        return "".join(s)


class UF:
    def __init__(self, s):
        n = len(s)
        self.parent = [i for i in range(n)]
        self.ranking = [1] * n

    def find(self, num):

        if self.parent[num] != num:
            self.parent[num] = self.find(self.parent[num])

        return self.parent[num]

    def union(self, x, y):
        root_x = self.find(x)
        root_y = self.find(y)

        if root_x == root_y:
            return

        if self.ranking[root_x] > self.ranking[root_y]:
            self.parent[root_y] = self.parent[root_x]
            self.ranking[root_x] += self.ranking[root_y]

        else:
            self.parent[root_x] = self.parent[root_y]
            self.ranking[root_y] += self.ranking[root_x]
```
## Findings

## Encountered Problems 