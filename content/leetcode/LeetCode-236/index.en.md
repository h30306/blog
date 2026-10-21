---
title: "LeetCode 236: Lowest Common Ancestor of a Binary Tree"
summary: "LeetCode 236 note: recursion returns whichever of p or q a subtree contains; finding something on both sides means they split here, so this node is the LCA"
description: "LeetCode 236 record from 2022-11-18"
date: 2022-11-18
tags: ["medium", "tree", "depth-first-search", "binary-tree", "binary-lifting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-11-18
- Submissions: Runtime Error → Wrong Answer → Accepted ×6

## Approach

A general binary tree has no ordering, so use return values ([Tree]({{< relref "/algorithm/Tree" >}}) Template 4):

- Reaching `None`, `p` or `q` returns itself.
- Both subtrees return something: `p` and `q` split here, so this node is the LCA.
- Only one side returns something: pass it up.

## My Attempts

The first two versions reused LC 235's BST approach, choosing left or right by value, but **a general binary tree has no ordering**. In `[8, 45, 61]` with `p = 61` and `q = 45` the answer is the root 8; since 8 is smaller than both, it went right. Switching to recursive return values passed.

## Solution

```python
class Solution:
    def lowestCommonAncestor(self, root: 'TreeNode', p: 'TreeNode', q: 'TreeNode') -> 'TreeNode':
        if not root or root is p or root is q:
            return root
        left = self.lowestCommonAncestor(root.left, p, q)
        right = self.lowestCommonAncestor(root.right, p, q)
        if left and right:
            return root
        return left or right
```

## Complexity

Time `O(n)`, space `O(h)`.

## Mistakes to Avoid

- Return immediately at `p` or `q`: if the other lies below, this node is the LCA anyway.

## Interview Explanation

Recursively, `None`, `p` or `q` returns itself. If both sides return something they split here and this node is the LCA; otherwise pass up the non-empty side. Time `O(n)`.
