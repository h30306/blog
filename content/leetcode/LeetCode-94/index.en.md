---
title: "LeetCode 94: Binary Tree Inorder Traversal"
summary: "LeetCode 94 note: iterative in-order traversal, pushing nodes while going left, recording on pop, then turning to the right subtree"
description: "LeetCode 94 record from 2022-07-20"
date: 2022-07-20
tags: ["easy", "stack", "tree", "depth-first-search", "binary-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-07-20
- Submissions: Wrong Answer ×2 → Runtime Error ×2 → Accepted → Runtime Error ×2 → Accepted → Runtime Error → Accepted ×3

## Approach

In-order is left, root, right. Recursion is direct; iteratively you simulate the call stack yourself ([Tree]({{< relref "/algorithm/Tree" >}})):

1. From the current node, walk left, pushing every node passed.
2. At the bottom, pop a node and record it (its left side is done).
3. Move to its right subtree and repeat.

## My Attempts

Most REs had the same cause: reading `root.left` / `root.val` on an **empty tree** (`root` is `None`). Another used an undefined variable (NameError).

## Solution

```python
class Solution:
    def inorderTraversal(self, root: Optional[TreeNode]) -> List[int]:
        res, stack, cur = [], [], root
        while cur or stack:
            while cur:
                stack.append(cur)
                cur = cur.left
            cur = stack.pop()
            res.append(cur.val)
            cur = cur.right
        return res
```

## Complexity

Time `O(n)`, space `O(h)` for height `h`.

## Mistakes to Avoid

- The outer condition is `cur or stack`; stop only when both are empty.

## Interview Explanation

I simulate recursion with a stack: push while going left, pop and record at the bottom, then turn to the right subtree. Each node enters and leaves once. Time `O(n)`, space `O(h)`.
