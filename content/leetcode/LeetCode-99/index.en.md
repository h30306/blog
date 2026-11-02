---
title: "LeetCode 99: Recover Binary Search Tree"
summary: "LeetCode 99 note: find the inversions in the in-order sequence: the earlier node of the first inversion and the later node of the last one were swapped"
description: "LeetCode 99 record from 2026-10-25"
date: 2026-10-25
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
First Attempt: 2026-10-25
- Submissions: Accepted (first try)

## Approach

The in-order traversal of a BST is strictly increasing ([Tree]({{< relref "/algorithm/Tree" >}}) Template 3). After two values are swapped, the in-order sequence contains inversions where the previous value is larger than the current one:

- If the two nodes are **not adjacent** in in-order, there are two inversions. For `1 5 3 4 2 6` they are `5 > 3` and `4 > 2`. The swapped nodes are the **earlier** node of the first inversion (5) and the **later** node of the last inversion (2).
- If they are **adjacent**, there is one inversion, e.g. `1 3 2 4`, and both nodes are in it.

So walk in-order and keep the previous node in `prev`:

- On the first `prev.val > node.val`, set `first = prev`.
- On every inversion, set `second = node`.

Then swap the values of `first` and `second`. Both cases give the right pair.

## My Attempts

Accepted on the first try.

## Solution

```python
class Solution:
    def recoverTree(self, root: Optional[TreeNode]) -> None:
        self.first = None
        self.second = None
        self.prev = TreeNode(-inf)

        def inorder(node):
            if not node:
                return
            inorder(node.left)
            if self.prev.val > node.val:
                if not self.first:
                    self.first = self.prev
                self.second = node
            self.prev = node
            inorder(node.right)

        inorder(root)
        self.first.val, self.second.val = self.second.val, self.first.val
```

## Complexity

Time `O(n)`, space `O(h)` for recursion. The follow-up asks for `O(1)` space, which needs a Morris in-order traversal.

## Mistakes to Avoid

- Update `second` on **every** inversion. Recording both nodes only at the first inversion swaps the wrong pair when they are not adjacent.
- Set `first` only once and never overwrite it.
- A sentinel `prev` with value `-inf` keeps the first node from looking like an inversion.
- Swap the values; no pointers need to change.

## Interview Explanation

In-order of a BST is increasing, so a swap creates inversions. If the nodes are not adjacent there are two inversions and the wrong nodes are the earlier one of the first and the later one of the last; if they are adjacent there is a single inversion containing both. I walk in-order, set `first = prev` at the first inversion, update `second = node` at every inversion, and swap the two values. Time `O(n)`, space `O(h)`; Morris traversal brings space to `O(1)`.
