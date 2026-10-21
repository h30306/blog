---
title: "LeetCode 1448: Count Good Nodes in Binary Tree"
summary: "LeetCode 1448 note: pass the path maximum down during DFS; a node is good when its value is at least that maximum"
description: "LeetCode 1448 record from 2022-10-29"
date: 2022-10-29
tags: ["medium", "tree", "depth-first-search", "breadth-first-search", "binary-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-10-29
- Submissions: Runtime Error ×2 → Accepted

## Approach

A good node has nothing larger on its path from the root. Pass the path maximum down ([Tree]({{< relref "/algorithm/Tree" >}}) Template 1); count a node whose value is `>=` it, then recurse with the updated maximum.

## My Attempts

The first two versions read an attribute of `None` and used an undefined variable; the third passed.

## Solution

```python
class Solution:
    def goodNodes(self, root: TreeNode) -> int:
        def dfs(node, mx):
            if not node:
                return 0
            good = node.val >= mx
            mx = max(mx, node.val)
            return good + dfs(node.left, mx) + dfs(node.right, mx)
        return dfs(root, root.val)
```

## Complexity

Time `O(n)`, space `O(h)`.

## Mistakes to Avoid

- Use `>=`; equal to the maximum counts (the root always does).

## Interview Explanation

A DFS passes the path maximum down; a node at least that large is good, and recursion continues with the updated maximum. Time `O(n)`.
