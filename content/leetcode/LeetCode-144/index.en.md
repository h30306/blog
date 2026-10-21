---
title: "LeetCode 144: Binary Tree Preorder Traversal"
summary: "LeetCode 144 note: iterative pre-order traversal records on pop and pushes the right child before the left so the left is handled first"
description: "LeetCode 144 record from 2022-07-20"
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
- Submissions: Runtime Error → Wrong Answer ×2 → Runtime Error → Accepted ×4

## Approach

Pre-order is root, left, right, recording on pop ([Tree]({{< relref "/algorithm/Tree" >}})). A stack is last in, first out, so **push the right child before the left** to pop the left first.

## My Attempts

Most REs had the same cause: reading `root.left` / `root.val` on an **empty tree** (`root` is `None`).

## Solution

```python
class Solution:
    def preorderTraversal(self, root: Optional[TreeNode]) -> List[int]:
        res, stack = [], [root] if root else []
        while stack:
            node = stack.pop()
            res.append(node.val)
            if node.right:
                stack.append(node.right)
            if node.left:
                stack.append(node.left)
        return res
```

## Complexity

Time `O(n)`, space `O(h)`.

## Mistakes to Avoid

- Push in the reverse of the order you want to process.

## Interview Explanation

Pre-order is root, left, right: pop and record, pushing right before left so the left subtree comes first. Time `O(n)`.
