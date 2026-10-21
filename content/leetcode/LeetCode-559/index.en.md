---
title: "LeetCode 559: Maximum Depth of N-ary Tree"
summary: "LeetCode 559 note: depth is 1 plus the deepest child, or 1 with no children"
description: "LeetCode 559 record from 2022-08-27"
date: 2022-08-27
tags: ["easy", "tree", "depth-first-search", "breadth-first-search"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-27
- Submissions: Runtime Error ×3 → Wrong Answer → Runtime Error → Accepted → Runtime Error → Accepted

## Approach

The same post-order return value as a binary tree ([Tree]({{< relref "/algorithm/Tree" >}}) Template 1), with children in a list: `1 + max(depth of each child)`. With no children, `max` on an empty sequence needs a default of 0.

## My Attempts

The early versions mishandled empty trees or childless nodes: reading `None.children` or taking `max` of an empty list.

## Solution

```python
class Solution:
    def maxDepth(self, root: 'Node') -> int:
        if not root:
            return 0
        return 1 + max((self.maxDepth(c) for c in root.children), default=0)
```

## Complexity

Time `O(n)`, space `O(h)`.

## Mistakes to Avoid

- An empty tree returns 0.
- Give `max` a `default` when there are no children.

## Interview Explanation

An n-ary tree's depth is 1 plus its deepest child, computed recursively with a default of 0 for no children. Time `O(n)`.
