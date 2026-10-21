---
title: "LeetCode 872: Leaf-Similar Trees"
summary: "LeetCode 872 note: collect leaves left to right with DFS; BFS collects level by level, which is not left-to-right order"
description: "LeetCode 872 record from 2022-09-17"
date: 2022-09-17
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
First Attempt: 2022-09-17
- Submissions: Wrong Answer ×2 → Accepted ×7 → Runtime Error → Accepted

## Approach

The leaf sequence is in **left-to-right** order, which is exactly the order a DFS (left before right) finds leaves ([Tree]({{< relref "/algorithm/Tree" >}}) Template 1). Collect for both trees and compare.

## My Attempts

The first two versions collected leaves with a BFS queue, which orders them level by level. For `[4, None, 3, 2, 2, 8, None, 1]` and `[3, 5, None, 4, 8, None, 1]`, the left-to-right leaves are `[8, 1]` and `[1, 8]`, so the answer is `False`; BFS collected `[8, 1]` for both and it returned `True`.

## Solution

```python
class Solution:
    def leafSimilar(self, root1: Optional[TreeNode], root2: Optional[TreeNode]) -> bool:
        def leaves(node):
            if not node:
                return []
            if not node.left and not node.right:
                return [node.val]
            return leaves(node.left) + leaves(node.right)
        return leaves(root1) == leaves(root2)
```

## Complexity

Time `O(n + m)`, space `O(n + m)`.

## Mistakes to Avoid

- With BFS, a shallower leaf comes before a deeper leaf further left, which is the wrong order.

## Interview Explanation

I collect each tree's leaves with a left-first DFS, which yields left-to-right order, and compare the sequences. Time `O(n + m)`.
