---
title: "LeetCode 958: Check Completeness of a Binary Tree"
summary: "LeetCode 958 note: completeness is a global property, so check with BFS whether any node follows the first gap"
description: "LeetCode 958 record from 2025-07-16"
date: 2025-07-16
tags: ["medium", "tree", "binary-tree", "bfs"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-07-16
- Submissions: Wrong Answer → Accepted (next day)

## Approach

A complete binary tree has every level full except possibly the last, and the last level's nodes are as far left as possible.

From a BFS point of view: **list the nodes in level order, including empty children. After the first gap, no real node may appear.**

## My First Attempt: recursively checking both subtrees

```python
def isCompleteTree(self, root):
    if root.val == None:
        return True
    completed_left = False
    completed_right = False
    if root.left:
        completed_left = self.isCompleteTree(root.left)
    if root.right:
        completed_right = self.isCompleteTree(root.right)

    completed = True
    if root.left and root.right:
        if not completed_left or not completed_right:
            completed = False
    else:
        if not completed_left and completed_right:
            completed = False
    return completed
```

The mistake is **treating a global property as a local one**. Two complete subtrees do not make a complete tree. For example, with a left subtree of height 2 and a right subtree of height 3, both are complete, but the combined last level is not left-aligned.

A recursive solution would also need to return heights and whether each subtree is perfect, which gets complicated. BFS is more direct.

Also, `root.val == None` checks the node's value, not the node itself, so the line does nothing.

## Solution

```python
from collections import deque

class Solution:
    def isCompleteTree(self, root: Optional[TreeNode]) -> bool:
        if not root:
            return True

        q = deque([root])
        while q[0] is not None:          # walk until the first gap
            node = q.popleft()
            q.append(node.left)          # push None on purpose
            q.append(node.right)

        while q and q[0] is None:        # drop the consecutive gaps
            q.popleft()

        return not q                     # any node after a gap breaks completeness
```

This is one of the few BFS problems that **pushes `None` into the queue on purpose**.

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Concluding the whole tree is complete because both subtrees are.
- Writing `root.val == None` when you mean `root is None`.

## Interview Explanation

In level order, a complete binary tree never has a node after its first gap. I run BFS and push empty children too, stopping at the first `None`. Then I drop the run of `None` values; if anything is left in the queue, a node follows a gap, so the tree is not complete. Time and space are `O(n)`.
