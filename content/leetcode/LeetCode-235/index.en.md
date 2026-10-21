---
title: "LeetCode 235: Lowest Common Ancestor of a Binary Search Tree"
summary: "LeetCode 235 note: go left when both p and q are smaller, right when both are larger; otherwise (split, or one is the node itself) this node is the LCA"
description: "LeetCode 235 record from 2022-08-22"
date: 2022-08-22
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
First Attempt: 2022-08-22
- Submissions: Runtime Error → Accepted ×2 → Wrong Answer → Runtime Error → Accepted → Runtime Error → Wrong Answer → Runtime Error → Accepted → Runtime Error → Accepted

## Approach

Use the BST ordering instead of searching the whole tree ([Tree]({{< relref "/algorithm/Tree" >}}) Template 4):

- Both `p` and `q` smaller: the LCA is in the left subtree.
- Both larger: in the right subtree.
- Otherwise they split, or one is the current node: the current node is the LCA.

## My Attempts

The recursive version passed quickly. Converting it to iteration, attempt 1 **forgot the `while` loop**, stepping down once and returning nothing; attempt 2 was missing a colon. A November rewrite hit an undefined variable and a `None` attribute access.

## Solution

```python
class Solution:
    def lowestCommonAncestor(self, root: 'TreeNode', p: 'TreeNode', q: 'TreeNode') -> 'TreeNode':
        node = root
        while True:
            if p.val < node.val and q.val < node.val:
                node = node.left
            elif p.val > node.val and q.val > node.val:
                node = node.right
            else:
                return node
```

## Complexity

Time `O(h)`, space `O(1)`.

## Mistakes to Avoid

- When one node is the other's ancestor, the answer is that ancestor; the conditions must allow equality.

## Interview Explanation

From the root I go left while both are smaller and right while both are larger; otherwise they split here or one is this node, so I return it. Time `O(h)`, space `O(1)`.
