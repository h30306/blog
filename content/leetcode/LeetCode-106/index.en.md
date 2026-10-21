---
title: "LeetCode 106: Construct Binary Tree from Inorder and Postorder Traversal"
summary: "LeetCode 106 note: the last post-order value is the root; taking roots from the end of the post-order, build the right subtree before the left"
description: "LeetCode 106 record from 2022-11-10"
date: 2022-11-10
tags: ["medium", "array", "hash-table", "divide-and-conquer", "tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-11-10
- Submissions: Accepted ×2 → Runtime Error → Accepted

## Approach

The same idea as LC 105, but the root is **last** in the post-order ([Tree]({{< relref "/algorithm/Tree" >}})). Taking values from the end gives root, right, left, so **build the right subtree first** to keep the pointer in sync.

## My Attempts

Right after LC 105 this came quickly; only one version sliced the wrong range (ValueError).

## Solution

```python
class Solution:
    def buildTree(self, inorder: List[int], postorder: List[int]) -> Optional[TreeNode]:
        pos = {v: i for i, v in enumerate(inorder)}
        it = reversed(postorder)
        def build(lo, hi):
            if lo > hi:
                return None
            val = next(it)
            root = TreeNode(val)
            root.right = build(pos[val] + 1, hi)         # 先建右子樹
            root.left = build(lo, pos[val] - 1)
            return root
        return build(0, len(inorder) - 1)
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- From the end of the post-order the order is root, right, left; build the right subtree first.

## Interview Explanation

The last post-order value is the root, splitting the in-order. Taking roots from the end of the post-order, I build the right subtree first, then the left, with in-order positions from a dictionary. Time `O(n)`.
