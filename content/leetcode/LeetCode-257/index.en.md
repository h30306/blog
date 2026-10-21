---
title: "LeetCode 257: Binary Tree Paths"
summary: "LeetCode 257 note: DFS carrying the path string down, adding the whole path at each leaf"
description: "LeetCode 257 record from 2022-08-22"
date: 2022-08-22
tags: ["easy", "string", "backtracking", "tree", "depth-first-search"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-22
- Submissions: Runtime Error ×3 → Accepted ×2

## Approach

Pass the path down during DFS ([Tree]({{< relref "/algorithm/Tree" >}}) Template 1); at a leaf it is a complete path. Values are integers, so convert with `str()` before joining.

## My Attempts

The first three versions all raised TypeError by adding the integer `node.val` directly to the string `"->"`.

## Solution

```python
class Solution:
    def binaryTreePaths(self, root: Optional[TreeNode]) -> List[str]:
        res = []
        def dfs(node, path):
            if not node:
                return
            path = path + [str(node.val)]
            if not node.left and not node.right:
                res.append("->".join(path))
            dfs(node.left, path)
            dfs(node.right, path)
        dfs(root, [])
        return res
```

## Complexity

Time `O(n · h)`, space `O(h)`.

## Mistakes to Avoid

- Integers cannot be concatenated with strings; use `str()` first.

## Interview Explanation

I DFS with the current path and, at each leaf, join it with `->` into the answer. Time `O(n · h)`.
