---
title: "LeetCode 700: Search in a Binary Search Tree"
summary: "LeetCode 700 note: go left when the node is larger, right when smaller, and return the node when found"
description: "LeetCode 700 record from 2022-08-31"
date: 2022-08-31
tags: ["easy", "tree", "binary-search-tree", "binary-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-31
- Submissions: Accepted (first try)

## Approach

BST search ([Tree]({{< relref "/algorithm/Tree" >}}) Template 3): larger than the target goes left, smaller goes right, equal is found; reaching `None` means absent.

## My Solution

```python
class Solution:
    def searchBST(self, root: Optional[TreeNode], val: int) -> Optional[TreeNode]:
        while root and root.val != val:
            root = root.left if val < root.val else root.right
        return root
```

## Complexity

Time `O(h)`, space `O(1)`.

## Mistakes to Avoid

- Return the node (its whole subtree), not the value.

## Interview Explanation

From the root I go left when larger and right when smaller, returning on a match or at `None`. Time `O(h)`, space `O(1)`.
