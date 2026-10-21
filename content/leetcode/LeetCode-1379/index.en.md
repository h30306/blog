---
title: "LeetCode 1379: Find a Corresponding Node of a Binary Tree in a Clone of That Tree"
summary: "LeetCode 1379 note: walk both trees in lockstep; when the original reaches target, the clone's node at the same position is the answer, comparing node identity"
description: "LeetCode 1379 record from 2022-11-17"
date: 2022-11-17
tags: ["easy", "tree", "depth-first-search", "breadth-first-search", "binary-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-11-17
- Submissions: Accepted ×3

## Approach

The clone has the same shape, so walk both trees **in lockstep** ([Tree]({{< relref "/algorithm/Tree" >}}) Template 1). When the original reaches `target` (compared by identity, since values may repeat), the clone's node at that step is the answer.

## My Solution

```python
class Solution:
    def getTargetCopy(self, original: TreeNode, cloned: TreeNode, target: TreeNode) -> TreeNode:
        if not original:
            return None
        if original is target:
            return cloned
        return (self.getTargetCopy(original.left, cloned.left, target)
                or self.getTargetCopy(original.right, cloned.right, target))
```

## Complexity

Time `O(n)`, space `O(h)`.

## Mistakes to Avoid

- Compare node identity with `is`, not values.

## Interview Explanation

The clone has the same structure, so I recurse through both together and return the clone's node when the original reaches the target. Time `O(n)`.
