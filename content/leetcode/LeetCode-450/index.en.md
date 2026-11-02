---
title: "LeetCode 450: Delete Node in a BST"
summary: "LeetCode 450 note: once the node is found: with zero or one child, splice the child in; with two, copy the right subtree's minimum and delete that node"
description: "LeetCode 450 record from 2026-10-25"
date: 2026-10-25
tags: ["medium", "tree", "binary-search-tree", "binary-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-10-25
- Submissions: Accepted ×2

## Approach

Recurse to find the node and return the root of the subtree after deletion, so the parent can reattach it (`root.left = self.deleteNode(root.left, key)`).

When the node to delete is found:

- No left child: return the right child (this also covers no children).
- No right child: return the left child.
- Two children: find the minimum of the right subtree (the in-order successor, keep going left), copy its value into the current node, then delete the successor from the right subtree. The successor has no left child, so deleting it always hits one of the first two cases.

## My Attempts

Accepted on the first try; I resubmitted the same code with a comment added.

## Solution

```python
class Solution:
    def deleteNode(self, root: Optional[TreeNode], key: int) -> Optional[TreeNode]:
        if not root:
            return None
        if key < root.val:
            root.left = self.deleteNode(root.left, key)
        elif key > root.val:
            root.right = self.deleteNode(root.right, key)
        else:
            if not root.left:
                return root.right
            if not root.right:
                return root.left
            succ = root.right
            while succ.left:
                succ = succ.left
            root.val = succ.val
            root.right = self.deleteNode(root.right, succ.val)
        return root
```

## Complexity

Time `O(h)`: finding the node, finding the successor and deleting it each follow a single downward path. Space `O(h)`.

## Mistakes to Avoid

- Return the new subtree root so the parent reattaches it; changing a local variable does not change the tree.
- With two children, delete the successor from the **right subtree** after copying its value, not the original `key` (it has been overwritten).
- If `key` is not in the tree, return the tree unchanged.

## Interview Explanation

I recurse down and always return the subtree root after deletion so the parent can reattach it. When I find the node, if it is missing a child I return the other one; with two children I copy the smallest value of the right subtree into it and delete that node from the right subtree, which is easy because it has no left child. Time `O(h)`.
