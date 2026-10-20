---
title: "LeetCode 1373: Maximum Sum BST in Binary Tree"
summary: "LeetCode 1373 note: a post-order traversal returns (sum, min, max, is_bst); a node roots a BST when the left max < its value < the right min"
description: "LeetCode 1373 record from 2026-09-10"
date: 2026-09-10
tags: ["hard", "dynamic-programming", "tree-dp", "binary-search-tree", "depth-first-search", "tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-09-10
- Submissions: Wrong Answer → Accepted ×2

## Approach

Deciding whether a subtree is a BST needs the **ranges** of both children. In post-order, each node returns `(sum, lo, hi, is_bst)`:

- An empty node: `(0, +inf, -inf, True)`, so every value passes the comparisons.
- `is_bst` = both children are BSTs and **the left max `<` `node.val` `<` the right min**.
- A BST: the sum is left + right + itself, update the answer, and the range is `(min(lo_left, val), max(hi_right, val))`.
- Otherwise return `is_bst = False`, so the parent fails too.

The answer is at least 0 (the empty subtree).

## My Attempts

Attempt 1 returned only each subtree's maximum and compared with the right subtree's **maximum**, when it should be the right subtree's **minimum**. Take the tree where `2` has right child `8` and `8` has left child `-2`. `-2 < 2`, so the whole tree is not a BST, and the answer is the right subtree `8 + (-2) = 6`. This version checked `2 < 8` (the right max), accepted the whole tree as a BST, and returned 8.

Returning both minimum and maximum passed.

## Solution

```python
class Solution:
    def maxSumBST(self, root: Optional[TreeNode]) -> int:
        best = 0

        def dfs(node: Optional[TreeNode]):
            nonlocal best
            if not node:
                return 0, float("inf"), float("-inf"), True
            ls, llo, lhi, lok = dfs(node.left)
            rs, rlo, rhi, rok = dfs(node.right)
            if lok and rok and lhi < node.val < rlo:   # left max < value < right min
                total = ls + rs + node.val
                best = max(best, total)
                return total, min(llo, node.val), max(rhi, node.val), True
            return 0, 0, 0, False

        dfs(root)
        return best
```

## Complexity

Time `O(n)`, space `O(h)`.

## Mistakes to Avoid

- Comparing with the right subtree's maximum: compare with its minimum.
- An empty node's range is `(+inf, -inf)`, or leaves could never pass.
- The answer may be 0: when every BST sum is negative, choose the empty subtree.

## Interview Explanation

A post-order traversal returns each subtree's sum, minimum, maximum and whether it is a BST. A subtree is a BST when both children are, the left maximum is below the node and the right minimum above it; then I update the answer. Empty nodes return positive and negative infinity as the range. Time `O(n)`.
