---
title: "LeetCode 1372: Longest ZigZag Path in a Binary Tree"
summary: "LeetCode 1372 note: each node returns two values, the longest zigzag starting left and starting right; going left extends the left child's start-right value"
description: "LeetCode 1372 record from 2026-10-24"
date: 2026-10-24
tags: ["medium", "dynamic-programming", "tree", "depth-first-search", "binary-tree", "dp-on-trees"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-10-24
- Submissions: Wrong Answer → Accepted

## Approach

A DFS return value ([Tree]({{< relref "/algorithm/Tree" >}}) Template 1) with two values per node:

- `left`: the longest zigzag (in edges) starting at this node by **going left first**. After stepping to the left child the next step must go right, so `left = left child's right + 1`.
- `right`: going right first, `right = right child's left + 1`.

A null node returns `(-1, -1)`, so a missing left child gives `left = -1 + 1 = 0`. Every node updates the answer with `max(left, right)`.

## My Attempts

1. Adapted from LC 687 (longest univalue path) and kept its "child must have the same value" condition, which this problem does not have: `[2,1,1]` returned 0, the answer is 1.
2. Removing the value check and returning `-1` for null passed.

## Solution

```python
class Solution:
    def longestZigZag(self, root: Optional[TreeNode]) -> int:
        self.longest = 0

        def dfs(node):
            if not node:
                return -1, -1
            _, left_child_right = dfs(node.left)
            right_child_left, _ = dfs(node.right)
            left = left_child_right + 1
            right = right_child_left + 1
            self.longest = max(self.longest, left, right)
            return left, right

        dfs(root)
        return self.longest
```

## Complexity

Time `O(n)`, space `O(h)`.

## Mistakes to Avoid

- Going left continues with the child's "start right" value; the directions cross.
- Null returns -1, not 0, or a missing child counts as a path of length 1.
- Before reusing a template from a similar problem, check that the conditions really match.

## Interview Explanation

Each node returns two values: the longest zigzag starting left and starting right. After going left the next move is right, so `left` is the left child's `right` plus one, and `right` is the right child's `left` plus one. Null returns -1, and every node updates the answer. Time `O(n)`.
