---
title: "LeetCode 417: Pacific Atlantic Water Flow"
summary: "LeetCode 417 note: walk inward from each ocean's shore to cells no lower than the current one; cells reached from both oceans are the answer"
description: "LeetCode 417 record from 2022-10-30"
date: 2022-10-30
tags: ["medium", "array", "depth-first-search", "breadth-first-search", "matrix"]
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
- Submissions: Runtime Error ×4 → Wrong Answer → Runtime Error ×2 → Wrong Answer ×5 → Time Limit Exceeded → Runtime Error → Time Limit Exceeded → Runtime Error ×2 → Wrong Answer ×3 → Accepted ×2

## Approach

Flowing down from every cell to find an ocean is `O((mn)²)` in the worst case. Reverse it ([BFS]({{< relref "/algorithm/BFS" >}}) Template 3, multi-source): start from the Pacific shore (first row and column) and move to cells **no lower** than the current one; everything reached can drain into the Pacific. Do the same for the Atlantic (last row and column). The intersection is the answer, `O(mn)` per ocean.

## My Attempts

This took 22 submissions:

- In the afternoon I wrote "flow down from every cell" DFS, with the Atlantic edge test **swapping rows and columns** (`i == len(heights[0]) - 1`), wrong for non-square grids; once fixed, re-running DFS from every cell timed out twice.
- In the evening I switched to walking inward from the shores and erred in three places: stopping on `<= prev`, **which rejects each start immediately since its height equals `prev`** (`[[1]]` returned `[]`); `visit.add([r, c])` inserting a list (TypeError); and adding the last column to the Pacific set. Fixing all three passed.

## Solution

```python
class Solution:
    def pacificAtlantic(self, heights: List[List[int]]) -> List[List[int]]:
        m, n = len(heights), len(heights[0])
        def reach(starts):
            seen = set(starts)
            stack = list(starts)
            while stack:
                i, j = stack.pop()
                for x, y in ((i + 1, j), (i - 1, j), (i, j + 1), (i, j - 1)):
                    if (0 <= x < m and 0 <= y < n and (x, y) not in seen
                            and heights[x][y] >= heights[i][j]):
                        seen.add((x, y))
                        stack.append((x, y))
            return seen
        pacific = reach([(0, j) for j in range(n)] + [(i, 0) for i in range(m)])
        atlantic = reach([(m - 1, j) for j in range(n)] + [(i, n - 1) for i in range(m)])
        return [[i, j] for i, j in pacific & atlantic]
```

## Complexity

Time `O(mn)`, space `O(mn)`.

## Mistakes to Avoid

- Walking in reverse, the condition is "no lower" (`>=`); equal heights still flow.
- The start cells belong to the set themselves and must not be rejected by a "higher than previous" test.
- The Pacific is the first row and column, the Atlantic the last row and column; do not mix up the sets.
- Put tuples in a `set`; lists are unhashable.

## Interview Explanation

Searching downhill from every cell is slow, so I reverse it: from each ocean's shore I move to cells no lower than the current one, collecting what can drain into each ocean, and intersect the two sets. One pass per ocean gives `O(mn)`.
