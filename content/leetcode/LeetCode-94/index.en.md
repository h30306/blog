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
- 2026-10-24 rewrite: Accepted ×2

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

## 2026-10 Rewrite

This time I wrote two recursive versions, both accepted on the first try:

1. `return left + [root.val] + right`: every level concatenates the subtree results into a new list, which keeps copying on a skewed tree, `O(n^2)` in the worst case.
2. One outer `res` that the DFS appends to, `O(n)`.

Recursion is straightforward, but the follow-up asks for an iterative version, so the stack approach above is still the one to know.

## Complexity

Time `O(n)`, space `O(h)` for height `h`.

## Mistakes to Avoid

- The outer condition is `cur or stack`; stop only when both are empty.

## Interview Explanation

I simulate recursion with a stack: push while going left, pop and record at the bottom, then turn to the right subtree. Each node enters and leaves once. Time `O(n)`, space `O(h)`.
