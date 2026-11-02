---
title: "LeetCode 104: Maximum Depth of Binary Tree"
summary: "LeetCode 104 note: depth is 1 plus the larger subtree depth, with 0 for an empty tree"
description: "LeetCode 104 record from 2022-08-02"
date: 2022-08-02
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
First Attempt: 2022-08-02
- Submissions: Accepted → Runtime Error → Accepted ×2 → Wrong Answer ×2 → Accepted → Runtime Error → Accepted ×3
- 2026-10-24 rewrite: Accepted (first try)

## Approach

A post-order return value ([Tree]({{< relref "/algorithm/Tree" >}}) Template 1): an empty tree has depth 0, otherwise `1 + max(left depth, right depth)`.

## My Attempts

The first version passed. Rewriting it as a DFS with a `depth` parameter, a leaf returned 0 instead of the current `depth` (`[5]` returned 0), and one version returned `None` for an empty tree.

## Solution

```python
class Solution:
    def maxDepth(self, root: Optional[TreeNode]) -> int:
        if not root:
            return 0
        return 1 + max(self.maxDepth(root.left), self.maxDepth(root.right))
```

## 2026-10 Rewrite

Accepted on the first try. This time I used a DFS with a depth parameter and updated the maximum with `nonlocal` at the leaves. In 2022 a depth-parameter version failed because leaves returned 0; this time nothing depends on return values, since leaves update an outer variable. The post-order return-value version is still the shortest.

## Complexity

Time `O(n)`, space `O(h)`.

## Mistakes to Avoid

- Every path of the recursive function needs a return value.

## Interview Explanation

An empty tree has depth 0, otherwise 1 plus the deeper subtree, computed by post-order recursion. Time `O(n)`, space `O(h)`.
