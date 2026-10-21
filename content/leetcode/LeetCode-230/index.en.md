---
title: "LeetCode 230: Kth Smallest Element in a BST"
summary: "LeetCode 230 note: a BST's in-order traversal is ascending, so stop an iterative in-order walk at the k-th node"
description: "LeetCode 230 record from 2022-10-29"
date: 2022-10-29
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
First Attempt: 2022-10-29
- Submissions: Runtime Error → Wrong Answer ×2 → Accepted ×5 → Wrong Answer ×3 → Accepted ×2

## Approach

An in-order traversal of a BST is ascending ([Tree]({{< relref "/algorithm/Tree" >}}) Template 3). Run an iterative in-order (as in LC 94), decrementing `k` on each pop; when it hits 0 that node is the answer, without walking the whole tree.

## My Attempts

One version returned the node instead of its value; several later rewrites returned `None`.

## Solution

```python
class Solution:
    def kthSmallest(self, root: Optional[TreeNode], k: int) -> int:
        stack, cur = [], root
        while True:
            while cur:
                stack.append(cur)
                cur = cur.left
            cur = stack.pop()
            k -= 1
            if k == 0:
                return cur.val
            cur = cur.right
```

## Complexity

Time `O(h + k)`, space `O(h)`.

## Mistakes to Avoid

- Return the value, not the node.

## Interview Explanation

A BST's in-order is ascending, so I walk it iteratively and return the k-th value. Time `O(h + k)`.
