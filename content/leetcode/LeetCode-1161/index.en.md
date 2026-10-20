---
title: "LeetCode 1161: Maximum Level Sum of a Binary Tree"
summary: "LeetCode 1161 note: pushing None into the next level creates a fake level with sum 0"
description: "LeetCode 1161 record from 2026-01-06"
date: 2026-01-06
tags: ["medium", "tree", "binary-tree", "bfs"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-06
- Submissions: Wrong Answer → Accepted

## Approach

Compute the sum of each level and return the level with the largest sum; on ties, return the smallest level number. This is standard BFS level order.

## My First Attempt: one recursive call per level

```python
def bfs(nodes, curr_level):
    if not nodes:
        return float("-inf"), -1
    curr_sum = 0
    next_layer_nodes = []
    for node in nodes:
        if node:
            curr_sum += node.val
            next_layer_nodes.append(node.left)     # None goes in too
            next_layer_nodes.append(node.right)
    next_layer_sum, next_level = bfs(next_layer_nodes, curr_level + 1)
    ...
```

The bug is **pushing `None` children into the next level**. The last real level has no children, so the next level is a list of `None` values. That list is not empty, so it is treated as a real level with sum 0.

If every real level sum is negative, this nonexistent "sum 0 level" wins.

The fix is to push only non-empty children.

## Solution

The second attempt added `if node.left` and `if node.right` and passed. Still, one recursive call per level makes the recursion depth equal to the number of levels, which can hit Python's recursion limit on a chain-shaped tree. Iterative BFS is safer:

```python
from collections import deque

class Solution:
    def maxLevelSum(self, root: Optional[TreeNode]) -> int:
        best_sum, best_level = float("-inf"), 0
        q = deque([root])
        level = 0
        while q:
            level += 1
            level_sum = 0
            for _ in range(len(q)):
                node = q.popleft()
                level_sum += node.val
                if node.left:
                    q.append(node.left)
                if node.right:
                    q.append(node.right)
            if level_sum > best_sum:          # > keeps the smallest level on ties
                best_sum, best_level = level_sum, level
        return best_level
```

## Complexity

Time `O(n)`, space `O(w)`, where `w` is the size of the widest level.

## Mistakes to Avoid

- Pushing `None` into the queue and getting a fake level with sum 0.
- Using `>=` on ties, which returns the larger level number.
- Starting the best sum at 0, which fails when every level sum is negative.

## Interview Explanation

I run BFS level by level: record the queue length before each level, add up that level, and push only non-empty children. I update the best only when the sum is strictly larger, so ties keep the smaller level number. The best sum starts at negative infinity because values can be negative. Time `O(n)`.
