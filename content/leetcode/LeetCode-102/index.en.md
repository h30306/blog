---
title: "LeetCode 102: Binary Tree Level Order Traversal"
summary: "LeetCode 102 note: BFS one whole level at a time, building the next level from the current one; an empty tree returns an empty list"
description: "LeetCode 102 record from 2022-10-29"
date: 2022-10-29
tags: ["medium", "tree", "breadth-first-search", "binary-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-10-29
- Submissions: Wrong Answer → Runtime Error ×2 → Time Limit Exceeded → Wrong Answer → Runtime Error → Wrong Answer → Accepted → Wrong Answer → Accepted ×4

## Approach

BFS naturally goes level by level ([Tree]({{< relref "/algorithm/Tree" >}}) Template 2). Each round takes every node on the current level, records their values, and collects their children as the next level.

## My Attempts

Most failures were on the empty tree: returning `[[]]` (an extra empty level), using an undefined variable, or a loop with no exit (TLE); one returned `[3]` instead of `[[3]]`.

## Solution

```python
class Solution:
    def levelOrder(self, root: Optional[TreeNode]) -> List[List[int]]:
        res, level = [], [root] if root else []
        while level:
            res.append([n.val for n in level])
            level = [c for n in level for c in (n.left, n.right) if c]
        return res
```

## Complexity

Time `O(n)`, space `O(w)` for the widest level `w`.

## Mistakes to Avoid

- An empty tree returns `[]`, not `[[]]`.

## Interview Explanation

With BFS, each round handles a whole level: record its values, then gather all children as the next level until none remain. Time `O(n)`.
