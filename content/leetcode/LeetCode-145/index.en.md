---
title: "LeetCode 145: Binary Tree Postorder Traversal"
summary: "LeetCode 145 note: iterative post-order pushes a node back with a visited flag on its first pop, then the right and left children; record it on the second pop"
description: "LeetCode 145 record from 2022-08-20"
date: 2022-08-20
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
First Attempt: 2022-08-20
- Submissions: Runtime Error ×3 → Accepted ×3 → Runtime Error ×2 → Wrong Answer ×2 → Accepted ×2

## Approach

Post-order is left, right, root: the root waits until both children are done ([Tree]({{< relref "/algorithm/Tree" >}})). Push `(node, visited)`:

- First pop (`visited = False`): push itself back as `True`, then the **right** child, then the **left** (pushed last, handled first).
- Second pop (`visited = True`): both children are done, so record it.

## My Attempts

For an empty tree the first versions returned `None`; one put the nodes themselves in the answer instead of values; one pushed left before right, **so the right side was processed first**: with root 9, left 8 and right 5 the answer is `[8, 5, 9]`; it returned `[5, 8, 9]`.

## Solution

```python
class Solution:
    def postorderTraversal(self, root: Optional[TreeNode]) -> List[int]:
        res, stack = [], [(root, False)]
        while stack:
            node, visited = stack.pop()
            if not node:
                continue
            if visited:
                res.append(node.val)
            else:
                stack.append((node, True))
                stack.append((node.right, False))
                stack.append((node.left, False))
        return res
```

## Complexity

Time `O(n)`, space `O(h)`.

## Mistakes to Avoid

- Push right then left so the left is processed first.
- Return values, not nodes.

## Interview Explanation

Post-order records the root after both children, so the stack holds a node plus whether it was expanded. The first pop pushes it back with its right and left children; the second pop records it. Time `O(n)`.
