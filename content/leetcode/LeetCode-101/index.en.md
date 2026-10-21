---
title: "LeetCode 101: Symmetric Tree"
summary: "LeetCode 101 note: the left and right subtrees must mirror each other, outer with outer and inner with inner; compare values, not node objects"
description: "LeetCode 101 record from 2022-08-02"
date: 2022-08-02
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
First Attempt: 2022-08-02
- Submissions: Runtime Error ×2 → Accepted → Wrong Answer → Accepted ×4

## Approach

Symmetric means the left subtree mirrors the right. Write a function checking whether two trees mirror each other ([Tree]({{< relref "/algorithm/Tree" >}}) Template 1): equal values, with `a.left` mirroring `b.right` (outer) and `a.right` mirroring `b.left` (inner).

## My Attempts

The first two versions had syntax errors; a later one wrote `left == right`, comparing node objects instead of values, so two distinct nodes were never equal: `[3, 3, 3]` should be `True` but returned `False`.

## Solution

```python
class Solution:
    def isSymmetric(self, root: Optional[TreeNode]) -> bool:
        def mirror(a, b):
            if not a or not b:
                return a is b
            return a.val == b.val and mirror(a.left, b.right) and mirror(a.right, b.left)
        return mirror(root.left, root.right)
```

## Complexity

Time `O(n)`, space `O(h)`.

## Mistakes to Avoid

- Compare `a.val == b.val`; `a == b` checks whether they are the same object.

## Interview Explanation

I write a mirror check: equal values, with outer pairs and inner pairs mirroring too, then apply it to the root's two subtrees. Time `O(n)`.
