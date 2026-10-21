---
title: "LeetCode 965: Univalued Binary Tree"
summary: "LeetCode 965 note: every value must equal the root's; compare values while recursing, not the booleans the recursion returns"
description: "LeetCode 965 record from 2022-09-26"
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
- Submissions: Wrong Answer ×3 → Runtime Error ×2 → Wrong Answer ×2 → Runtime Error → Wrong Answer ×2 → Accepted → Runtime Error → Wrong Answer → Runtime Error → Accepted → Runtime Error → Accepted ×2

## Approach

Every node must match the root's value ([Tree]({{< relref "/algorithm/Tree" >}}) Template 1). Recursively: this node equals the target, and both subtrees do too. An empty subtree violates nothing and returns `True`.

## My Attempts

This took 18 submissions, most with the same bug: `node.val == self.isUnivalTree(node.left) == self.isUnivalTree(node.right)` **compared the node's value with the booleans returned by the recursion**. For a single node `[2]` both sides return `True`, and `2 == True` fails, so it returned `False`. Passing the target value instead then hit a few undefined variables.

## Solution

```python
class Solution:
    def isUnivalTree(self, root: Optional[TreeNode]) -> bool:
        def same(node):
            return not node or (node.val == root.val and same(node.left) and same(node.right))
        return same(root)
```

## Complexity

Time `O(n)`, space `O(h)`.

## Mistakes to Avoid

- The recursion returns booleans; do not compare them with node values.

## Interview Explanation

I recursively check that every node equals the root's value, treating empty subtrees as fine, and return `True` only if all pass. Time `O(n)`.
