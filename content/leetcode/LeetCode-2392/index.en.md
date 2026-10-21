---
title: "LeetCode 2392: Build a Matrix With Conditions"
summary: "LeetCode 2392 note: row and column conditions are independent, so run one topological sort for each; put x at its row and column positions, and return an empty matrix if either has a cycle"
description: "LeetCode 2392 record from 2026-08-01"
date: 2026-08-01
tags: ["hard", "graph", "topological-sort", "matrix"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-08-01
- Submissions: Accepted ×2 (the second only removed debug prints)

## Approach

Each number appears exactly once and the `k × k` matrix has `k` rows and `k` columns, so **every row and every column can hold exactly one number**.

- Row conditions only decide "who is above", column conditions only "who is to the left"; they are independent.
- One [Topological Sort]({{< relref "/algorithm/Topological-Sort" >}}) on the row conditions gives each number's row; another on the column conditions gives its column.
- Put `x` at `(row_pos[x], col_pos[x])`. A cycle on either side (fewer than `k` sorted) means an empty matrix.

## My Solution

I originally used a heap for the zero in-degree nodes plus a `seen` set; a plain queue is enough:

```python
class Solution:
    def buildMatrix(self, k: int, rowConditions: List[List[int]], colConditions: List[List[int]]) -> List[List[int]]:
        def order(conditions):
            adj = [[] for _ in range(k + 1)]
            indeg = [0] * (k + 1)
            for u, v in conditions:
                adj[u].append(v)
                indeg[v] += 1
            q = deque(x for x in range(1, k + 1) if indeg[x] == 0)
            res = []
            while q:
                x = q.popleft()
                res.append(x)
                for y in adj[x]:
                    indeg[y] -= 1
                    if indeg[y] == 0:
                        q.append(y)
            return res if len(res) == k else None   # cycle

        rows, cols = order(rowConditions), order(colConditions)
        if rows is None or cols is None:
            return []
        col_pos = {x: j for j, x in enumerate(cols)}
        mat = [[0] * k for _ in range(k)]
        for i, x in enumerate(rows):
            mat[i][col_pos[x]] = x
        return mat
```

## Complexity

Time `O(k² + n + m)` (building the matrix is `k²`), space `O(k² + n + m)`.

## Mistakes to Avoid

- With a cycle, return an empty matrix, not a partial result.
- Numbers run from 1 to `k`, so size arrays `k + 1` (or subtract 1 everywhere).

## Interview Explanation

Row and column conditions are independent, so I topologically sort each set, giving every number its own row and column; since each number appears once, one per row and column fits exactly. If either sort produces fewer than `k` numbers there is a cycle, so I return an empty matrix. Time `O(k² + n + m)`.
