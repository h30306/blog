---
title: "LeetCode 104: Maximum Depth of Binary Tree"
summary: "LeetCode 104 note: depth is 1 plus the larger subtree depth, with 0 for an empty tree"
description: "LeetCode 104 record from 2022-08-02"
date: 2022-08-02
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
First Attempt: 2022-08-02
- Submissions: Accepted → Runtime Error → Accepted ×2 → Wrong Answer ×2 → Accepted → Runtime Error → Accepted ×3

## Approach

A post-order return value ([Tree]({{< relref "/algorithm/Tree" >}}) Template 1): an empty tree has depth 0, otherwise `1 + max(left depth, right depth)`.

## My Attempts

The first version passed. Rewriting it as a DFS with a `depth` parameter, a leaf returned 0 instead of the current `depth` (`[5]` returned 0), and one version returned `None` for an empty tree.

## Solution

```python
class Solution:
    def maxDepth(self, root: Optional[TreeNode]) -> int:
        if not root:
            return 0
        return 1 + max(self.maxDepth(root.left), self.maxDepth(root.right))
```

## Complexity

Time `O(n)`, space `O(h)`.

## Mistakes to Avoid

- Every path of the recursive function needs a return value.

## Interview Explanation

An empty tree has depth 0, otherwise 1 plus the deeper subtree, computed by post-order recursion. Time `O(n)`, space `O(h)`.
