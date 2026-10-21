---
title: "LeetCode 2331: Evaluate Boolean Binary Tree"
summary: "LeetCode 2331 note: leaves are 0 or 1 and internal nodes are 2 for OR and 3 for AND, evaluated in post-order"
description: "LeetCode 2331 record from 2022-11-18"
date: 2022-11-18
tags: ["easy", "tree", "depth-first-search", "binary-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-11-18
- Submissions: Accepted (first try)

## Approach

Post-order: evaluate both subtrees, then apply OR or AND by the node's value ([Tree]({{< relref "/algorithm/Tree" >}}) Template 1). The tree is full (every internal node has two children), and a leaf's value is its result.

## My Solution

```python
class Solution:
    def evaluateTree(self, root: Optional[TreeNode]) -> bool:
        if not root.left:
            return bool(root.val)
        l, r = self.evaluateTree(root.left), self.evaluateTree(root.right)
        return l or r if root.val == 2 else l and r
```

## Complexity

Time `O(n)`, space `O(h)`.

## Mistakes to Avoid

- Checking for a left child identifies leaves, since internal nodes always have both.

## Interview Explanation

Leaves return their own boolean; internal nodes evaluate both children and apply OR or AND, in a post-order recursion. Time `O(n)`.
