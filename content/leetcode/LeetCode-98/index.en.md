---
title: "LeetCode 98: Validate Binary Search Tree"
summary: "LeetCode 98 note: every node has a valid range (low, high); going left the upper bound becomes the node and going right the lower bound does; comparing parent and child is not enough"
description: "LeetCode 98 record from 2022-10-29"
date: 2022-10-29
tags: ["medium", "tree", "depth-first-search", "binary-search-tree", "binary-tree"]
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
- Submissions: Runtime Error ×2 → Wrong Answer ×2 → Runtime Error → Wrong Answer ×2 → Accepted → Wrong Answer → Runtime Error ×3 → Wrong Answer ×3 → Accepted
- 2026-10-24 rewrite: Wrong Answer → Accepted ×2 → Wrong Answer → Accepted

## Approach

A BST needs the **entire** left subtree below the node and the entire right subtree above it, not just the children ([Tree]({{< relref "/algorithm/Tree" >}}) Template 3). Pass a range `(lo, hi)` down:

- The node's value must be strictly inside it.
- Going left the upper bound becomes the node's value; going right the lower bound does.

## My Attempts

This took 16 submissions, mostly from **comparing only parents with children**: in `[15, None, 22, 12]`, 22 exceeds 15 and 12 is below 22, so every parent-child pair is fine; but 12 sits in 15's right subtree while being smaller than 15, so the answer is `False`; it returned `True`. Other errors: equal values were allowed (`[9, 9]` returned `True`), a node with one child returned `True` immediately, and one returned a tuple.

## Solution

```python
class Solution:
    def isValidBST(self, root: Optional[TreeNode]) -> bool:
        def ok(node, lo, hi):
            if not node:
                return True
            if not lo < node.val < hi:
                return False
            return ok(node.left, lo, node.val) and ok(node.right, node.val, hi)
        return ok(root, float("-inf"), float("inf"))
```

## 2026-10 Rewrite

This time I wrote three versions and got it wrong twice:

1. Repeated the 2022 mistake: a post-order recursion that **only compared a node with its children**. In `[5,4,6,null,null,3,7]` every parent-child pair is fine, but 3 sits in 5's right subtree while being smaller than 5; it returned `True`, the answer is `False`.
2. Switched to a post-order returning `(valid, subtree min, subtree max)` and checked `left max < node < right min`; accepted.
3. Rewrote the bounds version from above; also accepted.
4. Iterative in-order: `prev` held the previous **value**, and the check was `if prev and curr.val <= prev`. When the previous value is 0, `prev` is falsy and the check is skipped: `[0,null,0]` returned `True`, the answer is `False`.
5. Storing the **node** in `prev` (a node object is always truthy) passed; the more direct fix is `prev is not None`.

```python
class Solution:
    def isValidBST(self, root: Optional[TreeNode]) -> bool:
        stack, prev, curr = [], None, root
        while curr or stack:
            while curr:
                stack.append(curr)
                curr = curr.left
            curr = stack.pop()
            if prev is not None and curr.val <= prev:
                return False
            prev = curr.val
            curr = curr.right
        return True
```

## Complexity

Time `O(n)`, space `O(h)`. An in-order traversal checking strict increase also works.

## Mistakes to Avoid

- Comparing a node with its children is not enough; a grandchild may break an ancestor's range.
- Strict inequalities: equal values are invalid.

## Interview Explanation

A BST constrains whole subtrees, so I pass a valid range down, tightening the upper bound going left and the lower bound going right, and require every node strictly inside. Time `O(n)`.
