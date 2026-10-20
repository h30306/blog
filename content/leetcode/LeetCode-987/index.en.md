---
title: "LeetCode 987: Vertical Order Traversal of a Binary Tree"
summary: "LeetCode 987 note: collect (col, row, val) triples, sort them, and group by column"
description: "LeetCode 987 record from 2026-09-12"
date: 2026-09-12
tags: ["hard", "tree", "binary-tree", "bfs", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-09-12
- Submissions: Accepted (first try)

## Approach

Every node has a coordinate: the root is `(row 0, col 0)`, a left child is `col - 1`, a right child is `col + 1`, and `row` grows by 1.

The output order:

1. Columns from left to right.
2. Within a column, top to bottom.
3. Same column and row: by value, ascending.

That is exactly **lexicographic order on `(col, row, val)`**. Collect each node's triple, sort once, then group by column.

The difficulty is the ordering rule, not the traversal: BFS or DFS both work for collecting.

## My Solution

```python
from collections import deque

class Solution:
    def verticalTraversal(self, root: Optional[TreeNode]) -> List[List[int]]:
        q = deque([(root, 0, 0)])               # (node, col, row)
        cells = []
        while q:
            node, col, row = q.popleft()
            cells.append((col, row, node.val))
            if node.left:
                q.append((node.left, col - 1, row + 1))
            if node.right:
                q.append((node.right, col + 1, row + 1))

        cells.sort()

        res = []
        prev_col = None
        for col, _, val in cells:
            if col != prev_col:
                res.append([])
                prev_col = col
            res[-1].append(val)
        return res
```

My original code grouped by hand with `prev_x` and `curr_x` and appended the last group after the loop. The version above starts a new group whenever the column changes, so there is no last group to add separately.

## Complexity

Time `O(n log n)`, dominated by sorting. Space `O(n)`.

## Mistakes to Avoid

- Grouping by column without sorting by row: BFS goes roughly top to bottom, but within one row, nodes from different subtrees are not ordered by value.
- Not sorting by value within the same column and row, which the problem requires explicitly.
- Forgetting to add the last group when grouping by hand.

## Interview Explanation

I give each node a coordinate: the root is `(0, 0)`, left decreases the column, right increases it, and each level increases the row. The required order is lexicographic on `(column, row, value)`, so I collect all triples, sort once, and group by column. Time `O(n log n)`.
