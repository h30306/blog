---
title: "LeetCode 429: N-ary Tree Level Order Traversal"
summary: "LeetCode 429 note: BFS level order with the children list in place of left and right"
description: "LeetCode 429 record from 2026-10-24"
date: 2026-10-24
tags: ["medium", "tree", "breadth-first-search"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-10-24
- Submissions: Accepted (first try)

## Approach

Same as level order on a binary tree ([Tree]({{< relref "/algorithm/Tree" >}}) Template 2), except the children are a `children` list instead of `left` and `right`. Record the queue length at the start of each round; the nodes popped in that round form one level.

## My Attempts

Accepted on the first try.

## Solution

```python
class Solution:
    def levelOrder(self, root: 'Node') -> List[List[int]]:
        if not root:
            return []
        q = deque([root])
        res = []
        while q:
            level = []
            for _ in range(len(q)):
                node = q.popleft()
                level.append(node.val)
                q.extend(node.children)
            res.append(level)
        return res
```

## Complexity

Time `O(n)`, space `O(w)` for the widest level.

## Mistakes to Avoid

- Return `[]` for an empty tree.
- Take the level size before the loop; the queue keeps growing inside it.

## Interview Explanation

This is BFS level order. Each round I record the queue length and pop that many nodes as one level, pushing every node's children. Time `O(n)`, space proportional to the widest level.
