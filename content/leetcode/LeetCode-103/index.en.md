---
title: "LeetCode 103: Binary Tree Zigzag Level Order Traversal"
summary: "LeetCode 103 note: a normal level-order traversal with every odd level reversed gives the zigzag"
description: "LeetCode 103 record from 2022-11-18"
date: 2022-11-18
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
First Attempt: 2022-11-18
- Submissions: Accepted (first try)

## Approach

Collect level by level ([Tree]({{< relref "/algorithm/Tree" >}}) Template 2): levels 0, 2, 4, ... left to right, and levels 1, 3, 5, ... reversed. The order of building the next level stays the same; only the recorded direction changes.

## My Solution

```python
class Solution:
    def zigzagLevelOrder(self, root: Optional[TreeNode]) -> List[List[int]]:
        res, level = [], [root] if root else []
        while level:
            vals = [n.val for n in level]
            res.append(vals if len(res) % 2 == 0 else vals[::-1])
            level = [c for n in level for c in (n.left, n.right) if c]
        return res
```

## Complexity

Time `O(n)`, space `O(w)`.

## Mistakes to Avoid

- Reverse only the recorded values, not the order of building the next level.

## Interview Explanation

I run a normal BFS and reverse the recorded values on odd levels, leaving the next-level order unchanged. Time `O(n)`.
