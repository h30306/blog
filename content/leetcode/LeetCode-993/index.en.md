---
title: "LeetCode 993: Cousins in Binary Tree"
summary: "LeetCode 993 note: cousins share a depth but not a parent; record x's and y's depth and parent during DFS and compare"
description: "LeetCode 993 record from 2022-09-26"
date: 2022-09-26
tags: ["easy", "tree", "depth-first-search", "breadth-first-search", "binary-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-09-26
- Submissions: Wrong Answer ×4 → Runtime Error → Wrong Answer → Accepted ×3

## Approach

Cousins need two conditions: **the same depth** and **different parents** ([Tree]({{< relref "/algorithm/Tree" >}}) Template 1). Carry the parent and depth through the DFS, record them for `x` and `y`, and check both conditions.

## My Attempts

The early versions **compared only depths**, never parents. For `[17, 3, 8]`, `x = 3`, `y = 8` the two are siblings, so the answer is `False`; they returned `True`.

## Solution

```python
class Solution:
    def isCousins(self, root: Optional[TreeNode], x: int, y: int) -> bool:
        info = {}
        def dfs(node, parent, depth):
            if not node:
                return
            if node.val in (x, y):
                info[node.val] = (parent, depth)
            dfs(node.left, node, depth + 1)
            dfs(node.right, node, depth + 1)
        dfs(root, None, 0)
        (px, dx), (py, dy) = info[x], info[y]
        return dx == dy and px is not py
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Siblings on the same level (same parent) are not cousins.

## Interview Explanation

Cousins share a depth but not a parent, so a DFS records each one's depth and parent, and I check both conditions. Time `O(n)`.
