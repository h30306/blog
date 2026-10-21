---
title: "LeetCode 938: Range Sum of BST"
summary: "LeetCode 938 note: prune with the BST order, going only right below low and only left above high, adding nodes inside the range"
description: "LeetCode 938 record from 2022-09-26"
date: 2022-09-26
tags: ["easy", "tree", "depth-first-search", "binary-search-tree", "binary-tree"]
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
- Submissions: Accepted ×3 → Wrong Answer → Runtime Error → Accepted ×2 → Wrong Answer → Accepted

## Approach

The BST order skips impossible subtrees ([Tree]({{< relref "/algorithm/Tree" >}}) Template 3):

- Node `< low`: it and its whole left subtree are too small, so look only right.
- Node `> high`: look only left.
- Inside the range: add it and look both ways.

## My Attempts

In September 2022 one version defined the recursive helper but **never called it** (and modified the outer `sum_` without `nonlocal`), returning 0. The November rewrite started from `low + high`, **assuming both are values in the tree**; it passed the tests, but nothing guarantees that: `[9]` with `low = high = 5` returns 10 instead of 0.

## Solution

```python
class Solution:
    def rangeSumBST(self, root: Optional[TreeNode], low: int, high: int) -> int:
        if not root:
            return 0
        if root.val < low:
            return self.rangeSumBST(root.right, low, high)
        if root.val > high:
            return self.rangeSumBST(root.left, low, high)
        return root.val + self.rangeSumBST(root.left, low, high) + self.rangeSumBST(root.right, low, high)
```

## Complexity

Time `O(n)` worst case, space `O(h)`.

## Mistakes to Avoid

- Both ends of the range are inclusive.
- Do not assume `low` and `high` are values in the tree.

## Interview Explanation

I prune with the BST order: below `low` search only right, above `high` only left, and inside the range add the node and search both. Worst case `O(n)`.
