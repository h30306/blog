---
title: "LeetCode 404: Sum of Left Leaves"
summary: "LeetCode 404 note: tell each child during DFS whether it is a left child, adding only left children that are leaves"
description: "LeetCode 404 record from 2022-08-23"
date: 2022-08-23
tags: ["easy", "tree", "depth-first-search", "breadth-first-search", "binary-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-23
- Submissions: Runtime Error → Wrong Answer ×3 → Accepted ×3

## Approach

A left leaf needs two facts: it is a leaf, and it is its parent's **left** child ([Tree]({{< relref "/algorithm/Tree" >}}) Template 1). Pass a boolean `is_left` down and decide at each leaf.

## My Attempts

Two versions marked sides with the strings `'True'` and `'False'`, but **the string `'False'` is truthy too**, so right leaves were added. For `[4, 6, 9]` only 6 is a left leaf, answer 6; they returned 15.

## Solution

```python
class Solution:
    def sumOfLeftLeaves(self, root: Optional[TreeNode]) -> int:
        def dfs(node, is_left):
            if not node:
                return 0
            if not node.left and not node.right:
                return node.val if is_left else 0
            return dfs(node.left, True) + dfs(node.right, False)
        return dfs(root, False)
```

## Complexity

Time `O(n)`, space `O(h)`.

## Mistakes to Avoid

- The root is never a left leaf, even when it is a leaf.
- Use real booleans; the string `'False'` is truthy.

## Interview Explanation

I pass an "is left child" flag during DFS and add a value only at leaves that are left children. Time `O(n)`.
