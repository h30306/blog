---
title: "LeetCode 733: Flood Fill"
summary: "LeetCode 733 note: DFS or BFS from the start, recoloring 4-directional cells that share the start's original color; return immediately if the colors are equal"
description: "LeetCode 733 record from 2022-09-03"
date: 2022-09-03
tags: ["easy", "array", "depth-first-search", "breadth-first-search", "matrix"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-09-03
- Submissions: Runtime Error ×6 → Accepted → Runtime Error ×12 → Accepted → Runtime Error ×5 → Accepted ×2

## Approach

A connected component ([BFS]({{< relref "/algorithm/BFS" >}}) Template 2): remember the start's original color `old`, spread up, down, left and right, and recolor and continue only on in-bounds cells **whose** color is `old`. If `old == color`, return immediately; otherwise recolored cells still look like `old` and the search never ends.

## My Attempts

This took 27 submissions in one evening, nearly all Runtime Errors:

- Attempt 1 used a queue but checked the four **diagonal** neighbors.
- With recursive DFS the bound became `x > row and y > column`: **`and` instead of `or`**, with `row` and `column` swapped, so IndexErrors kept coming.
- Several versions ignored "new color equals old color", so recolored cells still matched and **the recursion never ended**.
- Four `or`ed bounds plus stopping at `image[r][c] == color` finally passed.

## Solution

```python
class Solution:
    def floodFill(self, image: List[List[int]], sr: int, sc: int, color: int) -> List[List[int]]:
        old = image[sr][sc]
        if old == color:
            return image
        m, n = len(image), len(image[0])
        stack = [(sr, sc)]
        image[sr][sc] = color
        while stack:
            i, j = stack.pop()
            for x, y in ((i + 1, j), (i - 1, j), (i, j + 1), (i, j - 1)):
                if 0 <= x < m and 0 <= y < n and image[x][y] == old:
                    image[x][y] = color
                    stack.append((x, y))
        return image
```

## Complexity

Time `O(mn)`, space `O(mn)`.

## Mistakes to Avoid

- The bounds test is `x < 0 or y < 0 or x >= m or y >= n`, all joined by `or`, not `and`.
- Rows are `len(image)` and columns `len(image[0])`; do not swap them.
- Return immediately when the colors are equal.
- Only the four orthogonal directions count, not diagonals.

## Interview Explanation

I remember the start's original color and spread in four directions, recoloring and continuing on in-bounds cells of that color; equal old and new colors return immediately to avoid looping forever. Time `O(mn)`.
