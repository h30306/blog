---
title: "LeetCode 988: Smallest String Starting From Leaf"
summary: "LeetCode 988 note: DFS prepending each character so the string at a leaf already reads leaf to root, and keep the smallest"
description: "LeetCode 988 record from 2024-04-17"
date: 2024-04-17
tags: ["medium", "string", "backtracking", "tree", "depth-first-search"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2024-04-17
- Submissions: Accepted (first try)

## Approach

The string reads from leaf to root, so **prepend** each character on the way down ([Tree]({{< relref "/algorithm/Tree" >}}) Template 1); at a leaf the string is complete, compared with the best so far. Picking the smaller side at each node and building upward is wrong, since a shared suffix can change the comparison.

## My Solution

```python
class Solution:
    def smallestFromLeaf(self, root: Optional[TreeNode]) -> str:
        best = None
        def dfs(node, s):
            nonlocal best
            if not node:
                return
            s = chr(ord("a") + node.val) + s
            if not node.left and not node.right:
                if best is None or s < best:
                    best = s
            dfs(node.left, s)
            dfs(node.right, s)
        dfs(root, "")
        return best
```

## Complexity

Time `O(n · h)`, space `O(h)`.

## Mistakes to Avoid

- The direction is leaf to root, so prepend characters.

## Interview Explanation

During DFS I prepend each node's character, so at a leaf the string reads leaf to root, and I keep the smallest. Time `O(n · h)`.
