---
title: "LeetCode 105: Construct Binary Tree from Preorder and Inorder Traversal"
summary: "LeetCode 105 note: the first pre-order value is the root, and its position in the in-order tells the left subtree's size; look positions up in a dictionary for O(n)"
description: "LeetCode 105 record from 2022-10-29"
date: 2022-10-29
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
First Attempt: 2022-10-29
- Submissions: Runtime Error ×4 → Wrong Answer → Accepted ×3 → Runtime Error → Accepted ×2 → Runtime Error → Accepted

## Approach

Pre-order is root, left, right, so the first value in range is the root; in-order is left, root, right, so values left of the root form the left subtree ([Tree]({{< relref "/algorithm/Tree" >}})).

- Map each value to its in-order index.
- Take pre-order values in sequence as roots, building the left subtree before the right (matching pre-order).
- An in-order range `[lo, hi]` defines each subtree; an empty range returns `None`.

## My Attempts

The early slicing versions kept hitting out-of-range indices, popping an empty list, and undefined variables; one created nodes with `TreeNode(index_root_node)`, **using the in-order index instead of the value**, so `[8]` returned `[0]`.

## Solution

```python
class Solution:
    def buildTree(self, preorder: List[int], inorder: List[int]) -> Optional[TreeNode]:
        pos = {v: i for i, v in enumerate(inorder)}
        it = iter(preorder)
        def build(lo, hi):
            if lo > hi:
                return None
            val = next(it)
            root = TreeNode(val)
            root.left = build(lo, pos[val] - 1)          # 先建左子樹
            root.right = build(pos[val] + 1, hi)
            return root
        return build(0, len(inorder) - 1)
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- The node's value is the pre-order value, not its in-order index.
- Build the left subtree first so the pre-order pointer stays in sync.
- `list.index` each time is `O(n)`, making it `O(n²)`; a dictionary is `O(1)`.

## Interview Explanation

The first pre-order value is the root, and its in-order position splits the in-order into subtrees. I map in-order positions, take roots from the pre-order in sequence, and build the left subtree before the right. Time `O(n)`.
