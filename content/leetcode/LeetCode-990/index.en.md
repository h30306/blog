---
title: "LeetCode 990: Satisfiability of Equality Equations"
summary: "LeetCode Problem Solving"
description: "LeetCode Daily"
date: 2025-05-10
tags: ["LeetCode", "blog", "Union Find", "medium"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-05-10
- Total time: 10:00.00

## Intuition

This is a Union Find problem.  
We first iterate through the equations. When the operation is `==`, it means the two characters should belong to the same group, so we perform a union operation on them.  

After building the groups, we iterate through the equations again, this time checking for `!=`. If two characters are in the same group but are expected to be unequal, the constraint is violated.  

To simplify indexing for the Union Find structure, we convert each character to a number using `ord()`, and subtract `ord('a')` so that the indices start from 0.


## Approach

```python
class Solution:
    def equationsPossible(self, equations: List[str]) -> bool:
        parent = [i for i in range(26)]

        def find(ord_x):
            if parent[ord_x] != ord_x:
                parent[ord_x] = find(parent[ord_x])

            return parent[ord_x]

        def union(ord_x, ord_y):

            root_x = find(ord_x)
            root_y = find(ord_y)

            if root_x == root_y:
                return
            
            parent[root_x] = parent[root_y]

        for equation in equations:
            if equation[1] == "!":
                continue
            ord_x = ord(equation[0])-ord("a")
            ord_y = ord(equation[3])-ord("a")
            
            union(ord_x, ord_y)

        for equation in equations:
            if equation[1] == "!" and find(ord(equation[0])-ord("a")) == find(ord(equation[3])-ord("a")):
                return False
        return True
```

## Findings

## Encountered Problems 