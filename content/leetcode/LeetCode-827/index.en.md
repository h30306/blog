---
title: "LeetCode 827: Making A Large Island"
summary: "LeetCode 827 note: label every island and record its size, then for each 0 add the sizes of the distinct neighboring islands plus 1"
description: "LeetCode 827 record from 2026-10-17"
date: 2026-10-17
tags: ["hard", "dfs", "bfs", "matrix", "union-find"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-10-17
- Submissions: Accepted ×2 (recursive DFS) → Accepted (iterative rewrite)

## Approach

Flip at most one 0 to 1 and report the size of the largest island.

Brute force flips every 0 and recomputes the largest island, `O(n^4)`, too slow.

**Precompute island information instead**:

1. First pass: label each island (starting at 2, so labels never clash with 0 and 1), rewrite its cells with the label, and record each label's size in a dict.
2. Second pass: for each 0, look at the islands its four neighbors belong to, **deduplicate with a set**, add their sizes, and add 1 for the cell itself.

If the grid has no 0 at all, the answer is the size of that single island.

## My Solution

```python
class Solution:
    def largestIsland(self, grid: List[List[int]]) -> int:
        n = len(grid)
        size = {}
        label = 2
        dirs = ((1, 0), (-1, 0), (0, 1), (0, -1))

        for r in range(n):
            for c in range(n):
                if grid[r][c] != 1:
                    continue
                grid[r][c] = label
                stack, count = [(r, c)], 1
                while stack:
                    x, y = stack.pop()
                    for dx, dy in dirs:
                        nx, ny = x + dx, y + dy
                        if 0 <= nx < n and 0 <= ny < n and grid[nx][ny] == 1:
                            grid[nx][ny] = label
                            count += 1
                            stack.append((nx, ny))
                size[label] = count
                label += 1

        best = max(size.values(), default=0)
        for r in range(n):
            for c in range(n):
                if grid[r][c] == 0:
                    labels = {grid[r + dr][c + dc] for dr, dc in dirs
                              if 0 <= r + dr < n and 0 <= c + dc < n and grid[r + dr][c + dc] > 1}
                    best = max(best, 1 + sum(size[l] for l in labels))
        return best
```

The first version labeled islands with a recursive DFS; with `n = 500`, an island can have `2.5 * 10^5` cells and the recursion may go too deep. The third version switched to an explicit stack.

## Complexity

Time `O(n^2)`, space `O(n^2)`.

## Mistakes to Avoid

- Adding the same island twice when two neighbors belong to it: always deduplicate labels with a set.
- Starting labels at 1: they mix with the original land value 1, so labeled and unlabeled cells look the same.
- Forgetting the all-ones grid: with no 0 to flip, the answer is the whole island's size.

## Interview Explanation

In one pass I label each island starting from 2 and record each label's size. Then for every 0, I collect the island labels of its four neighbors, deduplicate them with a set, and add their sizes plus 1, which is the island formed by flipping that cell. The answer is the maximum over all zeros, also covering the all-land case. Two passes, `O(n^2)` time.
