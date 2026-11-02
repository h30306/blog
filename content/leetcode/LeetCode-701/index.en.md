---
title: "LeetCode 701: Insert into a Binary Search Tree"
summary: "LeetCode 701 note: walk down the BST to an empty spot and attach the new node; an empty tree must return the new node"
description: "LeetCode 701 record from 2026-10-24"
date: 2026-10-24
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
First Attempt: 2026-10-24
- Submissions: Wrong Answer → Runtime Error ×3 → Accepted

## Approach

A new value can always go under some leaf: start at the root, go right if the value is larger and left if smaller, and attach the new node at the first empty spot ([Tree]({{< relref "/algorithm/Tree" >}}) Template 3). The value is guaranteed not to be in the tree.

## My Attempts

The main logic was right the first time; the mistakes were all about the **empty tree**:

1. No empty-tree case: with `root = None` it returned `None`, but the answer is a tree with only the new node.
2. Added the check but wrote `node.left = TreeNode(val)`: `node` was not defined yet, a Runtime Error.
3. Changed it to `if not root:` but the next line still used `node.left`; same error.
4. Changed it to `root.left = ...`, but `root` itself is `None`, an AttributeError.
5. `return TreeNode(val)` passed.

## Solution

```python
class Solution:
    def insertIntoBST(self, root: Optional[TreeNode], val: int) -> Optional[TreeNode]:
        if not root:
            return TreeNode(val)
        node = root
        while True:
            if val > node.val:
                if not node.right:
                    node.right = TreeNode(val)
                    break
                node = node.right
            else:
                if not node.left:
                    node.left = TreeNode(val)
                    break
                node = node.left
        return root
```

The recursive version is shorter:

```python
class Solution:
    def insertIntoBST(self, root: Optional[TreeNode], val: int) -> Optional[TreeNode]:
        if not root:
            return TreeNode(val)
        if val > root.val:
            root.right = self.insertIntoBST(root.right, val)
        else:
            root.left = self.insertIntoBST(root.left, val)
        return root
```

## Complexity

Time `O(h)`. Space `O(1)` iteratively, `O(h)` recursively.

## Mistakes to Avoid

- With an empty tree there is no node to attach to; return the new node.
- Never read an attribute of `None`.

## Interview Explanation

I walk down from the root, right when the value is larger and left when smaller, attach the new node at the first empty spot, and return the original root. For an empty tree I return the new node. Time `O(h)`, and the iterative version uses `O(1)` space.
