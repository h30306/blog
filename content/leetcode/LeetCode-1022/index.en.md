---
title: "LeetCode 1022: Sum of Root To Leaf Binary Numbers"
summary: "LeetCode 1022 note: on the way down double the current number and add the node's bit, adding it to the total at a leaf"
description: "LeetCode 1022 record from 2022-09-27"
date: 2022-09-27
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
First Attempt: 2022-09-27
- Submissions: Runtime Error → Wrong Answer ×2 → Runtime Error → Wrong Answer ×3 → Accepted → Runtime Error ×4 → Accepted → Wrong Answer ×2 → Accepted → Wrong Answer → Runtime Error → Wrong Answer → Runtime Error → Accepted

## Approach

The same as LC 129 in binary: `num = num * 2 + node.val` ([Tree]({{< relref "/algorithm/Tree" >}}) Template 1), added to the total at each leaf.

## My Attempts

This took 21 submissions in 2022, mostly from tracking paths as strings:

- Settling paths at `None` positions: every leaf has two `None` children, **so each path counted twice**, and dividing the total by 2 broke whenever a node had one child. For `[1, 1, 0, 0]` the answer is `6 + 2 = 8`; it returned 9.
- `int('', 2)` on an empty string (ValueError), or adding strings to integers (TypeError).

## Solution

```python
class Solution:
    def sumRootToLeaf(self, root: Optional[TreeNode]) -> int:
        def dfs(node, num):
            if not node:
                return 0
            num = num * 2 + node.val
            if not node.left and not node.right:
                return num
            return dfs(node.left, num) + dfs(node.right, num)
        return dfs(root, 0)
```

## Complexity

Time `O(n)`, space `O(h)`.

## Mistakes to Avoid

- Settle only at leaves; reaching `None` is not a path.

## Interview Explanation

Recursing down, I shift the current number left and add the node's bit, return it at a leaf, and sum both sides. Time `O(n)`.
