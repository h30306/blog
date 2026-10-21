---
title: "LeetCode 199: Binary Tree Right Side View"
summary: "LeetCode 199 note: in a level-order traversal, each level's rightmost node is what you see from the right"
description: "LeetCode 199 record from 2022-10-29"
date: 2022-10-29
tags: ["medium", "tree", "depth-first-search", "breadth-first-search", "binary-tree"]
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
- Submissions: Time Limit Exceeded → Accepted → Runtime Error → Accepted ×2

## Approach

From the right you see only the rightmost node of each level ([Tree]({{< relref "/algorithm/Tree" >}}) Template 2). Walk levels with BFS and record each level's last node.

## My Attempts

Attempt 1's loop never moved to the next level, looping forever on a single node `[6]` (TLE); another missed the empty tree.

## Solution

```python
class Solution:
    def rightSideView(self, root: Optional[TreeNode]) -> List[int]:
        res, level = [], [root] if root else []
        while level:
            res.append(level[-1].val)
            level = [c for n in level for c in (n.left, n.right) if c]
        return res
```

## Complexity

Time `O(n)`, space `O(w)`.

## Mistakes to Avoid

- The rightmost node is not always a right child: when the right subtree is shorter, deeper left-subtree nodes show.

## Interview Explanation

The right view is each level's rightmost node, so I BFS level by level and record the last one. Time `O(n)`.
