---
title: "LeetCode 897: Increasing Order Search Tree"
summary: "LeetCode 897 note: in-order traversal appending nodes to a right-only chain with left children cleared; keep the dummy separate from the moving tail"
description: "LeetCode 897 record from 2022-09-25"
date: 2022-09-25
tags: ["easy", "stack", "tree", "depth-first-search", "binary-search-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-09-25
- Submissions: Accepted ×2 → Runtime Error ×3 → Wrong Answer ×4 → Accepted ×2

## Approach

In-order yields nodes in ascending order ([Tree]({{< relref "/algorithm/Tree" >}}) Template 3). With a dummy and a `tail` pointer, attach each node at `tail.right`, clear its `left`, and advance `tail`. Return `dummy.right`.

## My Attempts

The first versions read attributes of `None`. Later errors were all about the dummy: **moving the dummy itself as the tail**, so the final `dummy.right` was the last node's right (`None`); `[7]` returned nothing and `[6, 0]` kept only `[6]`.

## Solution

```python
class Solution:
    def increasingBST(self, root: TreeNode) -> TreeNode:
        dummy = tail = TreeNode()
        stack, cur = [], root
        while cur or stack:
            while cur:
                stack.append(cur)
                cur = cur.left
            cur = stack.pop()
            cur.left = None
            tail.right = tail = cur
            cur = cur.right
        return dummy.right
```

## Complexity

Time `O(n)`, space `O(h)`.

## Mistakes to Avoid

- Move `tail`; keep `dummy` in place to return the head.
- Clearing `cur.left` is safe: its left subtree is already done.

## Interview Explanation

An iterative in-order walk gives nodes in ascending order; I attach each to the tail's right, clear its left, and return the dummy's right. Time `O(n)`.
