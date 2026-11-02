---
title: "LeetCode 314: Binary Tree Vertical Order Traversal"
summary: "LeetCode 314 note: BFS with a column index; BFS is what guarantees top-to-bottom within a column and left-to-right within a row"
description: "LeetCode 314 record from 2026-10-22"
date: 2026-10-22
tags: ["medium", "hash-table", "tree", "depth-first-search", "breadth-first-search", "sorting", "binary-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-10-22
- Submissions: Accepted ×2

## Approach

The root is column 0; a left child is column -1 from its parent and a right child +1. Output columns left to right; within a column go **top to bottom**, and nodes in the same row and column go **left to right**.

Walk with BFS ([Tree]({{< relref "/algorithm/Tree" >}}) Template 2) carrying the column index. BFS already visits top to bottom and left to right within a level, so appending to the column's list gives the right order. Finally output the columns in sorted order.

## My Attempts

Accepted on the first try; I submitted the same code twice.

## Solution

```python
class Solution:
    def verticalOrder(self, root: Optional[TreeNode]) -> List[List[int]]:
        cols = defaultdict(list)
        queue = deque([(root, 0)])
        while queue:
            node, col = queue.popleft()
            if node:
                cols[col].append(node.val)
                queue.append((node.left, col - 1))
                queue.append((node.right, col + 1))
        return [cols[c] for c in sorted(cols)]
```

## Complexity

Time `O(n + k log k)` where `k` is the number of columns; space `O(n)`. Tracking the min and max column and iterating between them removes the sort.

## Mistakes to Avoid

- With DFS a deeper node can be visited first, so the order within a column breaks unless the row is stored and sorted.
- Here nodes in the same row and column go left to right; LC 987 sorts them by **value** instead.

## Interview Explanation

I use BFS and carry each node's column: left child minus one, right child plus one. BFS visits top to bottom and left to right within a level, so appending to each column's list already matches the required order. Then I output the columns from smallest to largest: `O(n + k log k)`, or `O(n)` if I track the min and max column.
