---
title: "LeetCode 129: Sum Root to Leaf Numbers"
summary: "LeetCode 129 note: on the way down multiply the current number by 10 and add the node's value, adding it to the total at a leaf"
description: "LeetCode 129 record from 2022-11-18"
date: 2022-11-18
tags: ["medium", "tree", "depth-first-search", "binary-tree"]
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
- Submissions: Accepted ×2 → Runtime Error → Accepted

## Approach

Each level adds a digit: `num = num * 10 + node.val` ([Tree]({{< relref "/algorithm/Tree" >}}) Template 1). At a leaf the path's number is complete and joins the total. Integer arithmetic beats building strings.

## My Attempts

In 2024 one version missed nodes with a single child: it recursed into `None` and read `node.left`, failing on `[9, 9]` (left child only).

## Solution

```python
class Solution:
    def sumNumbers(self, root: Optional[TreeNode]) -> int:
        def dfs(node, num):
            if not node:
                return 0
            num = num * 10 + node.val
            if not node.left and not node.right:
                return num
            return dfs(node.left, num) + dfs(node.right, num)
        return dfs(root, 0)
```

## Complexity

Time `O(n)`, space `O(h)`.

## Mistakes to Avoid

- With one child, the empty side returns 0 instead of reading `None`.

## Interview Explanation

Recursing down, I multiply the current number by 10 and add the node's value, return it at a leaf, and sum both sides. Time `O(n)`.
