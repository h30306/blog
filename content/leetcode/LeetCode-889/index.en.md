---
title: "LeetCode 889: Construct Binary Tree from Preorder and Postorder Traversal"
summary: "LeetCode 889 note: keep the current path on a stack; when its top equals the next postorder value that subtree is complete and is popped; new nodes go left first"
description: "LeetCode 889 record from 2026-10-29"
date: 2026-10-29
tags: ["medium", "array", "hash-table", "divide-and-conquer", "tree", "binary-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-10-29
- Submissions: Accepted (first try)

## Approach

Pre-order is "root, left, right" and post-order is "left, right, root". When a node appears in post-order, its whole subtree is finished.

Read pre-order in order ([Tree]({{< relref "/algorithm/Tree" >}}) Template 9):

- The stack holds the nodes on the current root-to-node path whose subtrees are not finished.
- Before placing a new node, check whether the stack top equals the value at the post-order pointer. If so, that subtree is complete: pop it and advance the pointer, and repeat.
- The new node is a child of the stack top: the left child if the top has none yet, otherwise the right child. Then push it.

For a node with a single child, pre-order and post-order cannot tell left from right. Any valid answer is accepted, and this version always uses the left.

## My Attempts

Accepted on the first try.

## Solution

```python
class Solution:
    def constructFromPrePost(self, preorder: List[int], postorder: List[int]) -> Optional[TreeNode]:
        root = TreeNode(preorder[0])
        stack = [root]
        j = 0
        for val in preorder[1:]:
            node = TreeNode(val)
            while stack[-1].val == postorder[j]:
                stack.pop()
                j += 1
            if not stack[-1].left:
                stack[-1].left = node
            else:
                stack[-1].right = node
            stack.append(node)
        return root
```

Recursive alternative: `preorder[1]` is the left subtree's root; its position in post-order gives the left subtree's size, so split both arrays and recurse. With a hash map of post-order positions it is also `O(n)`.

## Complexity

Time `O(n)`: each node is pushed and popped once. Space `O(h)`.

## Mistakes to Avoid

- Pop **before** attaching the new node, with a `while`: several subtrees can finish at once.
- The answer is not unique, so a single-child node needs no special handling.

## Interview Explanation

A node showing up in post-order means its subtree is done. I read pre-order with a stack of unfinished nodes; for each new node I first pop while the top equals the current post-order value, then attach the new node to the top, left if empty, else right. Each node is pushed and popped once, so it is `O(n)`.
