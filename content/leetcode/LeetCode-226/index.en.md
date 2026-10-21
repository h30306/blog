---
title: "LeetCode 226: Invert Binary Tree"
summary: "LeetCode 226 note: swap every node's children, using a simultaneous assignment so the already-changed side is not reused"
description: "LeetCode 226 record from 2022-08-21"
date: 2022-08-21
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
First Attempt: 2022-08-21
- Submissions: Runtime Error ×4 → Accepted ×3 → Runtime Error → Accepted → Wrong Answer → Accepted ×2

## Approach

Swap every node's subtrees and recurse on both ([Tree]({{< relref "/algorithm/Tree" >}}) Template 1). Assign both at once with `root.left, root.right = right, left`: the right side is evaluated first, so the right never receives the already-modified left.

## My Attempts

The first versions returned something other than a tree (such as a list) or missed the empty tree. Later one version used two lines:

```text
root.left = invert(root.right)
root.right = invert(root.left)   # root.left is already the new one here
```

The second line used the already-replaced left subtree, so the original left subtree was lost. For `[1, 4]` the answer is `[1, None, 4]`; it returned `[1]`.

## Solution

```python
class Solution:
    def invertTree(self, root: Optional[TreeNode]) -> Optional[TreeNode]:
        if root:
            root.left, root.right = self.invertTree(root.right), self.invertTree(root.left)
        return root
```

## Complexity

Time `O(n)`, space `O(h)`.

## Mistakes to Avoid

- Written as two lines, the second line's `root.left` is already the new value.

## Interview Explanation

I swap each node's subtrees and recurse on both, assigning simultaneously to avoid overwriting. Time `O(n)`.
