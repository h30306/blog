---
title: "LeetCode 222: Count Complete Tree Nodes"
summary: "LeetCode 222 note: in a complete tree, equal leftmost depths on both sides mean one side is perfect, counted as 2^h - 1, for O(log² n)"
description: "LeetCode 222 record from 2022-11-18"
date: 2022-11-18
tags: ["medium", "binary-search", "bit-manipulation", "tree", "binary-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-11-18
- Submissions: Runtime Error → Accepted ×3 → Restrictions Failed → Accepted

## Approach

For a complete tree, compare the leftmost depths of the left and right subtrees ([Tree]({{< relref "/algorithm/Tree" >}})):

- Equal: the left subtree is **perfect** with `2^h - 1` nodes; add the root and recurse on the right.
- Right shallower: the right subtree is perfect (one level shorter); recurse on the left.

Each level recurses on one side and each height costs `O(log n)`, so `O(log² n)` in total.

## My Attempts

In 2022 the first version had an undefined variable, and then a plain node-counting traversal (`O(n)`) passed. Rewriting it in 2026, I compared the leftmost and rightmost heights: equal means the whole tree is perfect and uses the formula, otherwise recurse on both sides, also `O(log² n)`. The version here compares the two subtrees' leftmost depths and recurses on only one side per level.

## Solution

```python
class Solution:
    def countNodes(self, root: Optional[TreeNode]) -> int:
        def depth(node):
            d = 0
            while node:
                d, node = d + 1, node.left
            return d
        if not root:
            return 0
        l, r = depth(root.left), depth(root.right)
        if l == r:                                   # 左子樹是滿的
            return (1 << l) + self.countNodes(root.right)
        return (1 << r) + self.countNodes(root.left)    # 右子樹是滿的
```

## Complexity

Time `O(log² n)`, space `O(log n)`.

## Mistakes to Avoid

- `1 << h` already includes the root: `2^h - 1` subtree nodes plus 1.

## Interview Explanation

In a complete tree one subtree is always perfect. I compare the leftmost depths, count the perfect side by formula, and recurse on the other. One side per level, so `O(log² n)`.
