---
title: "LeetCode 1008: Construct Binary Search Tree from Preorder Traversal"
summary: "LeetCode 1008 note: splitting the array is O(n^2); recursing with an upper bound is O(n)"
description: "LeetCode 1008 record from 2025-07-16"
date: 2025-07-16
tags: ["medium", "tree", "bst", "binary-tree", "recursion"]
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
- Submissions: Accepted (first try)

## Approach

The first preorder value is the root. Since it is a BST, every later value smaller than the root belongs to the left subtree and every larger value to the right subtree. Recurse on each side.

## My Solution: split the array and recurse

```python
class Solution:
    def bstFromPreorder(self, preorder: List[int]) -> Optional[TreeNode]:
        if not preorder:
            return None

        root = TreeNode(preorder[0], None, None)
        left = []
        right = []
        for node in preorder[1:]:
            if node < root.val:
                left.append(node)
            else:
                right.append(node)

        if left:
            root.left = self.bstFromPreorder(left)
        if right:
            root.right = self.bstFromPreorder(right)
        return root
```

Correct, and fast for `n <= 100`. But each level scans the rest of the array and builds new lists, so **sorted input** (a chain-shaped tree) makes it `O(n^2)`.

## Better: recurse with an upper bound, O(n)

Take values in preorder one at a time and tell the recursion the largest value this subtree may hold:

- The left subtree's bound is the root's value.
- The right subtree keeps the bound passed down from the parent.
- If the next value exceeds the bound, it does not belong here: return `None` and let an ancestor take it.

```python
class Solution:
    def bstFromPreorder(self, preorder: List[int]) -> Optional[TreeNode]:
        i = 0

        def build(bound: float) -> Optional[TreeNode]:
            nonlocal i
            if i == len(preorder) or preorder[i] > bound:
                return None
            root = TreeNode(preorder[i])
            i += 1
            root.left = build(root.val)
            root.right = build(bound)
            return root

        return build(float("inf"))
```

Each value is consumed once, so it runs in `O(n)`.

## Complexity

| Approach | Time | Space |
|---|---|---|
| Split and recurse | worst `O(n^2)` | `O(n^2)` (new lists per level) |
| Recurse with a bound | `O(n)` | `O(h)` recursion depth |

## Mistakes to Avoid

- `i` is reassigned inside a nested function, so it needs `nonlocal`.
- Using `bound` instead of `root.val` for the left subtree pulls right-subtree values into the left.

## Interview Explanation

The first preorder value is the root, and smaller values after it belong to the left subtree. Splitting the array and recursing is `O(n^2)`, so I consume values in order and recurse with an upper bound: the left subtree's bound is the root value, the right subtree keeps the outer bound, and a value above the bound returns `None`. Each value is handled once, so time is `O(n)`.
