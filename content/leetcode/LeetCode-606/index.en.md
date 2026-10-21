---
title: "LeetCode 606: Construct String from Binary Tree"
summary: "LeetCode 606 note: output in pre-order, keeping an empty () when only the left subtree is missing, and omitting the right parentheses when it is empty"
description: "LeetCode 606 record from 2022-08-28"
date: 2022-08-28
tags: ["medium", "string", "tree", "depth-first-search", "binary-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-08-28
- Submissions: Wrong Answer → Accepted ×4

## Approach

Pre-order: the value, then the subtrees ([Tree]({{< relref "/algorithm/Tree" >}}) Template 1). Parenthesis rules:

- Leaf: just the value.
- Empty right subtree: omit its parentheses.
- Empty left but non-empty right: **keep an empty `()` on the left**, or the right child would look like a left child.

## My Attempts

Attempt 1 returned a list and wrapped the root in parentheses too: `[1]` returned `['(', '1', ')']` instead of `"1"`.

## Solution

```python
class Solution:
    def tree2str(self, root: Optional[TreeNode]) -> str:
        if not root:
            return ""
        s = str(root.val)
        if root.left or root.right:
            s += f"({self.tree2str(root.left)})"
        if root.right:
            s += f"({self.tree2str(root.right)})"
        return s
```

## Complexity

Time `O(n²)` from string concatenation; collecting into a list and joining gives `O(n)`.

## Mistakes to Avoid

- `()` is needed only when the left subtree alone is missing.
- The root itself has no parentheses.

## Interview Explanation

A pre-order recursion writes the value, then the left subtree in parentheses whenever any child exists (an empty one as `()`), then the right subtree only if it exists. Time `O(n)` to `O(n²)`.
