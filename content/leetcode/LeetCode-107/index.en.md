---
title: "LeetCode 107: Binary Tree Level Order Traversal II"
summary: "LeetCode 107 note: a normal level-order traversal reversed at the end gives bottom-up order"
description: "LeetCode 107 record from 2022-11-18"
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
- Submissions: Accepted ×2

## Approach

Collect level by level as in LC 102 ([Tree]({{< relref "/algorithm/Tree" >}}) Template 2), then reverse the whole result so it starts from the bottom level.

## My Solution

```python
class Solution:
    def levelOrderBottom(self, root: Optional[TreeNode]) -> List[List[int]]:
        res, level = [], [root] if root else []
        while level:
            res.append([n.val for n in level])
            level = [c for n in level for c in (n.left, n.right) if c]
        return res[::-1]
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Reverse the order of levels; each level stays left to right.

## Interview Explanation

I collect levels with a normal BFS and reverse their order at the end. Time `O(n)`.
