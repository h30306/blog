---
title: "LeetCode 563: Binary Tree Tilt"
summary: "LeetCode 563 note: return subtree sums in post-order; each node's tilt is the difference of its subtree sums, added to the answer"
description: "LeetCode 563 record from 2022-08-27"
date: 2022-08-27
tags: ["easy", "tree", "depth-first-search", "binary-tree", "dp-on-trees"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-27
- Submissions: Time Limit Exceeded ×2 → Wrong Answer → Runtime Error ×2 → Wrong Answer ×3 → Accepted

## Approach

A node's tilt is the difference between the sum of **all nodes** in its left subtree and in its right subtree ([Tree]({{< relref "/algorithm/Tree" >}}) Template 1). A post-order recursion returns whole-subtree sums while adding each tilt to the answer.

## My Attempts

The early versions missed the empty tree or recomputed in loops (TLE). Later errors were all in the return value: the recursion returned **the children's values** rather than whole-subtree sums, so `[4, 6]` gave 0 instead of 6; after adding the node's own value it still returned `root.val + left child + right child`, missing deeper nodes.

## Solution

```python
class Solution:
    def findTilt(self, root: Optional[TreeNode]) -> int:
        total = 0
        def subtree_sum(node):
            nonlocal total
            if not node:
                return 0
            l, r = subtree_sum(node.left), subtree_sum(node.right)
            total += abs(l - r)
            return node.val + l + r
        subtree_sum(root)
        return total
```

## Complexity

Time `O(n)`, space `O(h)`.

## Mistakes to Avoid

- Return the whole subtree's sum, not the children's values.

## Interview Explanation

A post-order pass returns each subtree's sum and adds the difference of the two sums at every node. One pass, time `O(n)`.
