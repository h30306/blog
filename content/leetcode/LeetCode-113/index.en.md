---
title: "LeetCode 113: Path Sum II"
summary: "LeetCode 113 note: backtrack with the current path and store a copy at a leaf whose total matches; values can be negative, so no early pruning"
description: "LeetCode 113 record from 2022-11-18"
date: 2022-11-18
tags: ["medium", "backtracking", "tree", "depth-first-search", "binary-tree"]
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
- Submissions: Wrong Answer → Accepted → Wrong Answer → Accepted

## Approach

Subtract down the tree as in LC 112, but record the whole path ([Backtracking]({{< relref "/algorithm/Backtracking" >}})): append on entering a node, save a copy at a matching leaf, and pop on leaving.

**Values can be negative**, so exceeding the target so far does not rule out later nodes; no pruning.

## My Attempts

Both WAs had the same pruning: stop when `targetSum - root.val < 0`. Values can be negative, though: `[4, -1]`, `targetSum = 3` gives `4 - 1 = 3`, so the answer is `[[4, -1]]`; it pruned at the root and returned nothing.

## Solution

```python
class Solution:
    def pathSum(self, root: Optional[TreeNode], targetSum: int) -> List[List[int]]:
        res, path = [], []
        def dfs(node, rest):
            if not node:
                return
            path.append(node.val)
            rest -= node.val
            if not node.left and not node.right and rest == 0:
                res.append(path[:])                  # 存複本
            dfs(node.left, rest)
            dfs(node.right, rest)
            path.pop()
        dfs(root, targetSum)
        return res
```

## Complexity

Time `O(n · h)` (copying paths), space `O(h)`.

## Mistakes to Avoid

- With negative values, do not prune on "already over".
- Store a copy, `path[:]`.

## Interview Explanation

I backtrack with the current path, adding each value and reducing the target on the way down, saving a copy when a leaf leaves 0, and popping on the way back. Values can be negative, so there is no pruning. Time `O(n · h)`.
